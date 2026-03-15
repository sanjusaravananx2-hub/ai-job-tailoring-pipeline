#!/bin/bash
# ============================================================
# Sanjeev's Job Application Automation — n8n Launcher
# ============================================================

# Use Node 20 (required by n8n)
export HOME=/Users/sanjeevkumar
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"
nvm use 20 2>/dev/null || { echo "Error: Node 20 not found. Run: nvm install 20"; exit 1; }

# Set n8n data directory
export N8N_USER_FOLDER="$HOME/MyCareer/job_automation/.n8n"
export N8N_PORT=5678

# Create directories if needed
mkdir -p "$N8N_USER_FOLDER"
mkdir -p "$HOME/MyCareer/job_automation/output"
mkdir -p "$HOME/MyCareer/job_automation/tracking"

# Initialize tracking file if it doesn't exist
if [ ! -f "$HOME/MyCareer/job_automation/tracking/applications.json" ]; then
    echo "[]" > "$HOME/MyCareer/job_automation/tracking/applications.json"
fi

echo "============================================"
echo "  Job Application Automation — n8n"
echo "============================================"
echo ""
echo "  Opening n8n at: http://localhost:$N8N_PORT"
echo ""
echo "  After n8n opens:"
echo "  1. Create an account (first time only)"
echo "  2. Go to Settings > Community Nodes (if needed)"
echo "  3. Add your OpenAI API key in Credentials"
echo "  4. Import workflows from:"
echo "     - n8n_workflows/job_application_automation.json"
echo "     - n8n_workflows/single_job_tailor.json"
echo ""
echo "  To tailor a CV for a specific job (after importing):"
echo "    curl -X POST http://localhost:5678/webhook/tailor-cv \\"
echo "      -H 'Content-Type: application/json' \\"
echo "      -d '{\"url\": \"https://job-posting-url.com\", \"company\": \"Company Name\"}'"
echo ""
echo "  Press Ctrl+C to stop"
echo "============================================"
echo ""

# Launch n8n
n8n start
