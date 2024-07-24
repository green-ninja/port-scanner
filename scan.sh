#!/bin/bash

webhook_url="$SLACK_WEBHOOK_URL"

# Check if the Slack webhook URL environment variable is set
if [ -z "$webhook_url" ]; then
  echo "Error: SLACK_WEBHOOK_URL environment variable not set."
  exit 1
fi


# Function to generate a timestamp
function timestamp() {
  date +%Y%m%d
}

# Function to perform Nmap scan and save results in XML format
function nmap_scan() {
  target="$1"
  output_file="$(timestamp)-scan-results.xml"
  nmap -p- -sT -sU -oX "$output_file" "$target" > /dev/null 2>&1
}

#  Compare results using ndiff and send to Slack
function report_results() {
  # Compare results
  today=$(timestamp)
  yesterday=$(date -d yesterday +%Y%m%d)
  today_file="$today-scan-results.xml"
  yesterday_file="$yesterday-scan-results.xml"
  ndiff "$yesterday_file" "$today_file" > diff_results.txt

  # Send results to Slack
  file_path="diff_results.txt"
  file_content=$(cat "$file_path")
  payload='{"text": "'"$file_content"'"}'

  curl -X POST --header 'Content-type: application/json' --data "$payload" "$webhook_url"
}


# Main script
if [ ! -f targets.txt ]; then
  echo "Error: targets.txt file not found."
  exit 1
fi

for target in $(cat targets.txt); do
  nmap_scan "$target"
done

report_results