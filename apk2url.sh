#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
purple='\033[0;35m'
cyan='\033[0;36m'
reset='\033[0m'

printf """$green       
 █████╗ ██████╗ ██╗  ██╗██████╗ ██╗   ██╗██████╗ ██╗     
██╔══██╗██╔══██╗██║ ██╔╝╚════██╗██║   ██║██╔══██╗██║   
███████║██████╔╝█████╔╝  █████╔╝██║   ██║██████╔╝██║By     
██╔══██║██╔═══╝ ██╔═██╗ ██╔═══╝ ██║   ██║██╔══██╗██║n0mi1k     
██║  ██║██║     ██║  ██╗███████╗╚██████╔╝██║  ██║███████╗
╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
$reset"""

BASENAME="$(basename $1 .apk)"
WORKDIR=`pwd`
APKPATH="`pwd`/$1"
DECOMPILEDIR="${WORKDIR}/${BASENAME}-decompiled"
APKTOOLDIR="${DECOMPILEDIR}/${BASENAME}_apktool"
JADXDIR="${DECOMPILEDIR}/${BASENAME}_jadx"

dissectApktool() {
    printf "$cyan[+] Disassembling ${1}with Apktool...\n$reset"
    apktool d $APKPATH -o $APKTOOLDIR >/dev/null 2>&1   
}

dissectJadx() {
    printf "$cyan[+] Decompiling ${1}with Jadx...\n$reset"
    jadx $APKPATH -d $JADXDIR>/dev/null 2>&1    
}

extractEndpoints() {
    printf "$green[+] Beginning Endpoint Extraction...\n$reset"
    printf "$yellow[~] Extracting URLs...\n$reset"
    rawurlmatch=$(grep -rIoE '(\b(https?|ftp|file)://|www\.)[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' $DECOMPILEDIR)
    urlmatches=$(printf "%s" "$rawurlmatch" | awk -F':' '{sub(/^[^:]+:/, "", $0); print}' | sort -u)
    printf "%s\n" "$urlmatches" > "${WORKDIR}/${BASENAME}_endpoints.txt"

    printf "$yellow[~] Extracting IPs...\n$reset"
    rawipmatch=$(grep -rIoE '\b((https?|ftp|file)://)?([0-9]{1,3}\.){3}[0-9]{1,3}:[0-9]{1,5}\b' $DECOMPILEDIR)
    ipmatches=$(printf "%s" "$rawipmatch"| awk -F':' '{sub(/^[^:]+:/, "", $0); print}' | sort -u)    
    printf "%s\n" "$ipmatches" >> "${WORKDIR}/${BASENAME}_endpoints.txt"

    if [[ $1 == "log" ]]; then
        printf "$purple[~] Writing Logs to: ${WORKDIR}/${BASENAME}_log.txt\n$reset"
        printf "%s\n" "$rawurlmatch" > "$WORKDIR/${BASENAME}_log.txt"
        printf "%s\n" "$rawipmatch" >> "$WORKDIR/${BASENAME}_log.txt"
    fi

    printf "$green[*] Endpoints Extracted to: ${WORKDIR}/${BASENAME}_endpoints.txt\n$reset"
}

if [[ -z $1 ]]; then
    printf "Usage: apk2url <Name of APK File>\n"
    exit 1
fi

if ! [ -x "$(command -v apktool)" ]; then
    printf "$red[!] apk2url requires apktool to be installed\n$reset"
    exit 1
fi

if ! [ -x "$(command -v jadx)" ]; then
    printf "$red[!] apk2url requires jadx to be installed$reset"
    exit 1
fi

if [ -d "$DECOMPILEDIR" ]; then
    read -p "[*] APK was decompiled before. Do you want to overwrite it? (y/n): " choice
    if [[ "${choice,,}" == "y" ]]; then
        rm -Rf "$DECOMPILEDIR"
        printf "$green[+] Cleaning Up...\n$reset"
    else
        printf "$red[+] Action Aborted...$reset"
        exit 1
    fi
fi

mkdir $DECOMPILEDIR
dissectApktool
dissectJadx
extractEndpoints $2