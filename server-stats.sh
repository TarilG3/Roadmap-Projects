#!/usr/bin/bash

# CPU usage
echo "CPU Usage"
top -bn1 | grep "Cpu(s)" | awk '{ print "CPU Usage: " 100 - $8 "%\n" }'
# Total memory usage (Free VS Used, including percentage)
echo "Memory Usage"
vmstat -s | awk '
/total memory/ { total = $1 }
/free memory/ { free = $1 }
/buffer memory/ { buffer = $1 }
/cache/ && !swap { cache = $1; swap = 1 }
END {
    used = total - free - buffer - cache
    printf "Free: %d KB\n", free
    printf "Used: %d KB\n", used 
    printf "Usage: %.2f%%\n\n", (used/total)*100
}'
# Total disk usage (Free vs Used including percentage)
echo "Disk Usage"
df -B1 --total --exclude-type=tmpfs --exclude-type=devtmpfs | awk '
/^total/ {
    total=$2
    used=$3
    avail=$4
    percent=$5
    printf "Total: %.2f GB\n", total/1024/1024/1024
    printf "Used Space: %.2f GB\n", used/1024/1024/1024
    printf "Free Space: %.2f GB\n", avail/1024/1024/1024
    printf "Usage: %s\n\n", percent
}'
# Top 5 processes by CPU usage
echo "Top 5 Processes by CPU Usage"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
# Top 5 processes by MEM usage
echo "Top 5 Processes by MEM Usage"
ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
