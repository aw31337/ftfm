# Hex, Binary, Octal Conversions — Linux/Mac
*Section 4 — ANALYSIS | FTFM v2*

Native shell commands for number base conversions. No extra tools required.
All commands run on Linux (bash) and macOS (zsh).

---

## Hex

View file content as hex with ASCII side panel:
```bash
echo <VALUE> | xxd
```

View as raw hexdump only (no ASCII):
```bash
echo <VALUE> | xxd -p
```

Convert hexdump back to binary:
```bash
echo <HEX_STRING> | xxd -p -r
```

Hex to decimal:
```bash
echo $((0x<HEX_VALUE>))
# Example: echo $((0x15a))  → 346
```

---

## Decimal Conversions

Decimal to Hexadecimal:
```bash
echo 'obase=16;<DECIMAL>' | bc
# Example: echo 'obase=16;42' | bc  → 2A
```

Decimal to Octal:
```bash
echo 'obase=8;<DECIMAL>' | bc
# Example: echo 'obase=8;42' | bc  → 52
```

Decimal to Binary:
```bash
echo 'obase=2;<DECIMAL>' | bc
# Example: echo 'obase=2;42' | bc  → 101010
```

---

## Other Base → Decimal

Hexadecimal to Decimal:
```bash
echo 'ibase=16;<HEX_UPPER>' | bc
# Example: echo 'ibase=16;2A' | bc  → 42
```

Octal to Decimal:
```bash
echo 'ibase=8;<OCTAL>' | bc
# Example: echo 'ibase=8;52' | bc  → 42
```

Binary to Decimal:
```bash
echo 'ibase=2;<BINARY>' | bc
# Example: echo 'ibase=2;101010' | bc  → 42
```

---

## printf Shortcuts

Binary to Decimal (printf):
```bash
printf '%d
' 0b<BINARY>
# Example: printf '%d
' 0b101010  → 42
```

Octal to ASCII character:
```bash
printf "\<OCTAL>
"
# Example: printf "\101
"  → A
```

---

## Useful for Forensics

Compute byte offset from sector × block size:
```bash
echo $((<SECTORS> * <BLOCK_SIZE>))
# Example: echo $((2048*512))  → 1048576
```
