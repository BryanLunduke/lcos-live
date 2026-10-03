# LCOS 0.6 — Official release staging facts

**Date:** 2026-09-23 (America/Chicago / CDT)

## Official ISO

| Field | Value |
|-------|-------|
| Filename | `lcos-live-06-03.iso` |
| Path (workspace) | `/workspace/lcos-iso/lcos-live-06-03.iso` |
| SHA256 | `2f9823dded0f2769dcfef2ca0cb9141c92b8037d91167a821f45d4c1635459d5` |
| Recipe | `/workspace/lcos-live-06/` |
| Suite | Devuan Excalibur |
| Identity | LCOS 0.6 |

## Apt overlay — pending editor sign / publish

Working unsigned staging:

- Staging: `/workspace/lcos-0.6-apt-staging/lcosrepo1/apt/`
- Recipe mirror: `/workspace/lcos-live-06/packaging/apt-repo/`
- Suite/component: `excalibur` / `main`
- Unsigned `dists/excalibur/Release` present
- **No** `InRelease`, **no** `Release.gpg` (editor signs fresh)
- Pre-ship backup: `packaging/apt-repo-pre-0.6-ship-backup/`
- Seed: `config/packages.chroot/` (authoritative 0.6 ship set)
- Optional: `lunduke-edit` **0.3.2-1**; LLK trio **7.2.6-lcos4**
- **Not** included: `linux-libc-dev`; `lcos-themes` / `lcos-icon-theme`

Signing instructions + full package table + SHA256s:

`/workspace/lcos-0.6-apt-staging/README-SIGN.md`

Public overlay remains the previous signed tree until the editor signs and Chloe/Ted publish to `BryanLunduke/lcosrepo1` → `https://lcos.lunduke.com/apt`.

**Do not** upload the unsigned `Release` as the public overlay. **Do not** push until signed.

## Package count

**30** debs in the 0.6 unsigned pool (26 from packages.chroot + Edit + LLK trio).
