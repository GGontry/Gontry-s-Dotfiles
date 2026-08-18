#!/usr/bin/env bash
# Switches the active eww theme by copying the chosen theme file over eww.scss.
# Usage: switch_theme.sh <catppuccin|minimal>

set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "${1:-}" in
  catppuccin) theme="eww-catppuccin.scss" ;;
  minimal)    theme="eww-minimal.scss" ;;
  *)
    echo "Usage: $0 <catppuccin|minimal>" >&2
    exit 1
    ;;
esac

cp "$dir/$theme" "$dir/eww.scss"
echo "Theme switched to: $theme"
