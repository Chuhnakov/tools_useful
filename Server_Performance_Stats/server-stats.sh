#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

sep() {
    echo -e "${BLUE}=========================================${NC}"
}
sep
echo -e "${YELLOW}Server:${NC} $(uname -n)"
echo -e "${YELLOW}Date&Time:${NC} $(date)"
echo -e "${YELLOW}Uptime:${NC} $(uptime -p | sed 's/up //')"
sep
echo -e "${YELLOW}CPU info${NC}"
read -r cpu u1 n1 s1 i1 io1 ir1 sir1 st1 g1 gn1 < /proc/stat
sleep 1
read -r cpu u2 n2 s2 i2 io2 ir2 sir2 st2 g2 gn2 < /proc/stat

active1=$((u1+n1+s1+sir1+st1))
total1=$((u1+n1+s1+i1+io1+ir1+sir1+st1+g1+gn1))
active2=$((u2+n2+s2+sir2+st2))
total2=$((u2+n2+s2+i2+io2+ir2+sir2+st2+g2+gn2))

diff_active=$((active2-active1))
diff_total=$((total2-total1))
echo "CPU Usage:${NC} $((100*diff_active/diff_total))%"
sep
#RAM
echo -e "${YELLOW}RAM info${NC}"
read -r _ total used _ _ _  available < <(free -m | grep Mem:)
echo -e "Total: $total MiB"
echo -e "Used: ${RED}${used}${NC} MiB"
echo -e "Available:${GREEN}${available}${NC} MiB"
percentage_used=$(echo "scale=2; ($used * 100) / $total" | bc)
echo -e "Used Percentage: $percentage_used%"
sep
#Space
echo -e "${YELLOW}Totap space,all mouned devices: ${NC}"
echo -e "$(df -h --total | grep -v "tmpfs" | grep -v "udev" | column -t)"
echo ""
echo -e "${YELLOW}ROOT space (/):${NC}"
ROOT_INFO=$(df -h / | tail -n1)
ROOT_SIZE=$(echo $ROOT_INFO | awk '{print $2}')
ROOT_USED=$(echo $ROOT_INFO | awk '{print $3}')
ROOT_FREE=$(echo $ROOT_INFO | awk '{print $4}')
ROOT_USE_PERCENT=$(echo $ROOT_INFO | awk '{print $5}')

echo -e "Total: ${GREEN}${ROOT_SIZE}${NC}"
echo -e "Used: ${RED}${ROOT_USED} (${ROOT_USE_PERCENT})${NC}"
echo -e "available: ${GREEN}${ROOT_FREE}${NC}"
sep
echo -e "${YELLOW}Top 5 processes by CPU usage:${NC}"
ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | head -n 6
sep
echo -e "${YELLOW}Top 5 processes by memory usage:${NC}"
ps aux --sort -rss | head -n 6
sep
