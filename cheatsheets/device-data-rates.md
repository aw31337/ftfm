# Device & Interface Data Rates

> FTFM Cheatsheet | Section 3 — Acquisition  
> Ref: https://en.wikipedia.org/wiki/List_of_interface_bit_rates#Peripheral  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

Use this to estimate acquisition time and select the fastest available interface.

---

## Interface Speeds

| Interface | Bit Rate | Bytes/s | Notes |
|---|---|---|---|
| USB 1.1 | 12 Mbit/s | ~1.5 MB/s | Legacy only |
| FireWire 400 | 400 Mbit/s | ~50 MB/s | Legacy — still found in older lab kits |
| USB 2.0 | 480 Mbit/s | ~60 MB/s | Common; avoid for anything >500GB |
| FireWire 800 | 800 Mbit/s | ~100 MB/s | Faster than USB 2.0 |
| **USB 3.0** | **5 Gbit/s** | **~625 MB/s** | Standard for field acquisition |
| **USB 3.1** | **10 Gbit/s** | **~1.21 GB/s** | Preferred for large disks |
| **eSATA** | Up to 6 Gbit/s | ~750 MB/s | Fastest for direct SATA-to-SATA |
| Thunderbolt 1 | 10 Gbit/s × 2 | ~1.25 GB/s per channel | Dual-channel |
| Thunderbolt 2 | 20 Gbit/s | ~2.5 GB/s | Aggregate dual channel |
| **Thunderbolt 3** | **40 Gbit/s** | **~5 GB/s** | Best available for large-scale acquisition |
| 1Gb Ethernet | 1 Gbit/s | ~125 MB/s | Network acquisition baseline |
| 10Gb Ethernet | 10 Gbit/s | ~1.25 GB/s | Enterprise network acquisition |

---

## Acquisition Time Estimator

| Evidence Size | USB 2.0 (~60 MB/s) | USB 3.0 (~500 MB/s) | Thunderbolt 3 (~3 GB/s) |
|---|---|---|---|
| 32 GB | ~9 min | ~1 min | <15 sec |
| 128 GB | ~36 min | ~4 min | ~43 sec |
| 500 GB | ~2.3 hrs | ~17 min | ~2.8 min |
| 1 TB | ~4.6 hrs | ~33 min | ~5.6 min |
| 2 TB | ~9.2 hrs | ~67 min | ~11 min |
| 4 TB | ~18.5 hrs | ~2.2 hrs | ~22 min |
| 8 TB | ~37 hrs | ~4.4 hrs | ~44 min |

> **Note:** Actual throughput is typically 60–80% of interface max. Add 20% to estimates for overhead.  
> Factors: source disk read speed, image compression, hash verification overhead, destination write speed.

---

## SSD vs. HDD Acquisition Notes

| Type | Typical Read Speed | Notes |
|---|---|---|
| Spinning HDD (7200 RPM) | 80–160 MB/s | Interface ceiling rarely the bottleneck |
| SATA SSD | 500–550 MB/s | USB 3.0 is the bottleneck; use eSATA or Thunderbolt |
| NVMe SSD | 3,000–7,000 MB/s | Only Thunderbolt 3/4 can keep up |
| USB Flash Drive | 20–300 MB/s | Wide variance — check spec before estimating |

---

## RAID Configuration Reference

| Type | Min Disks | Fault Tolerance | Usable Capacity | Acquisition Notes |
|---|---|---|---|---|
| RAID 0 | 2 | None | 100% | All disks required; strip pattern critical |
| RAID 1 | 2 | 1 disk | 50% | Image either disk (they're mirrors) |
| RAID 5 | 3 | 1 disk | 65–95% | Requires parity reconstruction |
| RAID 10 | 4 | 1 disk per pair | 50% | RAID 1+0; image each mirrored pair |

> Ref for RAID reconstruction: http://pyflag.sourceforge.net/Documentation/articles/raid/reconstruction_pr.html

---

## Pre-Acquisition Checklist

- [ ] Confirm interface type on source device
- [ ] Select fastest available write blocker + cable combo
- [ ] Estimate acquisition time using table above
- [ ] Confirm destination has sufficient space (source size × 1.1 minimum)
- [ ] Document interface and estimated completion time in case notes
- [ ] Run integrity hash at completion (SHA256 + MD5)

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
