# Contributing to FTFM

Contributions from the DFIR community are welcome. Field practitioners make the best contributors — if something doesn't work the way the book describes, tell us.

## What We Want

- Scripts that match the FTFM investigative lifecycle phases
- Platform-specific variations (macOS forensics, cloud-native environments)
- Template improvements from real case experience
- Cheatsheet additions — artifact locations, tool syntax, event IDs

## What We Don't Want

- Tools that destroy evidence or alter system state without clear warnings
- Content that circumvents legal process or chain of custody requirements
- Scripts that require proprietary tools without a documented free alternative

## How to Submit

1. Fork the repo
2. Create a branch: `git checkout -b add/your-contribution-name`
3. Place content in the correct phase folder (`01-identification` through `06-reporting`)
4. Include a header block in every script:
   ```
   # Script: <name>
   # Phase: <FTFM phase number and name>
   # Purpose: <one line>
   # Usage: <example>
   # Requirements: <tools, privileges needed>
   # FTFM Reference: <section>
   ```
5. Open a Pull Request — describe what phase it supports and what gap it fills

## Evidence Integrity Note

Any script that touches evidence must:
- Log what it does and when (timestamp every action)
- Never modify the source — work on copies or read-only mounts
- Output hashes before and after any transfer

## Issues

Open an Issue for:
- Scripts that produce incorrect output
- Platform coverage gaps (e.g. "no macOS acquisition script")
- Template fields that don't match current legal requirements

Label clearly: `bug`, `enhancement`, `platform-gap`, `legal`.
