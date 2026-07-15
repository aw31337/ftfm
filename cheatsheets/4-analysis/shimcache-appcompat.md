# ShimCache & AppCompatCache Analysis
*Section 4 — ANALYSIS | FTFM v2*

AppCompatCache (ShimCache) records evidence of program execution on Windows systems.
Registry key: `HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\AppCompatCache`

---

## Volatility3 — ShimCache from Memory Image

Extract ShimCache entries from a memory dump:
```
volatility3 -f <MEMORY_IMAGE> windows.shimcache
```

---

## AppCompatCacheParser (EZ Tool) — From Live System

Parse AppCompatCache from live registry:
```
AppCompatCacheParser.exe -f C:\Windows\System32