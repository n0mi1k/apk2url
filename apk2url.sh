#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
white='\033[0;37m'
reset='\033[0m'

bold_black='\033[1;30m'
bold_red='\033[1;31m'
bold_green='\033[1;32m'
bold_yellow='\033[1;33m'
bold_blue='\033[1;34m'
bold_purple='\033[1;35m'
bold_cyan='\033[1;36m'
bold_white='\033[1;37m'

printf """$green       
 █████╗ ██████╗ ██╗  ██╗██████╗ ██╗   ██╗██████╗ ██╗     
██╔══██╗██╔══██╗██║ ██╔╝╚════██╗██║   ██║██╔══██╗██║     
███████║██████╔╝█████╔╝  █████╔╝██║   ██║██████╔╝██║     
██╔══██║██╔═══╝ ██╔═██╗ ██╔═══╝ ██║   ██║██╔══██╗██║v0.1     
██║  ██║██║     ██║  ██╗███████╗╚██████╔╝██║  ██║███████╗
╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
$reset"""

dissect() {
    printf "[+] Disassembling $1 with Apktool...\n"
    apktool d $1 >/dev/null 2>&1   
    
    #WORKDIR=`pwd`
    #APKDIR="`pwd`/$1"
    #printf "[+] Decompiling $1 with Jadx..."
    #jadx $APKDIR -d $WORKDIR
    #printf "$APKDIR" 
}

extract() {
    printf "[+] Beginning Extraction...\n"
    extractFolder="$(basename $1 .apk)"
    
    printf "[~] Extracting URLs...\n"
    rawurlmatch=$(grep -rIoE '(\b(https?|ftp|file)://|www\.)[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' $extractFolder)
    urlmatches=$(printf "%s" "$rawurlmatch" | awk -F':' '{sub(/^[^:]+:/, "", $0); print}' | sort -u)
    printf "%s\n" "$rawurlmatch" > "${1}_log.txt"
    printf "%s\n" "$urlmatches" > "${1}_endpoints.txt"

    printf "[~] Extracting IPs...\n"
    rawipmatch=$(grep -rIoE '\b((https?|ftp|file)://)?([0-9]{1,3}\.){3}[0-9]{1,3}:[0-9]{1,5}\b' $extractFolder)
    ipmatches=$(printf "%s" "$rawipmatch"| awk -F':' '{sub(/^[^:]+:/, "", $0); print}' | sort -u)
    printf "%s\n" "$rawipmatch" >> "${1}_log.txt"    
    printf "%s\n" "$ipmatches" >> "${1}_endpoints.txt"
}

if [[ -z $1 ]]; then
    printf "Usage: apk2url <name of apk file>\n"
    exit 1
fi

if ! [ -x "$(command -v apktool)" ]; then
    printf "$red[ERROR] apk2url requires apktool to be installed\n$reset"
    exit 1
fi

if ! [ -x "$(command -v bytecode-viewer)" ]; then
    printf "$red[ERROR] apk2url requires bytecode-viewer to be installed\n$reset"
    exit 1
fi

if ! [ -x "$(command -v jadx)" ]; then
    printf "$red[ERROR] apk2url requires jadx to be installed$reset"
    exit 1
fi

dissect $1
extract $1