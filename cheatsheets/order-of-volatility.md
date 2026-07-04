# Order of Volatility

> FTFM Cheatsheet | Section 3 — Acquisition  
> Ref: RFC 3227 § 2.1 — https://tools.ietf.org/html/rfc3227#section-2.1  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

Collect in this order — most volatile first. Each item below disappears or degrades before the one beneath it.

---

## Priority Order

| Priority | Artifact | Volatility | Notes |
|---|---|---|---|
| 1 | **Running Memory (RAM)** | Seconds–minutes | Encryption keys, process state, network sockets — gone on power-off |
| 2 | **Swap / Page File** | Minutes | Spill of RAM to disk; partially recoverable after shutdown |
| 3 | **Routing Table / ARP Cache** | Minutes | Active connections, peer relationships — clears on reboot |
| 4 | **Active Network Connections** | Minutes | Established/listening sockets, external C2 IPs |
| 5 | **Process Table** | Minutes | Running processes including malware; timestamps and parent PIDs |
| 6 | **Kernel Statistics** | Minutes | CPU/memory usage patterns, loaded kernel modules |
| 7 | **Temporary File Systems** | Hours | `/var/tmp`, `%TEMP%`, virtual memory temp files |
| 8 | **Hard / Virtual Disk** | Days | File system artifacts, unallocated space, deleted files |
| 9 | **Remote Logging Systems** | Days–weeks | SIEM, syslog server — may be modified if attacker has access |
| 10 | **Removable Media** | Weeks | USB drives, SD cards at the scene |
| 11 | **Physical Configuration / Network Topology** | Weeks | Physical layout, device positions, cable runs |
| 12 | **Archival Media / Backup** | Months | Tape, cloud backup — longest retention, least volatile |

---

## Quick Capture Commands

### Linux — Running Memory
```bash
# AVML (preferred, userspace)
avml /mnt/evidence/memory.lime

# LiME via insmod (kernel module)
insmod /path/to/lime.ko "path=/mnt/evidence/memory.lime format=lime"

# Hash immediately
sha256sum /mnt/evidence/memory.lime | tee memory.lime.sha256
```

### Windows — Running Memory
```powershell
# WinPmem
winpmem.exe memory.raw

# DumpIt
DumpIt.exe /O memory.dmp /T RAW

# Hash immediately
Get-FileHash memory.raw -Algorithm SHA256
```

### Linux — Network State (before anything else)
```bash
ss -antp > /mnt/evidence/network_connections.txt
ip route show > /mnt/evidence/routing_table.txt
arp -an > /mnt/evidence/arp_cache.txt
netstat -rn >> /mnt/evidence/routing_table.txt
```

### Windows — Network State
```cmd
netstat -naob > network_connections.txt
arp -a > arp_cache.txt
route print > routing_table.txt
ipconfig /displaydns > dns_cache.txt
```

### Linux — Process Table
```bash
ps auxf > /mnt/evidence/process_list.txt
lsof -n > /mnt/evidence/open_files.txt
```

### Windows — Process Table
```cmd
tasklist /svc /fo csv > process_list.csv
wmic process list full > process_full.txt
```

---

## Checklist

- [ ] Memory captured and hashed
- [ ] Swap/pagefile location noted
- [ ] Network connections logged
- [ ] ARP cache captured
- [ ] Routing table captured
- [ ] Process list captured (with parent PIDs)
- [ ] Open files list captured
- [ ] Disk image initiated (after volatile capture)
- [ ] Remote log snapshot requested from SIEM
- [ ] All captures timestamped and hashed

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
