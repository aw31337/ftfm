# Common Case Details Form

> FTFM Template | Section 2 — Preservation  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

Capture at case open. Complete for every system/location. One form per device or evidence location.

---

## Case Identification

| Field | Value |
|---|---|
| Case / Unique Identifier | |
| Date | |
| Time | |
| Time Zone | |

---

## Physical Location

| Field | Value |
|---|---|
| Address | |
| Building | |
| Floor | |
| Room Number / Name | |
| GPS Coordinates | |

---

## Acquisition Team

| Field | Value |
|---|---|
| Agency / Company Name | |
| Team Name | |
| Lead Investigator | |
| Team Member | |
| Team Member | |
| Mobile # | |
| Office # | |
| Email | |

---

## Personnel Present

| Role | Name | Phone | Email |
|---|---|---|---|
| Personnel 1 | | | |
| Personnel 2 | | | |
| Personnel 3 | | | |
| Witness 1 | | | |
| Witness 2 | | | |

---

## Visible Documentation

| Item | Notes |
|---|---|
| Photos / Video taken | Yes / No |
| Camera used | |
| CCTV present | Yes / No / Location: |
| CCTV preservation requested | Yes / No |

---

## Technology Documentation

| Field | Value |
|---|---|
| Make / Brand | |
| Model | |
| Serial Number | |
| CPU Date / Time / Zone (from device) | |
| Wall clock Date / Time / Zone (reference) | |
| Time delta (wall vs. device) | |
| Power state at time of action | On / Off / Sleep / Suspended |
| Decision (Pull / Keep / Snapshot) | |

---

## Network Configuration

```
Interface:
IP Address:
Subnet Mask:
Default Gateway:
DNS Servers:
MAC Address:
Hostname:
Domain:
DHCP / Static:
```

---

## Evidence Tag / Bag

| Field | Value |
|---|---|
| Tag / Bag / Seal # | |
| Condition on receipt | |
| Damage or anomalies noted | |

---

## Tools / Devices Used

| Tool | Version | Serial / License |
|---|---|---|
| Write Blocker | | |
| Acquisition Software | | |
| Forensic Boot Media | | |
| Hash Algorithm Used | SHA256 + MD5 | |

---

## Other Documentation

| Item | Value |
|---|---|
| Journal / Written artifacts | Yes / No |
| Tracking device used | Yes / No |
| Other chain of custody forms | Yes / No — Reference: |

---

## Case Notes Commands

```bash
# Linux — timestamped append-only note
echo "$(date +%F-%T) <NOTES>" >> ./case_notes.txt

# Windows CMD — timestamped append
echo %date% %time% <NOTES> >> case_notes.txt
```

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
