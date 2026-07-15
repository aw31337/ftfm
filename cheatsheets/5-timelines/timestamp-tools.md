# Timestamp Manipulation & Analysis Tools
*Section 5 — TIMELINES | FTFM v2*

Commands for identifying, decoding, and analyzing filesystem timestamps on Windows and Linux.

---

## NTFS Last Access Timestamp — Enable/Disable

Check current status (registry key):
```
HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\NtfsDisableLastAccessUpdate
```
Value `0x1` = last access tracking is **OFF**. Value `0x0` = **ON**.

Enable last access tracking (requires reboot):
```
fsutil behavior set disablelastaccess 0
```

Disable last access tracking:
```
fsutil behavior set disablelastaccess 1
```
Ref. https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/fsutil-behavior

---

## setmace — Modify $MFT Timestamps (Windows)

Dump all timestamps for the $MFT file itself:
```
setmace.exe C:\$MFT -d
```

Alternative using MFT device path:
```
setmace.exe C:0 -d
```

Display both `$FILE_NAME` and `$STANDARD_INFORMATION` timestamps for a file:
```
setmace.exe <TARGET_FILE> -d
```
Ref. https://code.google.com/archive/p/mft2csv/wikis/SetMACE.wiki

---

## mft2csv — Convert MFT to CSV

Convert the raw $MFT to a CSV for timeline analysis:
```
mft2csv.exe /input:C:\$MFT /output:<OUTPUT_DIR>
```
Ref. https://code.google.com/archive/p/mft2csv

---

## analyzeMFT — Python MFT Parser

Parse $MFT and output CSV (use when mft2csv fails):
```
python3 analyzeMFT.py -f <MFT_FILE> -o <OUTPUT>.csv
```
Ref. https://github.com/dkovar/analyzeMFT

---

## plaso / log2timeline — Multi-Source Timeline Engine

Create a Plaso storage file from an image:
```
log2timeline.py <OUTPUT>.plaso <IMAGE_OR_DIR>
```

Filter the storage file to a CSV timeline:
```
psort.py -o l2tcsv -w <OUTPUT>.csv <PLASO_FILE>
```

Filter by date range:
```
psort.py -o l2tcsv -w <OUTPUT>.csv <PLASO_FILE> "date > '2026-01-01' AND date < '2026-07-01'"
```
Ref. https://plaso.readthedocs.io/en/latest/sources/user/Users-Guide.html

---

## time_decode — Multi-Format Timestamp Decoder

Decode a timestamp in multiple formats simultaneously:
```
python3 time_decode.py --guess <TIMESTAMP_VALUE>
```

Decode specific format (e.g. Windows FILETIME):
```
python3 time_decode.py --windows-filetime <TIMESTAMP_VALUE>
```
Ref. https://github.com/digitalsleuth/time_decode

---

## Chrome Timestamp Conversion (WebKit epoch)

Chrome stores timestamps as microseconds since January 1, 1601:
```bash
python3 -c "import datetime; print(datetime.datetime(1601,1,1) + datetime.timedelta(microseconds=<CHROME_TIMESTAMP>))"
```

---

## dir — Quick Timestamp View (Windows CMD)

List files sorted by creation time:
```
dir <DIRECTORY>\* /tc /od
```

List files sorted by last write time:
```
dir <DIRECTORY>\* /tw /od
```

List files sorted by last access time:
```
dir <DIRECTORY>\* /ta /od
```

---

## Windows FILETIME to Unix epoch (PowerShell)

```powershell
[datetime]::FromFileTime(<WINDOWS_FILETIME_VALUE>)
```

## Unix epoch to human-readable (Linux)

```bash
date -d @<UNIX_EPOCH>
```
