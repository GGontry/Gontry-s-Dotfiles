function TurnOFF --description 'Limpieza profunda y apagado'
    echo "--- Iniciando secuencia de limpieza y apagado ---"

    # 1. Limpiar Cliphist
    if type -q cliphist
        cliphist wipe
        echo "[✓] Historial de portapapeles eliminado."
    end

    # 2. Limpiar Caches de usuario
    if test -d "$HOME/.cache"
        find "$HOME/.cache" -mindepth 1 -delete
        echo "[✓] Cache de usuario limpiado."
    end

    # 3. Limpieza de /tmp
    if test -d "/tmp"
        sudo rm -rf /tmp/*
        echo "[✓] Archivos temporales (/tmp) eliminados."
    end

    # 4. Limpieza de memoria RAM
    echo "[!] Liberando memoria caché..."
    sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    echo "[✓] Memoria liberada."

    # 5. Apagado
    echo "--- Ejecutando apagado ---"
    systemctl poweroff
end
