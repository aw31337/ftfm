# Rules of Evidence — Quick Reference

> FTFM Cheatsheet | Section 7 — Legal  
> Ref: https://www.rulesofevidence.org | https://www.law.cornell.edu/rules/fre  
> Source: Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM

Most commonly applicable US Federal Rules of Evidence for digital forensics practitioners. Similar frameworks exist in most global jurisdictions — consult local counsel for non-US matters.

---

## Most Relevant FRE Articles for Digital Evidence

### Article IV — Relevance

| Rule | Name | Practitioner Note |
|---|---|---|
| Rule 401 | Test for Relevant Evidence | Evidence must make a fact more or less probable; digital artifacts must be tied to the case theory |
| Rule 402 | General Admissibility | Relevant evidence is admissible; irrelevant is not — scope your collection |
| Rule 403 | Excluding Evidence | Even relevant evidence can be excluded for prejudice, confusion, or waste of time |

### Article V — Privileges

| Rule | Name | Practitioner Note |
|---|---|---|
| Rule 501 | Privilege in General | Attorney-client communications may be in scope — flag and quarantine |
| Rule 502 | Attorney-Client Privilege | Inadvertent disclosure doesn't waive privilege if reasonable steps taken — document your handling |

### Article VII — Expert Testimony

| Rule | Name | Practitioner Note |
|---|---|---|
| Rule 701 | Opinion by Lay Witnesses | Lay witnesses describe what they observed — no expert opinions |
| **Rule 702** | **Testimony by Expert Witnesses** | You need knowledge, skill, experience, training, or education; opinion must be based on sufficient facts and reliable methodology |
| Rule 703 | Bases of Expert Opinion | Expert may rely on inadmissible facts if experts in the field reasonably rely on them |
| Rule 704 | Opinion on Ultimate Issue | Expert may opine on ultimate issue (e.g., "this is malware"), but not legal conclusions |
| Rule 705 | Disclosing Basis | Expert may testify without first disclosing basis — but opposing counsel can compel disclosure |
| Rule 706 | Court-Appointed Expert | Court may appoint its own expert; rare but worth knowing |

### Article VIII — Hearsay

| Rule | Name | Practitioner Note |
|---|---|---|
| Rule 803 | Exceptions to Hearsay | Business records (803(6)) and public records (803(8)) are key — logs kept in regular course of business qualify |
| Rule 807 | Residual Exception | Catch-all for trustworthy statements not covered elsewhere |

### Article IX — Authentication

| Rule | Name | Practitioner Note |
|---|---|---|
| **Rule 901** | **Authentication** | Evidence must be shown to be what the proponent claims — this is your chain of custody |
| **Rule 902** | **Self-Authenticating Evidence** | Certified copies of public records, official publications, and trade inscriptions need no extrinsic evidence |

### Article X — Writings/Recordings

| Rule | Name | Practitioner Note |
|---|---|---|
| Rule 1002 | Requirement of Original | Original preferred; duplicates generally allowed unless authenticity is at issue |
| **Rule 1003** | **Admissibility of Duplicates** | A forensic copy (bit-for-bit with verified hash) is treated as an original |

---

## Daubert Standard (Expert Methodology)

Courts evaluate expert methodology on four criteria:

| Criterion | What to Demonstrate |
|---|---|
| **Testable** | Your method can be (and has been) tested |
| **Peer-Reviewed** | Methodology published or reviewed by the community |
| **Known Error Rate** | You know the false positive/negative rate of your tools and methods |
| **General Acceptance** | Your approach is accepted within the digital forensics community |

> This is why tool validation, write blocker verification, and hash verification matter beyond just good hygiene — they're your Daubert foundation.

---

## Evidence Handling Principles (ACPO)

Association of Chief Police Officers (UK) — widely adopted internationally:

1. No action should change data that may be relied upon in court
2. Where access to original data is required, the examiner must be competent and able to give evidence explaining their actions
3. An audit trail must exist — all processes applied to digital evidence must be recorded and available for third-party review
4. The senior investigator is responsible for ensuring these principles are followed

---

## Admissibility Checklist

- [ ] Evidence is relevant to a fact in dispute (FRE 401)
- [ ] Chain of custody documented from seizure to court
- [ ] Forensic copy verified with SHA256 + MD5 (FRE 1003)
- [ ] Write blocker used and documented for all acquisitions
- [ ] Examiner credentials documented (FRE 702 — Daubert)
- [ ] Methodology is accepted and testable (Daubert)
- [ ] Any privileged material flagged and set aside (FRE 502)
- [ ] Business records / logs documented as kept in regular course (FRE 803(6))
- [ ] All tools used, with version numbers, recorded in case notes

---

*From the Forensic Team Field Manual (FTFM) — https://www.amazon.com/dp/B0F6KD9XJM*
