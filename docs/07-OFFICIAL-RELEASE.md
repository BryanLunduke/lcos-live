# LCOS 0.7 — Official release facts

**Locked:** 2026-09-28 (America/Chicago)

## Official / last test ISO

| Field | Value |
|-------|-------|
| Filename | `lcos-live-07-08.iso` |
| Path (workspace) | `/workspace/lcos-iso/lcos-live-07-08.iso` |
| SHA256 | `c27376f042e3b3153899636b3ffc0eaa9cf44dbe31c8cf56393e78d0a0816cde` |
| Size | 1409286144 bytes |
| Testing tag | https://github.com/BryanLunduke/lcos-testing/releases/tag/lcos-live-07-08 |
| Recipe | `/workspace/lcos-live-07/` (frozen for hotfixes only) |
| Suite | Devuan Excalibur |
| Identity | LCOS 0.7 |
| Default kernel | Lunduke Linux Kernel 7.2.6-lcos8 |

Prior official: **0.6** = `lcos-live-06-03.iso`.

## Bake policy after 0.7

- Recipe tree is **frozen** for official 0.7 unless a hotfix is approved.
- Next bake filename for post-release hotfixes: **`lcos-live-07-09.iso`**.
- Do not overwrite published ISO names.
- Do not bake another 0.7 ISO except as an approved hotfix.

## Apt overlay (signed, live)

- URL: https://lcos.lunduke.com/apt
- Repo: `BryanLunduke/lcosrepo1` master
- Publish commit: `53439b797a883590fbea76bf5cb28260d988afa3`
- Suite/component: `excalibur` / `main`
- Signed: `InRelease` + `Release.gpg` (LCOS Archive Signing Key)

### Overlay package highlights (ship set)

| Package | Version |
|---------|---------|
| lcos-archive-keyring | 0.7-1 |
| lcos-base | 0.7-2 |
| lcos-branding / desktop / theme-clearlooks / zork / appimage-thumbnailer | 0.7-1 |
| lcos-desktop-config | 0.7-7 |
| lcos-updates | 0.7-1 |
| lunduke-paint | 0.7-1 |
| lunduke-edit | 0.7-5 |
| lunduke-about | 0.7-1 |
| lunduke-city | 0.7-4 |
| lunduke-linux-kernel + linux-image/headers-7.2.6-lunduke | 7.2.6-lcos8 |

Micropolis removed from overlay (City replaces it on ISO).

## Notes

- Last official/test bake on this tree: **lcos-live-07-08**.
- Staging facts retained in `docs/07-OFFICIAL-RELEASE-STAGING.md`.
- Active development continues on `/workspace/lcos-live-08/` (0.8 track).
