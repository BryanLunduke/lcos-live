# LCOS 0.7 — Official release staging facts

**Date:** 2026-09-28 (America/Chicago / CDT)

## Official ISO

| Field | Value |
|-------|-------|
| Filename | `lcos-live-07-08.iso` |
| Path (workspace) | `/workspace/lcos-iso/lcos-live-07-08.iso` |
| SHA256 | `c27376f042e3b3153899636b3ffc0eaa9cf44dbe31c8cf56393e78d0a0816cde` |
| Recipe | `/workspace/lcos-live-07/` |
| Suite | Devuan Excalibur |
| Identity | LCOS 0.7 |

## Apt overlay — pending editor sign / publish

Working unsigned staging:

- Staging: `/workspace/lcos-0.7-apt-staging/lcosrepo1/apt/`
- Recipe mirror: `/workspace/lcos-live-07/packaging/apt-repo/`
- Suite/component: `excalibur` / `main`
- Unsigned `dists/excalibur/Release` present
- **No** `InRelease`, **no** `Release.gpg` (editor signs fresh)
- Pre-ship backup: `packaging/apt-repo-pre-0.7-ship-backup/`
- Seed: `config/packages.chroot/` (authoritative 0.7 ship set)
- **Not** included: `linux-libc-dev`; `micropolis` / `micropolis-data`

Signing instructions + full package table + SHA256s:

`/workspace/lcos-0.7-apt-staging/README-SIGN.md`

Public overlay remains the previous signed tree until the editor signs and Chloe/Ted publish to `BryanLunduke/lcosrepo1` → `https://lcos.lunduke.com/apt`.

**Do not** upload the unsigned `Release` as the public overlay. **Do not** push until signed. **Do not** use `lcos-0.8-apt-staging` for 0.7 publish.

## Package count

**30** debs in the 0.7 unsigned pool (all from packages.chroot).
