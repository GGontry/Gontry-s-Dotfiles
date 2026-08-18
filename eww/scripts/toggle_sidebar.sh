#!/usr/bin/env bash
# State is tracked in a flag file instead of `eww active-windows` so rapid
# toggling stays responsive (no dependence on window open/close latency).
state_file="${XDG_RUNTIME_DIR:-/tmp}/eww_sidebar_state"

if [ -e "$state_file" ]; then
  eww update sidebar_open=false
  sleep 0.35
  eww close sidebar
  rm -f "$state_file"
else
  monitor=$(niri msg -j focused-output | jq -r '.name')
  eww open sidebar --arg monitor="$monitor" --id sidebar
  eww update sidebar_open=true
  touch "$state_file"
fi
