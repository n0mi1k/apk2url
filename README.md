
# apk2url

apk2url easily extracts URL and IP endpoints from an APK file to a .txt output. This is suitable for information gathering by red team, penetration testers and developers to quickly identify endpoints associated with an application.

**Note:** apk2url disassembling to Smali and performs Java decompilation to identify URLs and IPs.


## Usage

```bash
./apk2url.sh /path/to/apk/file.apk
```

You can also install directly for easy access by running `./install.sh`.                        
After that you can run apk2url anywhere:
```bash
apk2url /path/to/apk/file.apk
```

By default, the program does not log the path where endpoints are discovered.    
To enable logging, run as follow:

```bash
apk2url /path/to/apk/file.apk log
```
## Dependencies
Use `apt` for easy installation of these tools:
- Apktool
- Jadx
## Demo Run

<img width="496" alt="image" src="https://github.com/n0mi1k/apk2url/assets/28621928/75e1d421-ff72-47b6-8e82-996d655cce5e">