#!/usr/bin/env bash
# Aggregates every system metric into a single JSON object, so eww only needs
# one defpoll (one process) instead of seven.

cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print $2 + $4}')
cpu_temp=$(sensors 2>/dev/null | awk '/^(Tctl|Tdie|Core 0|Package id)/ {print $2; exit}' | tr -d '+°C')
cpu_freq=$(awk '/cpu MHz/ {sum+=$4; count++} END {printf "%.1f", sum/count/1000}' /proc/cpuinfo)
ram_usage=$(free -m | awk '/Mem:/ {print int($3/$2 * 100)}')

# AMD GPU: card1 (dGPU) first, falls back to card0 (iGPU)
gpu_usage=$(cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo 0)
gpu_temp=$(awk 'NR==1 {print $1/1000}' /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null || awk 'NR==1 {print $1/1000}' /sys/class/drm/card0/device/hwmon/hwmon*/temp1_input 2>/dev/null || echo 0)
vram_used=$(cat /sys/class/drm/card1/device/mem_info_vram_used 2>/dev/null || cat /sys/class/drm/card0/device/mem_info_vram_used 2>/dev/null || echo 0)
vram_total=$(cat /sys/class/drm/card1/device/mem_info_vram_total 2>/dev/null || cat /sys/class/drm/card0/device/mem_info_vram_total 2>/dev/null || echo 0)

if [ "$vram_total" -gt 0 ] 2>/dev/null; then
  vram_usage=$((vram_used * 100 / vram_total))
else
  vram_usage=0
fi

disk_usage=$(df -h / | awk 'NR==2 {gsub("%", "", $5); print $5}')

printf '{"cpu_usage": %s, "cpu_temp": %s, "cpu_freq": %s, "ram_usage": %s, "gpu_usage": %s, "gpu_temp": %s, "vram_usage": %s, "disk_usage": %s}\n' \
  "${cpu_usage:-0}" "${cpu_temp:-0}" "${cpu_freq:-0}" "${ram_usage:-0}" \
  "${gpu_usage:-0}" "${gpu_temp:-0}" "${vram_usage:-0}" "${disk_usage:-0}"
