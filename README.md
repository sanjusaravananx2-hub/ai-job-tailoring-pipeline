# AI Job Tailoring Pipeline v2.0

A fully automated job application system that tailors your CV, writes cover letters, and scores your ATS match — all from a single terminal command.

I built this to stop wasting hours manually rewriting my CV for every application. Now I paste a job description, and in under 30 seconds I get a tailored profile, rewritten bullets, a cover letter, and an ATS keyword analysis.

---

## What It Does

```
You paste a job description
        |
        v
  [Input Validator] ── validates and sanitises the job text
        |
        v
  [Prompt Engineer] ── builds a structured prompt with your profile data
        |
        v
  [Gemini 2.5 Flash] ── analyses the job and generates tailored content
        |
        v
  [Response Parser] ── extracts and cleans the JSON response
        |
        v
  [ATS Scorer] ── calculates keyword coverage, fit score, and verdict
        |
        v
  [Output Formatter] ── prints a clean terminal report
```

### You Get Back:

- **Fit Score** (1-5) — how well your profile matches the role
- **ATS Score** (0-100%) — keyword match percentage
- **Missing Keywords** — exactly what's missing from your CV
- **ATS-Optimised Skills Line** — drop this straight into your CV
- **Tailored Profile** — 2-3 sentence summary rewritten for the role
- **Tailored Bullets** — 6 experience bullets rewritten to match the job
- **Cover Letter** — company-specific, 350 words, ready to send
- **ATS Tips** — actionable advice to improve your match

---

## Architecture

The pipeline runs on **n8n** (open-source workflow automation) hosted on a cloud server, triggered via a webhook. The CLI script (`tailor.sh`) sends the job description to the webhook and formats the response in your terminal.

```
Terminal (tailor.sh)
    |
    | POST /webhook/tailor-cv
    v
n8n Server (cloud or local)
    |
    |-- Webhook Trigger
    |-- Input Validator (Code node)
    |-- Prompt Engineer (Code node)
    |-- Gemini 2.5 Flash (HTTP Request)
    |-- Response Parser (Code node)
    |-- ATS Scorer (Code node)
    |-- Output Formatter (Code node)
    |-- Response node (returns JSON)
    |
    v
Terminal (pretty-printed results)
```

There's also a second workflow that runs every 12 hours and scrapes job boards (Indeed UK, Gradcracker) for new postings matching your keywords — but the single-job tailoring pipeline above is the core tool.

---

## Tech Stack

| Component | Tool |
|-----------|------|
| Workflow engine | [n8n](https://n8n.io) (self-hosted) |
| AI model | Google Gemini 2.5 Flash Lite |
| CLI | Bash + Python 3 |
| Application tracking | Google Sheets (via Apps Script webhook) |
| Job scraping | n8n HTTP nodes (Indeed, Gradcracker) |

---

## Setup

### Prerequisites

- Node.js 20+ (for n8n)
- Python 3.8+
- A Google Gemini API key ([get one here](https://aistudio.google.com/apikey))

### 1. Install n8n

```bash
npm install -g n8n
```

### 2. Clone and Configure

```bash
git clone <this-repo>
cd job_automation
```

Edit `config.yaml` with your details:
- Your profile info (name, email, skills, etc.)
- Your Gemini API key
- Your job search preferences

### 3. Start n8n

```bash
./start_n8n.sh
```

This launches n8n on `http://localhost:5678`.

### 4. Import the Workflows

1. Open n8n in your browser
2. Go to **Workflows > Import from file**
3. Import both:
   - `n8n_workflows/single_job_tailor.json` (the main pipeline)
   - `n8n_workflows/job_application_automation.json` (auto job scraping)
4. Add your Gemini API key to the HTTP Request node URL
5. **Activate** the workflow

### 5. Set Up Application Tracking (Optional)

Follow the steps in `google_sheets_setup.md` to auto-log every tailored application to a Google Sheet.

---

## Usage

```bash
./tailor.sh "Company Name"
```

Then paste the full job description and press `Ctrl+D`.

### Example

```bash
./tailor.sh "ARM Ltd"
```

```
    AI JOB TAILORING PIPELINE v2.0
────────────────────────────────────────────────────────────
  Target:  ARM Ltd
  Engine:  Gemini 2.5 Flash Lite
  Stages:  Validate -> Prompt -> AI -> Parse -> Score -> Format
────────────────────────────────────────────────────────────

Paste the job description below, then press Ctrl+D:
```

After pasting, you get a full analysis in ~15 seconds:

```
  JOB ANALYSIS RESULTS
────────────────────────────────────────────────────────────
  Role:      Graduate Embedded Software Engineer
  Company:   ARM Ltd
  Location:  Cambridge, UK

  SCORES
────────────────────────────────────────────────────────────
  Fit Score:  ████████████░░░  4/5  STRONG
  ATS Score:  ██████████████░  85%  HIGH
  Keywords:   ███████████░░░░  78%  (18/23)
  Verdict:    APPLY
```

---

## Customising for Your Profile

The key file to modify is the **Prompt Engineer** node inside the n8n workflow. It contains a structured summary of your skills, experience, and projects that gets sent to Gemini alongside the job description.

To make this work for you:

1. Open the workflow in n8n
2. Edit the **Prompt Engineer** code node
3. Replace the candidate summary with your own details
4. Optionally update `profile_data.py` and `config.yaml`

---

## Project Structure

```
job_automation/
  tailor.sh                  # CLI entry point
  config.yaml                # Your profile and preferences
  profile_data.py            # Structured profile data (Python dict)
  start_n8n.sh               # n8n launcher script
  requirements.txt           # Python dependencies
  google_sheets_setup.md     # Google Sheets tracking setup guide
  n8n_workflows/
    single_job_tailor.json   # Main tailoring pipeline (n8n workflow)
    job_application_automation.json  # Auto job scraper (n8n workflow)
  output/                    # Generated CVs and cover letters
  tracking/
    applications.json        # Local application tracking
```

---

## How It Actually Helped Me

- Cut my per-application time from ~45 minutes to under 2 minutes
- ATS keyword matching went from guesswork to data-driven
- Cover letters are company-specific from day one, not generic templates
- I can see at a glance whether a role is worth applying to (fit score + ATS score)

---

## Questions?

If you found this from my LinkedIn video and want help setting it up, drop me a message. Happy to walk you through it.

**Sanjeev Kumar**
[LinkedIn](https://linkedin.com/in/sanjeev-kumarx2)
