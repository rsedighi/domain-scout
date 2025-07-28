#!/bin/bash

# Domain Scout Cron Runner
# This script runs Domain Scout automatically and logs results

# Configuration
SCRIPT_DIR="/Users/ramin/Desktop/domain_scout"
LOG_DIR="$SCRIPT_DIR/logs"
CATEGORIES=("sports" "ai_automation" "finance_fintech" "saas_niches" "startups_naming_themes")
DOMAIN_COUNT=5

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Get current timestamp
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="$LOG_DIR/cron_run_$TIMESTAMP.log"

# Change to script directory
cd "$SCRIPT_DIR"

# Log start
echo "=== Domain Scout Cron Run Started at $(date) ===" >> "$LOG_FILE"
echo "Working directory: $(pwd)" >> "$LOG_FILE"

# Pick a random category
CATEGORY=${CATEGORIES[$RANDOM % ${#CATEGORIES[@]}]}
echo "Selected category: $CATEGORY" >> "$LOG_FILE"

# Run Domain Scout
echo "Running: ruby run.rb $CATEGORY $DOMAIN_COUNT" >> "$LOG_FILE"
ruby run.rb "$CATEGORY" "$DOMAIN_COUNT" >> "$LOG_FILE" 2>&1

# Log completion
echo "=== Run completed at $(date) ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Optional: Clean up old logs (keep last 50 runs)
find "$LOG_DIR" -name "cron_run_*.log" -type f | sort -r | tail -n +51 | xargs rm -f 2>/dev/null

# Optional: Send notification if available domains found
AVAILABLE_COUNT=$(tail -20 "$LOG_FILE" | grep -c "AVAILABLE")
if [ "$AVAILABLE_COUNT" -gt 0 ]; then
    echo "Found $AVAILABLE_COUNT available domains in category: $CATEGORY" >> "$LOG_FILE"
    # Uncomment to send macOS notification:
    # osascript -e "display notification \"Found $AVAILABLE_COUNT available domains\" with title \"Domain Scout\""
fi
