#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
purple='\033[0;35m'
cyan='\033[0;36m'
reset='\033[0m'


printf """$green       
 █████╗ ██████╗ ██╗  ██╗██████╗ ██╗   ██╗██████╗ ██╗     
██╔══██╗██╔══██╗██║ ██╔╝╚════██╗██║   ██║██╔══██╗██║v1.1
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
ENDPOINTDIR="${WORKDIR}/endpoints/"

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
    rawurlmatch=$(grep -rIoE '(\b(https?)://|www\.)[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]' $DECOMPILEDIR)
    urlmatches=$(printf "%s" "$rawurlmatch" | awk -F':' '{sub(/^[^:]+:/, "", $0); print}' | sort -u)
    printf "%s\n" "$urlmatches" > "${ENDPOINTDIR}/${BASENAME}_endpoints.txt"

    printf "$yellow[~] Extracting IPs...\n$reset"
    rawipmatch=$(grep -rIoP '\b((https?)://)?(?:25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b(?::\b(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,3}))?' $DECOMPILEDIR)
    ipmatches=$(printf "%s" "$rawipmatch"| awk -F':' '{sub(/^[^:]+:/, "", $0); print}' | sort -u)    
    printf "%s\n" "$ipmatches" >> "${ENDPOINTDIR}/${BASENAME}_endpoints.txt"

    if [[ $1 == "log" ]]; then
        printf "$purple[~] Writing Logs to: ${ENDPOINTDIR}/${BASENAME}_log.txt\n$reset"
        printf "%s\n" "$rawurlmatch" > "$ENDPOINTDIR/${BASENAME}_log.txt"
        printf "%s\n" "$rawipmatch" >> "$ENDPOINTDIR/${BASENAME}_log.txt"
    fi

    printf "$purple[~] Performing Uniq Filter...$reset"
    grep -oE '((http|https)://[^/]+)' ${ENDPOINTDIR}/${BASENAME}_endpoints.txt | awk -F/ '{print $1 "//" $3}' | sort -u > ${ENDPOINTDIR}/${BASENAME}_uniqurls.txt
    grep -E '^www.*' ${ENDPOINTDIR}/${BASENAME}_endpoints.txt >> ${ENDPOINTDIR}/${BASENAME}_uniqurls.txt
    grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}.*' ${ENDPOINTDIR}/${BASENAME}_endpoints.txt >> ${ENDPOINTDIR}/${BASENAME}_uniqurls.txt
    
    printf "$purple\n[~] Wrote Uniq Domains to: ${ENDPOINTDIR}/${BASENAME}_uniqurls.txt\n$reset"
    printf "$green[*] Endpoints Extracted to: ${ENDPOINTDIR}/${BASENAME}_endpoints.txt\n$reset"
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
        printf "$green[+] Cleaning Up...\n$reset"
        rm -Rf "$DECOMPILEDIR"
    else
        printf "$red[+] Action Aborted...$reset"
        exit 1
    fi
fi

mkdir $DECOMPILEDIR

if [ ! -d "$ENDPOINTDIR" ]; then
    mkdir "$ENDPOINTDIR"
fi

printf "$yellow[~] SHA256: $(shasum -a 256 $1 | awk '{print $1}')\n$reset"
dissectApktool
dissectJadx
extractEndpoints $2