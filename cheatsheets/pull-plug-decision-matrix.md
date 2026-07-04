# Pull Plug Decision Matrix

> FTFM Cheatsheet | Section 1 — Identification  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

Use the model that best fits your organization's risk-based decision and legal obligations.

---

## The Core Decision

| State | Action | When |
|---|---|---|
| System is **OFF** | Dead box acquisition | Default — no volatile data risk |
| System is **ON** | Live acquisition first, then decide | Encryption active, memory needed, or active C2 observed |

> **Pull Plug** = power down, network disconnect, VM pause/snapshot, full shutdown, or any isolation action  
> **Keep Plug** = isolate and compensate — don't fully sever until you've weighed continuity + evidence

---

## Pull Plug — Indicators

| Factor | Notes |
|---|---|
| **Reputational Harm** | Active breach spreading — containment outweighs evidence preservation |
| **Data Integrity Risk** | Attacker actively destroying/modifying data |
| **Data Exfiltration in Progress** | Every second online = more data leaving |
| **Malicious Damage** | Ransomware encrypting, wipers running, destructive payload active |
| **Higher Impact** | Business or legal cost of staying up exceeds cost of going down |

---

## Keep Plug — Indicators

| Factor | Notes |
|---|---|
| **Inactive Malware/Adware** | Dormant or low-risk — pull plug destroys running memory with nothing to show for it |
| **Business Continuity Requirement** | Production system; downtime cost is severe |
| **Key Active C2** | Active C2 channel is intelligence — capture traffic before killing it |
| **Law Enforcement Requirements** | LE may require system to remain live for intercept or warrant compliance |
| **Lower Impact** | Incident is contained; live observation yields more than shutdown |

---

## Decision Checklist

- [ ] Is whole-disk encryption active (BitLocker, FileVault, LUKS)? → Live acquisition for keys/memory
- [ ] Is running memory needed? → Capture first, then decide pull vs. keep
- [ ] Is data actively exfiltrating? → Network isolation immediately, then assess
- [ ] Is LE involved or likely? → Consult legal before any action
- [ ] Is business continuity at risk? → Escalate to incident manager before pulling
- [ ] Is a VM? → Pause/snapshot before any other action (preserves all state)

---

## Quick Reference by Scenario

| Scenario | Recommended Action |
|---|---|
| Ransomware encrypting files | Pull (isolate network first, then power) |
| Malware found but inactive | Keep — capture memory, collect artifacts, monitor |
| Active data exfil confirmed | Network isolate immediately; live triage memory before power-off |
| VM on hypervisor | Snapshot (quiesce if possible), then full analysis offline |
| Encrypted disk, system ON | Memory capture first (get encryption keys), then pull |
| Encrypted disk, system OFF | Do not power on without write blocker plan |
| LE warrant in progress | Keep — consult LE before any action that modifies state |
| Remote access/VPN active | Isolate network, do NOT pull power — running state is evidence |

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
