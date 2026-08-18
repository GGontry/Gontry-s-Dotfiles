#!/usr/bin/env bash
# Opens the eww bar on every connected monitor (one instance per monitor).
# Monitor names come from niri.

set -euo pipefail

monitors=$(niri msg outputs | sed -n 's/^Output.*(\([^)]*\))$/\1/p')

for m in $monitors; do
  if ! eww list-windows | grep -q "^${m}$"; then
    eww open bar --arg monitor="$m" --id "$m"
  fi
done
