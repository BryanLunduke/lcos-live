# LCOS 0.9.2 track opened (2026-10-09 CT)

Version bump only. No feature or fix work in this open.

## 0.9.1 freeze
- Official LCOS 0.9.1 ISO: `lcos-live-091-01` (SHA256
  057515660e4bda2fee88a734a04f67c0af4be978efbf5f2f2cfa06c876416145,
  1443938304 bytes). Signed apt overlay live at lcosrepo1 0886afb9.
- Tag `lcos-0.9.1-release` = `403714f2` (the commit 091-01 was baked from),
  unchanged.
- Branch `lcos-0.9.1` = `218c2c0d`: release plus lcos-base 0.9.1-3
  (eject/cifs-utils/keyutils moved to Recommends; that is the overlay's lcos-base).
  0.9.1 hotfixes land on `lcos-0.9.1`; `/workspace/lcos-live-091` tracks it.
- Package tags already existed (annotated): `<pkg>/0.9.1-1` for the seven
  non-base debs and `lcos-base/0.9.1-2` at `403714f2`; `lcos-base/0.9.1-3`
  at `218c2c0d`. None were created in this open.

## Identity
`auto/config` iso-volume `LCOS 0.9.2`, image-name `lcos-live-092-01`;
os-release (`VERSION_ID="0.9.2"`, `VERSION="0.9.2 (excalibur)"`), issue,
issue.net, Calamares branding (`version`/`shortVersion` 0.9.2), hooks 0095
and 8900, lcos-write-os-release, lcos-base 0.9.2-1 payload.

## Kernel and apps
- LLK 7.2.6-lcos17 unchanged.
- App debs stay at 0.9.1-1 until Phil seeds 0.9.2:
  `config/packages.chroot/WAITING_ON_PHIL-0.9.2-apps.txt`.

## System packages 0.9.2-1
Built with `packaging/build-092-system-debs.sh` (copied from the 0.9.1 script;
all eight packages at 0.9.2-1). Unsigned and not tagged. Changes: Version,
changelog, 0.9.1 -> 0.9.2 in identity files, Description and copyright
`Source:` lines. lcos-base keeps `Recommends: eject, cifs-utils, keyutils`
(as 0.9.1-3), and its AMD Xorg DDX selection (#115/#118) is byte-identical.
lintian tags are unchanged from the 0.9.1 debs. Archive key unchanged.
See `config/packages.chroot/SEED-system-0.9.2-1.txt`.

## Rules for this open
No bake and no apt publish until Ted or the editor say go.
