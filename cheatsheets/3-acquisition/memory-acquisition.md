# Memory Acquisition & Conversion
*Section 3 — ACQUISITION | FTFM v2*

Commands for acquiring, converting, and preparing memory images on Windows and Linux.
Tested against Windows 10/11 and Ubuntu 20.04+.

---

## Volatility3 — Shell and Image Info

Start an interactive Volatility shell against a memory image:
```
volatility3 -f <MEMORY_IMAGE> volshell
```

Display image metadata and suggested profiles:
```
volatility3 -f <MEMORY_IMAGE> windows.info
```
Ref. https://github.com/volatilityfoundation/volatility3

---

## hiberfil.sys — Convert Hibernation File to Analyzable Image

Convert hiberfil.sys to crash dump using Comae Hibr2Dmp:
```
Hibr2Dmp.exe hiberfil.sys <OUTPUT>.img
```
Ref. https://github.com/Crypt2Shell/Comae-Toolkit

Convert raw memory dump to Windows crash dump format:
```
volatility3 -f <MEMORY_IMAGE> windows.raw2dmp -O <OUTPUT>.dmp
```

Convert hibernation file to raw image:
```
volatility3 -f hiberfil.sys imagecopy -O <OUTPUT_IMAGE>
```

---

## Remote Memory Acquisition (Linux — margaritashotgun)

Acquire memory from remote Linux system over SSH:
```
margarita_shotgun -s <TARGET_IP> -m lime -o <OUTPUT_FILE>.lime
```
Ref. https://github.com/ThreatResponse/margaritashotgun

---

## LeechCore — Direct Memory Access Acquisition

Open a memory device file for acquisition:
```
volatility3 -f <MEMORY_IMAGE> -device "file://file=<PATH_TO_DEVICE>"
```

Open volatile writable memory for live analysis:
```
volatility3 -f <MEMORY_IMAGE> -device "file://file=/dev/<DEVICE>,volatile=1,write=1"
```
Ref. https://github.com/ufrisk/LeechCore/wiki/Device_File

---

## bulk_extractor — Extract Network Artifacts from Memory

Extract URLs, IPs, emails, and connections from memory dump (network module only):
```
bulk_extractor -x all -e net -o <OUTPUT_DIR> <MEMORY_IMAGE>
```
Ref. https://github.com/simsong/bulk_extractor

---

## pagefile.sys — Search for Cleartext Strings

Search Windows pagefile for cleartext artifacts:
```
strings -a extracted_pagefile.sys | less
```

---

## procdump — Process Memory Dump (Windows)

Dump full memory of a specific process (by PID):
```
procdump.exe -accepteula -g -e -t -ma <PID> <OUTPUT_DIR>
```

Dump lsass.exe using native comsvcs.dll MiniDump (no extra tools):
```
Rundll32.exe C:\Windows\System32