# Live Collection — Linux
*Section 3 — ACQUISITION | FTFM v2*

Commands for collecting volatile data from a live Linux system before shutdown.
Follow order of volatility: memory → network → running processes → disk.

---

## One-Shot Volatile Data Grab via Netcat

Collect processes, network connections, and syslog simultaneously and pipe to remote collection system.
*Run netcat listener on collection system first, then run this on the subject.*

Collection system (run first — waits for incoming data):
```bash
nc -l -p <PORT> > live-collection-<HOSTNAME>-<DATE>.txt
```

Subject system (sends data to collection system):
```bash
(ps aux; netstat -tupan; cat /var/log/messages) | nc <COLLECTION_IP> <PORT>
```

---

## Process List

```bash
ps aux
ps -ef
```

---

## Network Connections

```bash
netstat -tupan
ss -tupan              # modern replacement for netstat on systemd systems
```

---

## Open Files

```bash
lsof
lsof -i                # network connections only
lsof -p <PID>          # open files for specific process
```

---

## Loaded Kernel Modules

```bash
lsmod
```

---

## Logged-in Users

```bash
who
w
last
```

---

## System Information

```bash
uname -a
hostname
uptime
```

---

## Scheduled Tasks

```bash
crontab -l
cat /etc/crontab
ls /etc/cron.*
```

---

## Bash History (per user)

```bash
cat ~/.bash_history
cat /home/<USER>/.bash_history
```

---

## Strings Search in Running Process Memory

```bash
strings /proc/<PID>/mem 2>/dev/null | grep -i <SEARCH_TERM>
```

---

## Remote Memory Acquisition (margaritashotgun)

```bash
margarita_shotgun -s <TARGET_IP> -m lime -o <OUTPUT>.lime
```
Ref. https://github.com/ThreatResponse/margaritashotgun
