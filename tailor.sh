#!/bin/bash
# ============================================================
#  Multi-Stage AI Job Tailoring Pipeline v2.0
#  Webhook → Validate → Prompt Engineering → Gemini 2.5 →
#  Response Parser → ATS Scorer → Output Formatter → API
# ============================================================

SERVER="http://161.35.161.149"
COMPANY="${1:-Unknown}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

bar() { printf "${DIM}"; printf '%.0s─' $(seq 1 60); printf "${NC}\n"; }

if [ -z "$1" ]; then
    echo -e "${BOLD}AI Job Tailoring Pipeline v2.0${NC}"
    bar
    echo -e "Usage: ${CYAN}./tailor.sh ${YELLOW}<company-name>${NC}"
    echo -e "Example: ${DIM}./tailor.sh 'ARM Ltd'${NC}"
    echo ""
    echo "Paste the job description, then press Ctrl+D"
    exit 1
fi

echo ""
echo -e "${BOLD}    AI JOB TAILORING PIPELINE v2.0${NC}"
bar
echo -e "  ${DIM}Target:${NC}  ${BOLD}$COMPANY${NC}"
echo -e "  ${DIM}Engine:${NC}  Gemini 2.5 Flash Lite"
echo -e "  ${DIM}Stages:${NC}  Validate → Prompt → AI → Parse → Score → Format"
bar
echo ""
echo -e "${CYAN}Paste the job description below, then press Ctrl+D:${NC}"
echo ""

JOB_TEXT=$(cat)

if [ -z "$JOB_TEXT" ]; then
    echo -e "${RED}Error: No job text provided${NC}"
    exit 1
fi

echo ""
bar

# Stage indicators
echo -e "  ${YELLOW}[1/6]${NC} Validating input...          ${GREEN}done${NC}"
echo -e "  ${YELLOW}[2/6]${NC} Engineering prompt...        ${GREEN}done${NC}"
echo -e "  ${YELLOW}[3/6]${NC} Calling Gemini 2.5 Flash...  ${DIM}(waiting)${NC}"

TMPFILE=$(mktemp)
PAYFILE=$(mktemp)

echo "$JOB_TEXT" | python3 -c "
import sys, json
job = sys.stdin.read()
print(json.dumps({'job_text': job, 'company': '$COMPANY'}))
" > "$PAYFILE"

HTTP_CODE=$(curl -s -w "%{http_code}" -o "$TMPFILE" -X POST "$SERVER/webhook/tailor-cv" \
    -H 'Content-Type: application/json' \
    -d @"$PAYFILE" \
    --max-time 120)

rm -f "$PAYFILE"

if [ ! -s "$TMPFILE" ]; then
    echo -e "  ${RED}[3/6] Gemini call failed (HTTP $HTTP_CODE)${NC}"
    echo -e "  ${RED}Make sure the workflow is ACTIVE in n8n${NC}"
    rm -f "$TMPFILE"
    exit 1
fi

echo -e "\033[1A\033[K  ${YELLOW}[3/6]${NC} Calling Gemini 2.5 Flash...  ${GREEN}done${NC}"
echo -e "  ${YELLOW}[4/6]${NC} Parsing AI response...       ${GREEN}done${NC}"
echo -e "  ${YELLOW}[5/6]${NC} Running ATS scorer...        ${GREEN}done${NC}"
echo -e "  ${YELLOW}[6/6]${NC} Formatting output...         ${GREEN}done${NC}"

bar
echo ""

python3 - "$TMPFILE" << 'PYEOF'
import sys, json, os

# Colors
R = '\033[0;31m'
G = '\033[0;32m'
Y = '\033[1;33m'
B = '\033[0;34m'
C = '\033[0;36m'
W = '\033[1m'
D = '\033[2m'
N = '\033[0m'

def bar():
    print(f"{D}{'─' * 60}{N}")

def score_bar(score, max_score, width=20):
    filled = int((score / max_score) * width)
    empty = width - filled
    color = G if score/max_score >= 0.7 else Y if score/max_score >= 0.5 else R
    return f"{color}{'█' * filled}{D}{'░' * empty}{N}"

with open(sys.argv[1], 'r') as f:
    raw = f.read()

if not raw.strip():
    print(f"{R}Error: Empty response{N}")
    sys.exit(1)

try:
    data = json.loads(raw)
except:
    print(f"{R}Error: Invalid JSON{N}")
    sys.exit(1)

if "error" in data:
    print(f"{R}Error: {data['error']}{N}")
    sys.exit(1)

# Handle both new structured format and flat format
scores = data.get("scores", {})
keywords = data.get("keywords", {})
tailored = data.get("tailored", {})

fit = scores.get("fit", data.get("fit_score", "?"))
ats = scores.get("ats", data.get("ats_score", "?"))
fit_label = scores.get("fit_label", "")
ats_label = scores.get("ats_label", "")
recommendation = scores.get("recommendation", "")

title = data.get("title", "Unknown")
company = data.get("company", "Unknown")
location = data.get("location", "Unknown")

kw_total = keywords.get("total", len(data.get("ats_keywords", [])))
kw_matched = keywords.get("matched", len(data.get("ats_keywords_in_cv", [])))
kw_missing_list = keywords.get("missing_list", data.get("ats_keywords_missing", []))
kw_coverage = keywords.get("coverage_pct", (kw_matched * 100 // kw_total) if kw_total > 0 else 0)
skills_line = keywords.get("optimised_skills_line", data.get("ats_optimised_skills_line", ""))

profile = tailored.get("profile", data.get("tailored_profile", ""))
bullets = tailored.get("bullets", data.get("tailored_bullets", []))
cover = tailored.get("cover_letter", data.get("cover_letter", ""))
tips = data.get("ats_tips", [])
gaps = data.get("gaps", [])
matching = data.get("matching_skills", [])

# Header
print(f"{W}  JOB ANALYSIS RESULTS{N}")
bar()
print(f"  {D}Role:{N}      {W}{title}{N}")
print(f"  {D}Company:{N}   {W}{company}{N}")
print(f"  {D}Location:{N}  {location}")
print()

# Scores
fit_num = int(fit) if str(fit).isdigit() else 0
ats_num = int(str(ats).split('/')[0]) if str(ats).replace('/100','').isdigit() else 0
rec_color = G if recommendation == 'APPLY' else R

print(f"  {W}SCORES{N}")
bar()
print(f"  Fit Score:  {score_bar(fit_num, 5, 15)}  {W}{fit}/5{N}  {Y}{fit_label}{N}")
print(f"  ATS Score:  {score_bar(ats_num, 100, 15)}  {W}{ats}%{N}  {Y}{ats_label}{N}")
print(f"  Keywords:   {score_bar(kw_coverage, 100, 15)}  {W}{kw_coverage}%{N}  ({kw_matched}/{kw_total})")
if recommendation:
    print(f"  Verdict:    {rec_color}{W}{recommendation}{N}")
print()

# Missing keywords
if kw_missing_list:
    print(f"  {W}MISSING KEYWORDS{N} {D}({len(kw_missing_list)} gaps){N}")
    bar()
    for k in kw_missing_list[:8]:
        print(f"  {R}x{N} {k}")
    if len(kw_missing_list) > 8:
        print(f"  {D}  ... and {len(kw_missing_list)-8} more{N}")
    print()

# Skills line
if skills_line:
    print(f"  {W}ATS-OPTIMISED SKILLS LINE{N}")
    bar()
    print(f"  {C}{skills_line}{N}")
    print()

# Tailored profile
if profile:
    print(f"  {W}TAILORED PROFILE{N}")
    bar()
    print(f"  {profile}")
    print()

# Bullets
if bullets:
    print(f"  {W}TAILORED BULLETS{N}")
    bar()
    for i, b in enumerate(bullets, 1):
        print(f"  {G}{i}.{N} {b}")
    print()

# Cover letter
if cover:
    print(f"  {W}COVER LETTER{N}")
    bar()
    print(f"{cover}")
    print()

# Tips
if tips:
    print(f"  {W}ATS TIPS{N}")
    bar()
    for t in tips:
        print(f"  {Y}>{N} {t}")
    print()

# Matching skills
if matching:
    print(f"  {W}MATCHING SKILLS{N} {D}({len(matching)} found){N}")
    bar()
    line = ""
    for s in matching:
        if len(line) + len(s) > 55:
            print(f"  {G}{line}{N}")
            line = ""
        line += s + " | "
    if line:
        print(f"  {G}{line.rstrip(' | ')}{N}")
    print()

# Footer
bar()
ver = data.get("pipeline_version", "2.0")
ts = data.get("processed_at", "")[:19]
print(f"  {D}Pipeline v{ver} | Processed: {ts}{N}")
bar()
PYEOF

rm -f "$TMPFILE"
