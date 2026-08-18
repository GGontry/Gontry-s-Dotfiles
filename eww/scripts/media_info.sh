#!/usr/bin/env bash
# Outputs JSON with metadata of the active MPRIS player (for eww defpoll).
# Returns empty fields when nothing is playing.

if ! playerctl metadata >/dev/null 2>&1; then
  printf '{"status":"", "title":"", "artist":"", "length":0, "pos":0, "pct":0, "pos_str":"", "len_str":""}\n'
  exit 0
fi

fmt=$'{{status}}\t{{title}}\t{{artist}}\t{{mpris:length}}\t{{position}}'
playerctl metadata --format "$fmt" 2>/dev/null |
while IFS= read -r line; do
  printf '%s\n' "$line" |
    jq -R '
      def pad: tostring | if length < 2 then "0" + . else . end;
      def fmt:
        floor as $s |
        if $s >= 3600 then
          (($s/3600)|floor) as $h |
          (($s%3600)/60|floor) as $m |
          ($s%60) as $r |
          "\($h):\($m|pad):\($r|pad)"
        else
          (($s/60)|floor) as $m |
          ($s%60) as $r |
          "\($m|pad):\($r|pad)"
        end;
      split("\t") as $f |
      ((($f[3] // "0") | tonumber? // 0) / 1000000 | floor) as $len |
      ((($f[4] // "0") | tonumber? // 0) / 1000000 | floor) as $pos |
      {
        status: ($f[0] // ""),
        title:  ($f[1] // ""),
        artist: ($f[2] // ""),
        length: $len,
        pos:    $pos,
        pct:    (if $len > 0 then (($pos / $len) * 100) else 0 end),
        pos_str: ($pos | fmt),
        len_str: ($len | fmt)
      }
    '
done
