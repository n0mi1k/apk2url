echo "[+] Starting Installation..."

cp apk2url.sh /usr/bin/apk2url 2>/dev/null
chmod +x /usr/bin/apk2url 2>/dev/null

if ! [ -x "$(command -v apk2url)" ]; then
  echo '[!] Error: installation failed, use sudo' >&2
  exit 1
fi

if ! [ -x "$(command -v apktool)" ]; then
  echo '[!] Error: apktool is not installed. Run apt-get install apktool' >&2
  exit 1
fi

if ! [ -x "$(command -v bytecode-viewer)" ]; then
    echo '[!] Error: bytecode-viewer is not installed. Run apt-get install bytecode-viewertool' >&2
    exit 1
fi

if ! [ -x "$(command -v jadx)" ]; then
  echo '[!] Error: jadx is not installed. Run apt-get install jadx' >&2
  exit 1
fi

echo "[+] Success! Run with apk2url <name of apk file>"