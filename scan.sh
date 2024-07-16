#!/bin/bash

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

# Function to compare results using ndiff
function compare_results() {
  today=$(timestamp)
  yesterday=$(date -d yesterday +%Y%m%d)
  today_file="$today-scan-results.xml"
  yesterday_file="$yesterday-scan-results.xml"
  ndiff "$yesterday_file" "$today_file"
}

# Main script
if [ ! -f targets.txt ]; then
  echo "Error: targets.txt file not found."
  exit 1
fi

for target in $(cat targets.txt); do
  nmap_scan "$target"
done

compare_results
