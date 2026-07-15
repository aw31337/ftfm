# MFT Collection — Windows
*Section 3 — ACQUISITION | FTFM v2*

Commands for extracting and working with the NTFS Master File Table ($MFT) from live or offline systems.
All commands require Windows 10/11 or Windows Server 2019+.

---

## Install ZimmermanTools (PowerForensics suite)

Install EZ Tools module set from PowerShell Gallery:
```powershell
Find-Module -Name ZimmermanTools | Install-Module
```

## Get-ForensicFileRecord (PowerForensics)

Install PowerForensics from GitHub:
```powershell
Install-ModuleFromGitHub -GitHubRepo Invoke-IR/PowerForensics
```
Ref. https://github.com/Invoke-IR/PowerForensics

Collect all MFT file records from volume C:
```powershell
$mft = Get-ForensicFileRecord -VolumeName C:
```

Export all MFT records to file:
```powershell
Get-ForensicFileRecord | Out-File <OUTPUT_FILE>
```

Read MFT record at specific index (e.g. index 0 = $MFT itself):
```powershell
Get-ForensicFileRecord -VolumeName C: -Index 0
```

Check MFT file size in MB:
```powershell
(Get-Item -Path ./<MFT_FILE>).Length/1MB
```

---

## mftdump — Offline MFT Parsing

Dump MFT to output file:
```
mftdump.exe /o <OUTPUT_FILE> $MFT
```
Ref. https://tzworks.com/download.php?proto_id=9&vers=win&typ=arm64

---

## RawCopy — Extract Locked System Files

Copy locked file (e.g. $MFT) from live system:
```
RawCopy.exe /FileNamePath:C:0 /OutputPath:<OUTPUT_DIR>
```
Ref. https://github.com/jschicht/RawCopy

---

## Get-RemoteMFT — Remote MFT Collection (PowerShell)

Download script:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/picheljitsu/Powershell/master/Forensics/Get-RemoteMFT.ps1" -OutFile ./Get-RemoteMFT.ps1
```

Collect MFT from remote system:
```powershell
Get-RemoteMFT -ComputerName <HOSTNAME> -OutputFile <OUTPUT_FILE>
```
Ref. https://github.com/picheljitsu/Powershell/blob/master/Forensics/Get-RemoteMFT.ps1

---

## Temporarily disable Windows Defender real-time monitoring

Disable (run as Administrator — for acquisition only):
```powershell
Set-MpPreference -DisableRealtimeMonitoring $true
```

Re-enable immediately after collection:
```powershell
Set-MpPreference -DisableRealtimeMonitoring $false
```

---

## Expand a downloaded zip archive

```powershell
Expand-Archive -Path <ARCHIVE>.zip -DestinationPath <OUTPUT_DIR>
```
