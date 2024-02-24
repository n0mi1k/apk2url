echo "[+] Starting Installation..."

cp apk2url.sh /usr/bin/apk2url 2>/dev/null
chmod +x /usr/bin/apk2url 2>/dev/null

if ! [ -x "$(command -v apk2url)" ]; then
  echo '[!] Error: installation failed, use sudo' >&2
  exit 1
fi

if ! [ -x "$(command -v apktool)" ]; then
  echo '[!] apktool is not installed. Attempting to install...'
  sudo apt-get update && sudo apt-get install -y apktool
  if ! [ -x "$(command -v apktool)" ]; then
    echo "[!] Error: Failed to install apktool. Exiting."
    exit 1
  fi
fi

if ! [ -x "$(command -v jadx)" ]; then
  echo '[!] jadx is not installed. Attempting to install...'
  sudo apt-get update && sudo apt-get install -y jadx
  if ! [ -x "$(command -v jadx)" ]; then
    echo "[!] Error: Failed to install jadx. Exiting."
    exit 1
  fi
fi

echo "[+] Success! Run with apk2url <name of apk file>"