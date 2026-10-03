# LCOS 0.6 — Official release facts

**Locked:** 2026-09-23 (America/Chicago)

## Official ISO

| Field | Value |
|-------|-------|
| Filename | `lcos-live-06-03.iso` |
| Path (workspace) | `/workspace/lcos-iso/lcos-live-06-03.iso` |
| SHA256 | `2f9823dded0f2769dcfef2ca0cb9141c92b8037d91167a821f45d4c1635459d5` |
| Size | 1498152960 bytes |
| Testing tag | https://github.com/BryanLunduke/lcos-testing/releases/tag/lcos-live-06-03 |
| Recipe | `/workspace/lcos-live-06/` (frozen for hotfixes only) |
| Suite | Devuan Excalibur |
| Default kernel | Devuan/Debian `linux-image-6.12.x` (not Lunduke kernel) |

Prior official: **0.5** = `lcos-live-05-05.iso`.

## Bake policy after 0.6

- Recipe tree is **frozen** for official 0.6 unless a hotfix is approved.
- Next bake filename for post-release hotfixes: **`lcos-live-06-04.iso`**.
- Do not overwrite published ISO names.

## Apt overlay (signed, live)

- URL: https://lcos.lunduke.com/apt
- Repo: `BryanLunduke/lcosrepo1` master
- Publish commit: `63c9df70e945ac14c4dce94b53b65352a9c472cd`
- Suite/component: `excalibur` / `main`
- Signed: `InRelease` + `Release.gpg` (LCOS Archive Signing Key `5A01 D4BD CDD1 E153 1D45 6A75 60D6 E7F6 CBD6 D572`)

### Overlay package highlights

| Package | Version |
|---------|---------|
| lcos-archive-keyring | 0.6-2 |
| lcos-base / branding / desktop / desktop-config / theme-clearlooks / zork / appimage-thumbnailer | 0.6-1 |
| lcos-updates | 0.6-2 |
| lunduke-paint | 0.6-1 |
| lunduke-edit (optional) | 0.3.2-1 |
| lunduke-linux-kernel + linux-image/headers-7.2.6-lunduke (optional) | 7.2.6-lcos4 |
| XLibre stack | 25.1.9-1+lcos1 (drivers as shipped) |

## Notes

- Encrypt/LUKS + Plymouth greeter handoff + curl seeded in 06-03 ISO.
- AMD + XLibre GL limitations remain documented (not a ship blocker).
