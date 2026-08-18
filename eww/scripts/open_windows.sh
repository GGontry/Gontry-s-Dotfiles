#!/usr/bin/env bash
# Emits the initial window list once, then refreshes it only on window events.
# The whole stdout is consumed by eww's deflisten, so only `niri msg -j windows`
# (valid JSON) is ever written — the raw event lines are discarded.
niri msg -j windows

niri msg event-stream | while IFS= read -r line; do
  case "$line" in
    Window*) niri msg -j windows ;;
  esac
done
