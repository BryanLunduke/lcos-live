# LCOS 0.9.1 track opened (2026-10-09 CT)

0.9.1 is a **testing and bug-fix-only** release (editor 2026-10-09).

Repo layout: `BryanLunduke/lcos-live` is ONE recipe tree tracked over time.
`master` now carries 0.9.1. Working tree: `/workspace/lcos-live-091` (git clone).

## 0.9 freeze
- Official LCOS 0.9 ISO: `lcos-live-09-04` (SHA256
  31125e5b972aeff61af2d9e3758248b3983e843c1f0a77df84fb5c64176db346,
  1443938304 bytes). Signed apt overlay live at lcosrepo1 fb6ef727.
- Tag `lcos-0.9-release` = `05d9f726` (the commit 09-04 was baked from).
- Branch `lcos-0.9` = `0b776c09`: the release commit plus one commit that put
  the HTTPS build-time FAU mirrors into `auto/config` (09-04 was built with
  those values passed by hand). 0.9 hotfixes land on `lcos-0.9`;
  `/workspace/lcos-live-09` tracks it.
- Package tags at `05d9f726` for the lcos-live-sourced debs that shipped in
  09-04: `lcos-base/0.9-1`, `lcos-branding/0.9-1`, `lcos-desktop-config/0.7-8`,
  `lcos-appimage-thumbnailer/0.7-1`, `lcos-archive-keyring/0.7-1`,
  `lcos-desktop/0.7-1`, `lcos-theme-clearlooks/0.7-1`, `lcos-zork/0.7-1`.
- Kernel tag `7.2.6-lcos17` on lunduke-linux-kernel = `c4059c6e`.

## Identity
`auto/config` iso-volume `LCOS 0.9.1`, image-name `lcos-live-091-01`;
os-release (`VERSION_ID="0.9.1"`, `VERSION="0.9.1 (excalibur)"`), issue,
Calamares branding (`version`/`shortVersion` 0.9.1), hooks 0095 and 8900,
lcos-base 0.9.1-1 package payload.

## Kernel and apps
- LLK 7.2.6-lcos17 seed unchanged (CONFIG_CIFS=m, 937 modules).
- App debs unchanged from 0.9 until Phil seeds 0.9.1:
  `config/packages.chroot/WAITING_ON_PHIL-0.9.1-apps.txt`.

## System packages 0.9.1-1
Built with `packaging/build-091-system-debs.sh` from `packaging/src/<pkg>`
(unsigned; editor signs the archive). Not tagged yet (0.9.1 not released).
- lcos-base 0.9.1-1: identity 0.9.1; `Depends: eject, cifs-utils, keyutils`
  so upgraded 0.8 and 0.9 systems pull them via apt upgrade (#104, #111).
  AMD modesetting xorg snippets and insserv overrides unchanged.
- lcos-branding 0.9.1-1: version/description text only.
- lcos-desktop-config 0.9.1-1 (was 0.7-8): version, changelog and stale text
  only; no XFCE changes (Bob owns look and feel).
- lcos-appimage-thumbnailer, lcos-archive-keyring, lcos-desktop,
  lcos-theme-clearlooks, lcos-zork 0.9.1-1 (were 0.7-1): version, changelog,
  stale copyright/Description text. Archive key unchanged (fingerprint
  5A01 D4BD CDD1 E153 1D45 6A75 60D6 E7F6 CBD6 D572).

## Rules for this open
No bake, no apt publish until Ted/editor say go.
