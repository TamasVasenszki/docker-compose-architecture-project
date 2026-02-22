#!/bin/sh

LATEST=$(ls -t /backups 2>/dev/null | head -n 1)

if [ -z "$LATEST" ]; then
  echo "No backup file found"
  exit 1
fi

SIZE=$(wc -c < /backups/$LATEST)
LINES=$(wc -l < /backups/$LATEST)

echo "Backup Analysis Report" > /reports/report.txt
echo "File: $LATEST" >> /reports/report.txt
echo "Size (bytes): $SIZE" >> /reports/report.txt
echo "Line count: $LINES" >> /reports/report.txt
echo "Generated at: $(date)" >> /reports/report.txt

cat /reports/report.txt
