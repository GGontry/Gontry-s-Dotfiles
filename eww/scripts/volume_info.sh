#!/usr/bin/env bash
# Outputs JSON with the default audio sink volume (0-100) and mute state (for eww defpoll).

out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || {
  printf '{"volume":0,"muted":false}\n'
  exit 0
}

vol=$(printf '%s\n' "$out" | awk '{print $2}')
pct=$(awk -v v="$vol" 'BEGIN {printf "%.0f", v * 100}')

if printf '%s\n' "$out" | grep -q "MUTED"; then
  muted="true"
else
  muted="false"
fi

printf '{"volume":%s,"muted":%s}\n' "$pct" "$muted"
