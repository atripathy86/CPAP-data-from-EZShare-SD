#!/bin/bash
echo "Started ezshare_resmed at:$(date)" | tee -a /app/logs.txt /proc/1/fd/1
/usr/local/bin/python -u /app/ezshare_resmed.py --url http://192.168.4.1/dir?dir=A: --path /ezshare_resmed_data --show_progress --verbose --keep_old > >(tee -a /app/logs.txt) 2> >(tee -a /proc/1/fd/1 >&2)
echo "Finished ezshare_resmed at:$(date)" | tee -a /app/logs.txt /proc/1/fd/1
tomorrow_noon=$(date -d "tomorrow 12:00")
echo "Next scheduled run of ezshare_resmed at: $tomorrow_noon" | tee -a /app/logs.txt /proc/1/fd/1

