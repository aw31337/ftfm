# Sleuth Kit (TSK) — Command Reference
*Section 4 — ANALYSIS | FTFM v2*

The Sleuth Kit is an open-source digital forensics toolkit. All commands run on Linux and macOS.
Install: `sudo apt install sleuthkit` or `brew install sleuthkit`

---

## File System Layer

Display file system statistics (type, block size, layout):
```bash
fsstat <IMAGE>
```

---

## Filename Layer

Find filename for a given inode:
```bash
ffind <IMAGE> <INODE>
```

List files in a directory by inode:
```bash
fls <IMAGE>
fls -r -p <IMAGE>          # recursive with full paths
fls -d <IMAGE>             # show only deleted files
```

---

## Metadata Layer

Display metadata for a specific inode:
```bash
istat <IMAGE> <INODE>
```

Extract file content by inode:
```bash
icat <IMAGE> <INODE> > <OUTPUT_FILE>
```

List inodes:
```bash
ils <IMAGE>
ils -e <IMAGE>             # include unallocated
```

Find inode for a given filename:
```bash
ifind -n <FILENAME> <IMAGE>
ifind -d <DATA_UNIT> <IMAGE>
```

---

## Data Unit Layer

Display block content:
```bash
dcat <IMAGE> <BLOCK_NUM>
```

List all unallocated data units:
```bash
dls <IMAGE>
dls -e <IMAGE>             # include allocated
```

Display stats for a data unit:
```bash
dstat <IMAGE> <BLOCK_NUM>
```

Calculate data unit address:
```bash
dcalc <IMAGE> <INODE>
```

---

## Journal Layer

Display journal content (NTFS $LogFile / ext4 journal):
```bash
jcat <IMAGE> <BLOCK_NUM>
```

List journal entries:
```bash
jls <IMAGE>
```

---

## Media Management

Display partition table layout:
```bash
mmls <IMAGE>
```

---

## Image File Tools

Display image metadata (format, size, sector count):
```bash
img_stat <IMAGE>
```

Extract raw data from image:
```bash
img_cat <IMAGE>
```

---

## Mactime — Build File Timeline from Body File

Generate body file from image:
```bash
fls -r -m / <IMAGE> > body.txt
```

Create timeline from body file:
```bash
mactime -b body.txt -d > timeline.csv
```

Date-scoped timeline:
```bash
mactime -b body.txt -z <TIMEZONE> <START_DATE> <END_DATE> > timeline.csv
```

---

## Hashing a File by Inode

Extract file and hash in one step:
```bash
icat <IMAGE> <INODE> | md5sum
icat <IMAGE> <INODE> | sha256sum
```
