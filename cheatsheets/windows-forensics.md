# Windows Forensics Quick Reference

> FTFM Cheatsheet | Section 3 & 4 — Acquisition and Analysis

## Key Artifact Locations

### User Activity
```
%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Recent\     # LNK files (recent files)
%USERPROFILE%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
%USERPROFILE%\NTUSER.DAT                                    # User registry hive
%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\   # Jump lists
```

### Browser Artifacts
```
Chrome:  %LOCALAPPDATA%\Google\Chrome\User Data\Default\History
Firefox: %APPDATA%\Mozilla\Firefox\Profiles\*.default\places.sqlite
Edge:    %LOCALAPPDATA%\Microsoft\Edge\User Data\Default\History
```

### Prefetch (Execution Evidence)
```
C:\Windows\Prefetch\*.pf    # Last 8 run times, file references
                             # Disabled by default on Server; enabled on Workstation
```

### Registry Hives
```
SYSTEM:   C:\Windows\System32\config\SYSTEM
SOFTWARE: C:\Windows\System32\config\SOFTWARE
SAM:      C:\Windows\System32\config\SAM        # Local account hashes
SECURITY: C:\Windows\System32\config\SECURITY
NTUSER:   C:\Users\<user>\NTUSER.DAT
```

### Volume Shadow Copies
```
# List VSS snapshots
vssadmin list shadows

# Access via symlink (admin required)
mklink /d C:\vss \\?\GLOBALROOT\Device\HarddiskVolumeShadowCopy1\
```

### Event Logs
```
C:\Windows\System32\winevt\Logs\Security.evtx
C:\Windows\System32\winevt\Logs\System.evtx
C:\Windows\System32\winevt\Logs\Application.evtx
C:\Windows\System32\winevt\Logs\Microsoft-Windows-PowerShell%4Operational.evtx
C:\Windows\System32\winevt\Logs\Microsoft-Windows-Sysmon%4Operational.evtx
```

## Memory Acquisition (Windows)

```powershell
# WinPmem (open source)
winpmem.exe memory.raw

# DumpIt
DumpIt.exe /O memory.dmp /T RAW

# Verify hash immediately after
Get-FileHash memory.raw -Algorithm SHA256
```

## Key PowerShell Forensic Commands

```powershell
# Running processes with full paths
Get-Process | Select-Object Id, Name, Path, StartTime | Sort StartTime -Desc

# Network connections
Get-NetTCPConnection | Where-Object State -eq Listen | Select LocalPort, OwningProcess
Get-NetTCPConnection | Where-Object State -eq Established

# Recently modified files
Get-ChildItem C:\Users -Recurse -Force |
  Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-1)} |
  Sort LastWriteTime -Desc | Select FullName, LastWriteTime | head 50

# Scheduled tasks
Get-ScheduledTask | Where-Object State -ne Disabled | Select TaskName, TaskPath

# Installed services
Get-Service | Where-Object Status -eq Running | Select Name, DisplayName, StartType

# Local users and groups
Get-LocalUser | Select Name, Enabled, LastLogon
Get-LocalGroupMember Administrators
```

## Disk Acquisition (FTK Imager / dd)

```bash
# Linux dd to image a Windows disk (attach externally)
dd if=/dev/sdX of=/mnt/evidence/image.dd bs=4M conv=sync,noerror status=progress

# Hash immediately
sha256sum /mnt/evidence/image.dd | tee image.sha256
```
