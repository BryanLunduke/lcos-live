# LCOS 0.5 — Official release facts

**Date note:** staging recorded 2026-09-14 (America/Chicago).

## Official ISO

| Field | Value |
|-------|-------|
| Filename | `lcos-live-05-05.iso` |
| Path (workspace) | `/workspace/lcos-iso/lcos-live-05-05.iso` |
| SHA256 | `bdfaa75d81c744262757860e63ef5091079de2815c61932dccb3957442f5750c` |
| Recipe | `/workspace/lcos-live-05/` |
| Suite | Devuan Excalibur |
| Identity | LCOS 0.5 |

Prior official: **0.4** = `lcos-live-04-04.iso` (SHA256 `3e97c74770a4c3ea321cbcc272302ecea49cac1b5077a062bab34cd1df227c70`). Frozen recipe: `/workspace/lcos-live-04/`.

## Bake policy after 0.5

- Recipe tree is **frozen** for official 0.5 unless a hotfix is approved.
- Next bake filename for post-release hotfixes: **`lcos-live-05-06.iso`**.
- Do not overwrite published ISO names.

## Apt overlay — pending editor sign / publish

Working unsigned staging:

- Path: `/workspace/lcos-live-05/packaging/apt-repo/`
- Suite/component: `excalibur` / `main`
- Unsigned `dists/excalibur/Release` present
- **No** `InRelease`, **no** `Release.gpg` in the working tree (editor signs fresh)
- Prior 0.4 working tree (with signatures) preserved at `packaging/apt-repo-pre-0.5-backup/`
- Seed: `config/packages.chroot/` (authoritative 0.5 ship set)
- **Not** included: `lcos-themes`, `lcos-icon-theme` (removed in 0.5)
- Paint: **lunduke-paint 0.5-12** only (no older 0.5-1…0.5-11 in pool)

Public overlay remains the previous signed tree until the editor:

1. Signs `InRelease` / `Release.gpg` (see `/workspace/lcos-0.5-apt-staging-README.md`)
2. Publishes to `https://lcos.lunduke.com/apt` (repo `BryanLunduke/lcosrepo1`)

Do **not** upload the unsigned `Release` as the public overlay.

## Package count

**26** debs in the 0.5 unsigned pool (see staging README for versions + SHA256).
