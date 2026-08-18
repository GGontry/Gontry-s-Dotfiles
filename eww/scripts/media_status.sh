#!/usr/bin/env bash
# Long-running: prints the active MPRIS player status on every change (for eww deflisten).
# Falls back to empty line and retries when no player is available.

while true; do
  playerctl -F status 2>/dev/null
  sleep 1
done
