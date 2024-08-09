#!/bin/bash
# S ¥ S C K O UserRecon v1.1
# Author: @S ¥ S C K O
# https://github.com/thelinuxchoice/usercheck

trap 'printf "\n";partial;exit 1' 2

# Función para mostrar el banner
banner() {
    printf "                                                   \e[1;92m.-\"\"\"\"-. \e[0m\n"
    printf "                                                  \e[1;92m/        \ \e[0m\n"
    printf "\e[1;77m  _   _               ____                       \e[0m\e[1;92m/_        _\ \e[0m\n"
    printf "\e[1;77m | | | |___  ___ _ __|  _ \ ___  ___ ___  _ __  \e[0m\e[1;92m// \      / \\ \e[0m\n"
    printf "\e[1;77m | | | / __|/ _ \ '__| |_) / _ \/ __/ _ \| '_ \ \e[0m\e[1;92m|\__\    /__/| \e[0m\n"
    printf "\e[1;77m | |_| \__ \  __/ |  |  _ <  __/ (_| (_) | | | | \e[0m\e[1;92m\    ||    / \e[0m\n"
    printf "\e[1;77m  \___/|___/\___|_|  |_| \_\___|\___\___/|_| |_|  \e[0m\e[1;92m\        / \e[0m\n"
    printf "                   \e[1;92mv1.1, Author: @S ¥ S C K O\e[0m   \e[1;92m\  __  / \e[0m\n"
    printf "                                                    \e[1;92m'.__.' \e[0m\n"
}

# Función que muestra si el archivo fue guardado
partial() {
    if [[ -e $filepath ]]; then
        printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved:\e[0m\e[1;77m %s\n" "$filepath"
    fi
}

# Función principal para el escaneo
scanner() {
    read -p $'\e[1;92m[\e[0m\e[1;77m?\e[0m\e[1;92m] Input Username:\e[0m ' username

    read -p $'\e[1;92m[\e[0m\e[1;77m?\e[0m\e[1;92m] Enter file path for saving results (e.g., /path/to/dir/filename.txt):\e[0m ' filepath

    if [[ -e $filepath ]]; then
        printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Removing previous file:\e[0m\e[1;77m %s\n" "$filepath"
        rm -rf "$filepath"
    fi
    printf "\n"
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Checking username\e[0m\e[1;77m %s\e[0m\e[1;92m on: \e[0m\n" "$username"

    # Búsqueda en Instagram
    check_insta=$(curl -s -H "Accept-Language: en" "https://www.instagram.com/$username" -L | grep -o 'The link you followed may be broken'; echo $?)
    printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Instagram: \e[0m"
    if [[ $check_insta == *'1'* ]]; then
        printf "\e[1;92m Found!\e[0m https://www.instagram.com/%s\n" "$username"
        printf "https://www.instagram.com/%s\n" "$username" > "$filepath"
    elif [[ $check_insta == *'0'* ]]; then
        printf "\e[1;93mNot Found!\e[0m\n"
    fi

    # Búsqueda en Facebook
    printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Facebook: \e[0m"
    check_face=$(curl -s "https://www.facebook.com/$username" -L -H "Accept-Language: en" | grep -o 'not found'; echo $?)
    if [[ $check_face == *'1'* ]]; then
        printf "\e[1;92m Found!\e[0m https://www.facebook.com/%s\n" "$username"
        printf "https://www.facebook.com/%s\n" "$username" >> "$filepath"
    elif [[ $check_face == *'0'* ]]; then
        printf "\e[1;93mNot Found!\e[0m\n"
    fi

    # Búsqueda en Twitter
    printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] Twitter: \e[0m"
    check_twitter=$(curl -s "https://www.twitter.com/$username" -L -H "Accept-Language: en" | grep -o 'page doesn’t exist'; echo $?)
    if [[ $check_twitter == *'1'* ]]; then
        printf "\e[1;92m Found!\e[0m https://www.twitter.com/%s\n" "$username"
        printf "https://www.twitter.com/%s\n" "$username" >> "$filepath"
    elif [[ $check_twitter == *'0'* ]]; then
        printf "\e[1;93mNot Found!\e[0m\n"
    fi

    # [Agregar aquí las demás redes como en el script original]

    # Mensaje final
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Scanning completed!\e[0m\n"
    partial
}

# Ejecución principal
banner
scanner