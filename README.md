<div align="center">

# Forensic Team Field Manual (FTFM)
### Free Scripts, Templates & Field Content

[![Buy on Amazon](https://img.shields.io/badge/Buy_on-Amazon-orange?logo=amazon)](https://www.amazon.com/dp/B0F6KD9XJM)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue)](LICENSE)
[![Contributions Welcome](https://img.shields.io/badge/Contributions-Welcome-brightgreen)](CONTRIBUTING.md)

</div>

---

This repo is the free companion to the **Forensic Team Field Manual (FTFM)** — scripts, templates, and field content for digital forensics and incident response practitioners, released openly as a contribution back to the DFIR community.

The book gives you the methodology. This repo gives you the tools to execute it.

> Written by [Alan White](https://www.linkedin.com/in/alan-j-white) | [FTFM on Amazon](https://www.amazon.com/dp/B0F6KD9XJM)

---

## What's Here

Organized by the FTFM investigative lifecycle:

| Folder | Phase | Contents |
|---|---|---|
| [`scripts/01-identification/`](scripts/01-identification/) | Identification | Scoping helpers, pull-plug decision aid |
| [`scripts/02-preservation/`](scripts/02-preservation/) | Preservation | Evidence logging, case note scaffolds |
| [`scripts/03-acquisition/`](scripts/03-acquisition/) | Acquisition | Memory, disk, cloud, container acquisition |
| [`scripts/04-analysis/`](scripts/04-analysis/) | Analysis | Log parsing, artifact collection, browser forensics |
| [`scripts/05-timelines/`](scripts/05-timelines/) | Timelines | Log-to-timeline conversion, timestamp normalization |
| [`scripts/06-reporting/`](scripts/06-reporting/) | Reporting | Report scaffolds, QA checklists |
| [`templates/`](templates/) | All phases | Chain of custody, acquisition auth, case notes |
| [`cheatsheets/`](cheatsheets/) | Reference | Windows forensics, Linux forensics, memory analysis |
| [`resources/`](resources/) | Reference | Tool list, reading list |

---

## Quick Start

```bash
git clone https://github.com/aw31337/ftfm.git
cd ftfm
```

Scripts follow the FTFM section structure. Start with `01-identification` at case open, work through the lifecycle. Templates in `/templates` are drop-in starting points — copy, fill, and keep in your case folder.

---

## Contributing

Pull requests welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).  
Field practitioners: open an [Issue](../../issues) if something needs updating for your environment.

---

## License

Scripts: [MIT License](LICENSE)  
Templates and documentation: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) — share freely with attribution.

---

## Connect

- [FTFM on Amazon](https://www.amazon.com/dp/B0F6KD9XJM)
- [BTFM on Amazon](https://www.amazon.com/dp/B077WF4WYV) — companion blue team manual
- [LinkedIn](https://www.linkedin.com/in/alan-j-white)
