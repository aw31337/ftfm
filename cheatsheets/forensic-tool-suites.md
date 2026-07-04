# Forensic Tool Suites & Distributions

> FTFM Cheatsheet | Sections 3 & 4 — Acquisition and Analysis  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

---

## Bootable ISOs, VMs & Distributions

| Name | Type | Focus | Link |
|---|---|---|---|
| **SIFT Workstation** | VM / ISO | DFIR — memory, disk, network forensics | https://www.sans.org/tools/sift-workstation/ |
| **Kali Linux** | ISO / VM | Offensive + forensic tools | https://www.kali.org |
| **REMnux** | VM / ISO | Malware reverse engineering | https://remnux.org |
| **TAILS** | Live USB | Privacy / OSINT / anonymous investigation | https://tails.boum.org |
| **Autopsy (Sleuth Kit)** | App | Disk / filesystem forensics GUI | https://sleuthkit.org/autopsy/ |
| **WinFE** | USB | Forensic Windows environment (write-protected boot) | https://winfe.wordpress.com |
| **Paladin** | ISO | DFIR Linux (Sumuri) | https://sumuri.com/paladin |
| **Tsurugi Linux** | ISO | DFIR + OSINT | https://tsurugi-linux.org |

---

## Memory Analysis

| Tool | Platform | Notes |
|---|---|---|
| **Volatility 3** | Cross-platform | Industry standard; supports Win/Linux/macOS profiles | https://github.com/volatilityfoundation/volatility3 |
| **Volatility 2** | Cross-platform | Legacy but still useful for older OS profiles |
| **Rekall** | Cross-platform | Forked from Volatility; GRR-integrated |
| **WinPmem** | Windows | Memory acquisition for Volatility | https://github.com/Velocidex/WinPmem |
| **AVML** | Linux | Microsoft memory acquisition tool (userspace) | https://github.com/microsoft/avml |
| **LiME** | Linux | Loadable kernel module for memory acquisition | https://github.com/504ensicsLabs/LiME |
| **DumpIt** | Windows | Single-click memory acquisition | https://www.magnetforensics.com |

---

## Disk & Filesystem

| Tool | Notes |
|---|---|
| **FTK Imager** | Free imaging tool from AccessData; creates E01/DD/AFF | https://www.exterro.com/ftk-imager |
| **Guymager** | Linux GUI imager; supports DD, EWF | https://guymager.sourceforge.io |
| **dc3dd / dcfldd** | Enhanced dd with hashing and logging |
| **Autopsy** | GUI for Sleuth Kit — timeline, keyword search, artifact extraction |
| **Sleuth Kit (TSK)** | Command-line file system analysis |
| **TestDisk / PhotoRec** | Partition recovery and file carving |
| **Scalpel / Foremost** | File carving from raw images |

---

## Network Forensics

| Tool | Notes |
|---|---|
| **Wireshark** | GUI packet analysis | https://www.wireshark.org |
| **tcpdump** | CLI packet capture (see tcpdump cheatsheet) |
| **NetworkMiner** | Passive network capture and artifact extraction | https://www.netresec.com/?page=NetworkMiner |
| **Zeek (formerly Bro)** | Network analysis framework — log-based | https://zeek.org |
| **Rita** | Threat hunting on Zeek logs | https://github.com/activecm/rita |
| **Moloch / Arkime** | Full packet capture at scale | https://arkime.com |

---

## Log Analysis & SIEM

| Tool | Notes |
|---|---|
| **Splunk** | Industry SIEM — free trial; BOTS data sets available |
| **Elastic Stack (ELK)** | Open source SIEM — Elasticsearch + Logstash + Kibana |
| **Graylog** | Open source log management |
| **Chainsaw** | Fast Windows event log parsing via Sigma rules | https://github.com/WithSecureLabs/chainsaw |
| **Hayabusa** | Windows event log threat hunting | https://github.com/Yamato-Security/hayabusa |
| **LogParser** | Microsoft tool for querying log files with SQL |

---

## Malware Analysis

| Tool | Notes |
|---|---|
| **Cuckoo Sandbox** | Automated dynamic analysis | https://cuckoosandbox.org |
| **Any.run** | Interactive online sandbox | https://any.run |
| **VirusTotal** | Multi-engine hash/file/URL analysis | https://virustotal.com |
| **Ghidra** | NSA reverse engineering framework | https://ghidra-sre.org |
| **IDA Pro** | Commercial disassembler (industry standard) |
| **x64dbg** | Open source debugger for Windows PE | https://x64dbg.com |
| **YARA** | Malware pattern matching | https://virustotal.github.io/yara/ |
| **Detect-It-Easy (DIE)** | File type / packer detection | https://github.com/horsicq/Detect-It-Easy |

---

## IR Platforms & Orchestration

| Tool | Notes |
|---|---|
| **GRR Rapid Response** | Google's IR framework — remote live forensics | https://github.com/google/grr |
| **TheHive** | Incident response platform | https://thehive-project.org |
| **Cortex** | Observable analysis engine (integrates with TheHive) |
| **RTIR** | Request Tracker for Incident Response | https://www.bestpractical.com/rtir/ |
| **Velociraptor** | Endpoint visibility + IR | https://www.velocidex.com |
| **OSQuery** | SQL-based endpoint telemetry | https://osquery.io |

---

## Cloud Forensics

| Tool / Service | Notes |
|---|---|
| **AWS CloudTrail** | API activity logging — key for cloud IR |
| **AWS S3 Access Logs** | Object-level access |
| **Azure Monitor / Defender** | Azure logging and detection |
| **GCP Cloud Audit Logs** | Google Cloud activity |
| **AzCopy** | Azure blob acquisition | https://docs.microsoft.com/azure/storage/common/storage-use-azcopy-v10 |
| **4n6ir Imager** | EBS Snapshot → DD image | https://www.4n6ir.com |

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
