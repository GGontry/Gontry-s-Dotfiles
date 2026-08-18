#!/usr/bin/env fish

set src_dir $argv[1]
set dst_dir $argv[2]
set threads $argv[3]

if not set -q src_dir[1]
    read -P "Directorio origen: " src_dir
end

if not set -q dst_dir[1]
    read -P "Directorio destino: " dst_dir
end

if not set -q threads[1]
    set threads (nproc)
    echo ""
    echo "Hilos de CPU para codificar (actual: $threads disponibles)"
    read -P "Usar hilos (Enter = todos): " input_threads
    if test -n "$input_threads"
        set threads $input_threads
    end
end

if not test -d "$src_dir"
    echo "Error: el directorio '$src_dir' no existe"
    exit 1
end

if not command -q ffmpeg
    echo "Error: ffmpeg no está instalado"
    exit 1
end

mkdir -p "$dst_dir"

set exts .mp4 .mov .mkv .avi .mts .m2ts .webm .flv .wmv .mxf

for video in "$src_dir"/*
    test -f "$video" || continue
    set filename (basename "$video")
    set ext (string lower (string match -r '\.[^.]*$' "$filename"))
    if test -z "$ext"; or not contains "$ext" $exts
        continue
    end
    set name (string replace -r '\.[^.]*$' '' "$filename")
    set output "$dst_dir/$name.mov"

    echo "Convirtiendo: $video"
    echo "  -> $output ($threads hilos)"

    ffmpeg -hwaccel vaapi -i "$video" \
        -c:v dnxhd -profile:v dnxhr_hq -b:v 185M -pix_fmt yuv422p \
        -c:a pcm_s16le \
        -threads $threads -y "$output"
end

echo "¡Listo!"
