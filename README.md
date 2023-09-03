# apk2url

apk2url easily extracts URL and IP endpoints from an APK file to a .txt output. This is suitable for information gathering by red team, penetration testers and developers to quickly identify endpoints associated with an application.

**Note:** apk2url disassembles to Smali and performs Java decompilation to identify URLs and IPs.

*Inspired by [diggy](https://github.com/s0md3v/Diggy), but apk2url is rewritten and upgraded with IP support, stronger regex, filtering and Jadx decompilation*

## Usage

```bash
./apk2url.sh /path/to/apk/file.apk
```

You can also install directly for easy access by running `./install.sh`.                        
After that you can run apk2url anywhere:
```bash
apk2url /path/to/apk/file.apk
```
By default there are 2 output files in the "endpoints" directory:  
- \<apkname\>_endpoints.txt - **Contains endpoints with url paths, has duplicates**
- \<apkname\>_uniqurls.txt - **Contains unique endpoints**

By default, the program does not log the path where endpoints are discovered.    
To enable logging, run as follows:

```bash
apk2url /path/to/apk/file.apk log
```
## Dependencies
Use `apt` for easy installation of these tools:
- Apktool
- Jadx
## Demo Run
<img width="628" alt="image" src="https://github.com/n0mi1k/apk2url/assets/28621928/7a251297-c1e5-49ba-abe2-6aba67c9fee7">

## Disclaimer
This tool is for educational and testing purposes only. Do not use it to exploit the vulnerability on any system that you do not own or have permission to test. The authors of this script are not responsible for any misuse or damage caused by its use.
