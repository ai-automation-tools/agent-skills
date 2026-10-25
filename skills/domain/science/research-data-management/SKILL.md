---
name: research-data-management
description: Plan and run the life of research data so it stays findable, understandable and reusable, applying the FAIR principles, folder and file naming, README and data dictionaries, metadata standards, formats that outlive their software, licences (CC0, CC BY), versioning, backups (3-2-1), sensitive and human-subjects data, data management plans, and depositing in a repository (Zenodo, Dryad, OSF, or domain repositories such as GEO, SRA, PRIDE, PDB) with a DOI. Use when asked to organize data, write a data management plan, share or publish a dataset, choose a repository or licence, or meet a funder or journal data-sharing requirement.
---

# Research data management

Data that only its creator can find and interpret is lost the day they move on. Manage it
so a stranger, or you in two years, could reuse it.

## FAIR, concretely

| Principle | Means in practice |
|:---|:---|
| **Findable** | A persistent identifier (DOI) from a repository; rich metadata; indexed in a searchable catalogue |
| **Accessible** | Retrievable by its identifier over a standard protocol; metadata stays available even if the data must be restricted |
| **Interoperable** | Open, standard formats; community vocabularies and ontologies (e.g. units from UO, organisms from NCBI Taxonomy, genes as HGNC symbols) |
| **Reusable** | A clear licence, provenance (who made it, how, from what), and documentation detailed enough to reuse without asking |

FAIR doesn't mean open: sensitive data can be FAIR with controlled access.

## Organize from day one

- **One folder per study**, with `raw/` (never edited), `processed/` (made by scripts),
  and a `README`.
- **File names:** `YYYY-MM-DD_project_sample_condition_v01.csv`: dates ISO 8601, no
  spaces, no special characters, leading zeros so files sort.
- **README** at the top of each dataset: what it is, who made it, when, how it was
  collected, the folder structure, and how files relate.
- **Data dictionary** for each table: column name, description, type, units, allowed
  values, missing-value code.

## Formats that last

Prefer open, documented formats: CSV or TSV (with UTF-8 and a stated delimiter), Parquet
for large tables, JSON, HDF5 or Zarr for arrays, TIFF/OME-TIFF for images, FASTQ, BAM and
VCF for sequencing data. Export from proprietary formats (`.xlsx`, instrument files) too,
keeping the original.

## Versioning and backup

- Never overwrite raw data. Version processed outputs, or regenerate them from scripts.
- Track code and small text data in git; large data in a repository, object storage, or a
  data-versioning tool (DVC, DataLad).
- **3-2-1 backups:** three copies, on two kinds of media, one off-site. Test a restore.
- Checksums (`sha256`) for large files, to prove a copy is intact.

## Sensitive data

- Human-subjects data needs ethics approval and consent covering storage and sharing.
- **De-identify** before analysis where possible: remove direct identifiers, and consider
  indirect ones (rare conditions, small geographies, exact dates). De-identification is
  not anonymization; re-identification risk remains.
- Restrict access, encrypt at rest, log who accessed what, and follow the governing law
  (HIPAA, GDPR) and the institution's rules. Never put identifiable data in a public
  repository, a git repo, or a prompt to an external model.

## Share and publish

1. **Pick a repository**: a domain repository first (GEO or SRA for sequencing, PRIDE for
   proteomics, PDB for structures, ICPSR for social science), otherwise a general one
   (Zenodo, Dryad, Figshare, OSF).
2. **Pick a licence**: CC0 (maximizes reuse) or CC BY (requires attribution) for data;
   say it in the README and the repository record.
3. **Deposit** data, README, data dictionary and the code that made the processed files
   (or a link to it), and get a DOI.
4. **Cite the dataset** in the paper with its DOI, in a data availability statement.

## Data management plans

Funders often require one. Cover: what data will be produced (types, volumes, formats);
standards and metadata; storage, backup and security during the project; ethics and legal
constraints; where it'll be shared, when, and under what licence; who is responsible; and
the cost. Check the specific funder's template and current policy, which change.
