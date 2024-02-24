# apk2url

apk2url easily extracts URL and IP endpoints from an APK file and performs filtering into a .txt output. This is suitable for information gathering by the red team, penetration testers and developers to quickly identify endpoints associated with an application.

**NOTE: Why use apk2url?** When compared with APKleaks, MobSF and AppInfoScanner, apk2url identifies a significantly higher number of endpoints with additional features. 

## Features
- (sub)domain enumeration : Find unique domains and subdomains
- URL + URI Path Finder : Finds interesting URLs with paths and GET params
- IP Address finder : Finds IP addresses
- Log endpoint source : See filename within APK where endpoints were discovered
- Easy to install : Easy installation, run on the fly

## Running apk2url
**NOTE:** apk2url requires apktool and jadx which can be easily installed with `apt`. Please refer to the dependencies section.
```bash
git clone https://github.com/n0mi1k/apk2url
```  
```bash
./apk2url.sh /path/to/apk/file.apk
```

**UPDATE** v1.2 now supports directory input for multiple APKs!
```bash
./apk2url.sh /path/to/apk-directory/
```

You can also install directly for easy access by running `./install.sh`.                        
After that you can run apk2url anywhere:
```bash
apk2url /path/to/apk/file.apk
```
By default there are 2 output files in the "endpoints" directory:  
- \<apkname\>_endpoints.txt - **Contains endpoints with full URL paths**
- \<apkname\>_uniq.txt - **Contains unique endpoint domains and IPs**

By default, the program does not log the Android file name/path where endpoints are discovered.    
To enable logging, run as follows:

```bash
apk2url /path/to/apk/file.apk log
```
**Tested on Kali 2023.2 and Ubuntu 22.04*

## Dependencies
Use `apt` for easy installation of these tools required by apk2url or use `install.sh`:
- sudo apt install apktool
- sudo apt install jadx

## Demonstration
<img width="679" alt="image" src="https://github.com/n0mi1k/apk2url/assets/28621928/f0459e53-f6d9-4e42-a2ed-e146fb36b520">

## Disclaimer
This tool is for educational and testing purposes only. Do not use it to exploit the vulnerability on any system that you do not own or have permission to test. The authors of this script are not responsible for any misuse or damage caused by its use.
