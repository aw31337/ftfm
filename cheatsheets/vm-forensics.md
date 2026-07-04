# Virtual Machine Forensics

> FTFM Cheatsheet | Section 3 & 4 — Acquisition and Analysis  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

---

## VMware File Types

| Extension | Description | Forensic Value |
|---|---|---|
| `.vmx` | Primary config file | VM settings, hardware profile, snapshot references |
| `.vmdk` | Virtual disk | Primary evidence — contains OS, apps, user data |
| `flat.vmdk` | Raw disk data file | Paired with descriptor `.vmdk` |
| `delta.vmdk` | Snapshot delta disk | Changes since last snapshot |
| `rdm.vmdk` | Raw device mapping descriptor | Points to physical disk |
| `.vmss` | Suspended state file | Equivalent of memory dump — contains running state |
| `.vmsn` | Snapshot memory file | Memory at time of snapshot |
| `.vmsf` | Snapshot flags | Snapshot metadata |
| `.nvram` | BIOS/NVRAM state | Boot order, BIOS settings |
| `.log` | VM log | Activity log — timestamps, power events |
| `.vswp` | VM swap file | Paged memory from guest |

---

## VirtualBox File Types

| Extension | Description |
|---|---|
| `.vdi` | Native VirtualBox disk image |
| `.vbox` | XML config file |
| `.vbox-prev` | Previous config (auto-backup) |
| `.sav` | Saved machine state |

---

## Hyper-V File Types

| Extension | Description |
|---|---|
| `.vhd` / `.vhdx` | Virtual hard disk |
| `.avhd` / `.avhdx` | Differencing (snapshot) disk |
| `.vmcx` | VM config |
| `.vmrs` | Runtime state / memory |
| `.vsv` | Saved state |

---

## Acquisition Commands

### VMware — Clone Disk to Raw Image
```bash
# Convert VMDK to raw image (preserves all data)
qemu-img convert -f vmdk /path/to/disk.vmdk -O raw /mnt/evidence/disk.img

# Verify with hash
sha256sum /mnt/evidence/disk.img | tee disk.img.sha256
```

### VirtualBox — Clone to Raw Image
```bash
# VBoxManage clone
vboxmanage clonemedium /path/to/disk.vdi /mnt/evidence/disk.raw --format raw

# Hash
sha256sum /mnt/evidence/disk.raw | tee disk.raw.sha256
```

### Mount Raw Image for Analysis
```bash
# List partitions in image
fdisk -l /mnt/evidence/disk.img

# Mount specific partition (offset in bytes = start_sector × 512)
mount -o ro,loop,offset=<BYTES> /mnt/evidence/disk.img /mnt/analysis

# Or use kpartx to map all partitions
kpartx -av /mnt/evidence/disk.img
mount -o ro /dev/mapper/loop0p1 /mnt/analysis
```

### Mount VMDK Directly
```bash
# qemu-nbd method
modprobe nbd max_part=16
qemu-nbd -c /dev/nbd0 /path/to/disk.vmdk
partprobe /dev/nbd0
mount -o ro /dev/nbd0p1 /mnt/analysis

# Cleanup after
umount /mnt/analysis
qemu-nbd -d /dev/nbd0
```

---

## OVA / OVF Handling

```bash
# OVF = XML descriptor for OVA bundle
# OVA = TAR archive containing OVF + VMDKs

# Extract OVA contents
tar -xvf image.ova

# Inspect OVF
cat image.ovf | grep -E "(disk|network|memory)"
```

---

## Cloud — Azure Evidence

```bash
# Download copy from Azure Blob (AzCopy v10)
azcopy copy "https://account.blob.core.windows.net/container/disk.vhd" /mnt/evidence/disk.vhd

# Reference: https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10
```

---

## Amazon AWS — EBS Snapshot

```bash
# Use 4n6ir Imager to convert EBS Snapshot to DD image
# Ref: https://www.4n6ir.com/scripts/Snapshot-4n6ir-Imager.py.gz
python3 Snapshot-4n6ir-Imager.py --region us-east-1 --snapshot snap-XXXXXXXXX --output /mnt/evidence/ebs.img
```

---

## Memory Analysis — Hyper-V

Volatility supports Hyper-V `.vmrs` / `.vsv` saved state files directly:
```bash
volatility -f /path/to/vm.vsv --profile=Win10x64 pslist
# Ref: https://www.wyattroersma.com/?p=77
```

---

## Snapshot Forensics

- Snapshots preserve a point-in-time state — compare before/after for attacker changes
- `delta.vmdk` files show changes since the snapshot — may contain attacker artifacts absent from base disk
- Chain snapshots carefully: `base → delta1 → delta2` — full picture requires all layers

---

## Checklist

- [ ] All VM files identified and inventoried
- [ ] `.vmss` / `.vmsn` captured if system was suspended (contains memory)
- [ ] `.log` file captured for timeline (power events, suspend/resume)
- [ ] Disk cloned to raw image with write blocker or read-only flag
- [ ] Hash verified before and after transport
- [ ] Snapshot deltas captured if present
- [ ] Cloud/hosted VMs: snapshot taken at platform level before any action

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
