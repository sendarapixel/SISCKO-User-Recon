#!/bin/bash

# Banner ASCII
echo "  _____   _____  _____  _  __  _____  _____  _____   ____"
echo " /  ___/ /  ___//  ___// |/ / /  ___//  ___//  ___| | ___|"
echo " | |___  | |___ | |___ |   /  | |___ | |___ | |___  | |__"
echo " \___  \ \___  \ \___  \|  |  \___  \ \___  \ \___  \|  __|"
echo "  ___| |  ___| |  ___| | |  |  ___| |  ___| |  ___| | |"
echo " /_____/ /_____/ /_____/ |_/  /_____/ /_____/ /_____/ |_|"

echo " S I S C K O "
echo " User Recon "
echo ""

# Ayuda
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Uso: ./recon.sh [opciones] [usuario]"
    echo ""
    echo "Opciones:"
    echo "  -h, --help              Muestra este mensaje de ayuda"
    echo "  -e, --export            Exporta los resultados a un archivo de texto"
    echo "  -n, --name              Establece el nombre del archivo de exportación (usar con -e)"
    echo ""
    exit 0
fi

# Función para buscar en una red
buscar() {
    local nombre_red=$1
    local url=$2
    local usuario=$3

    echo "[*] Buscando en $nombre_red..."
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url/$usuario")
    
    if [[ $response -eq 200 ]]; then
        echo "[+] ¡Encontrado en $nombre_red! $url/$usuario"
    else
        echo "[-] No encontrado en $nombre_red."
    fi
}

# Usuario a buscar
usuario=$1

if [ -z "$usuario" ]; then
    echo "Por favor, introduce un nombre de usuario."
    exit 1
fi

# Redes sociales y de citas para buscar
declare -A redes=(
    ["GitHub"]="https://github.com"
    ["Twitter"]="https://twitter.com"
    ["Instagram"]="https://www.instagram.com"
    ["Facebook"]="https://www.facebook.com"
    ["Tinder"]="https://tinder.com/@"
    ["Bumble"]="https://bumble.com/@"
    ["OkCupid"]="https://www.okcupid.com/profile/"
)

# Búsqueda en redes
for red in "${!redes[@]}"; do
    buscar "$red" "${redes[$red]}" "$usuario"
done

# Exportar resultados
if [[ "$2" == "-e" || "$2" == "--export" ]]; then
    archivo=${3:-resultados.txt}
    for red in "${!redes[@]}"; do
        echo "[*] Guardando resultados de $red en $archivo..."
        response=$(curl -s -o /dev/null -w "%{http_code}" "${redes[$red]}/$usuario")
        if [[ $response -eq 200 ]]; then
            echo "$red: Encontrado - ${redes[$red]}/$usuario" >> "$archivo"
        else
            echo "$red: No encontrado" >> "$archivo"
        fi
    done
    echo "[*] Resultados exportados a $archivo"
fi