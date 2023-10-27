# apk2url

apk2url easily extracts URL and IP endpoints from an APK file to a .txt output. This is suitable for information gathering by the red team, penetration testers and developers to quickly identify endpoints associated with an application.

**NOTE: Why use apk2url?** When compared with APKleaks, MobSF and AppInfoScanner, apk2url identifies a significantly higher number of endpoints.

*Inspired by [diggy](https://github.com/s0md3v/Diggy), apk2url is rewritten and upgraded with IP support, stronger regex, auto filtering and Jadx decompilation.*

## Running apk2url
```bash
git clone https://github.com/n0mi1k/apk2url
```
```bash
./apk2url.sh /path/to/apk/file.apk
```

You can also install directly for easy access by running `./install.sh`.                        
After that you can run apk2url anywhere:
```bash
apk2url /path/to/apk/file.apk
```
By default there are 2 output files in the "endpoints" directory:  
- \<apkname\>_endpoints.txt - **Contains endpoints with full URL paths**
- \<apkname\>_uniqurls.txt - **Contains unique endpoint domains and IPs**

By default, the program does not log the APK file path where endpoints are discovered.    
To enable logging, run as follows:

```bash
apk2url /path/to/apk/file.apk log
```
**Tested on Kali 2023.2 and Ubuntu 22.04*

## Dependencies
Use `apt` for easy installation of these tools required by apk2url:
- Apktool
- Jadx

## Demonstration
<img width="628" alt="image" src="https://github.com/n0mi1k/apk2url/assets/28621928/7a251297-c1e5-49ba-abe2-6aba67c9fee7">

## Disclaimer
This tool is for educational and testing purposes only. Do not use it to exploit the vulnerability on any system that you do not own or have permission to test. The authors of this script are not responsible for any misuse or damage caused by its use.
