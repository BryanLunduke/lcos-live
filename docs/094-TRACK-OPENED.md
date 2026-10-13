# LCOS 0.9.4 track opened (2026-10-13 CT)

Version bump only. No feature work in this open.

## Working tree
`/workspace/lcos-live-094` tracks `master` (0.9.4); `/workspace/lcos-live-093` now tracks
branch `lcos-0.9.3` (frozen, hotfixes only).

## 0.9.3 freeze
- Official LCOS 0.9.3 ISO: `lcos-live-093-04` (1481506816 bytes, SHA256
  4eaa50e6d40b2aed1d18f7cb80c386828f0d24b8bcf152adb023acac485c0350).
- Tag `lcos-0.9.3-release` = branch `lcos-0.9.3` = `79c8c52b`.
- Package tags `<pkg>/0.9.3-1`, `lcos-desktop-config/0.9.3-2`, `lcos-base/0.9.3-3` at `79c8c52b`.
- Signed apt overlay live at lcosrepo1 `99b49ebd` (Release SHA256 44b2aaa4).

## Identity
`auto/config` iso-volume `LCOS 0.9.4`, image-name `lcos-live-094-01`; os-release, issue,
issue.net, Calamares branding, hooks 0095 and 8900, lcos-write-os-release, lcos-base payload.

## Kernel and apps
- LLK 7.2.6-lcos20 unchanged.
- Apps stay at the 0.9.3 set (Edit/Paint/City/About 0.9.3-1, Updates 0.9.3-2) until Phil seeds 0.9.4-1.

## System packages 0.9.4-1
Built with `packaging/build-094-system-debs.sh --seed`; all eight at 0.9.4-1. Unsigned, not tagged.
lcos-base Depends and apt pin unchanged from 0.9.3-3. See `config/packages.chroot/SEED-system-0.9.4-1.txt`.

## Cleanup
Removed stale `SEED-lcos-updates-0.9.2-2.txt` and resolved `WAITING_ON_PHIL-0.9.3-apps.txt`.

## Rules for this open
No bake and no apt publish until Ted or the editor say go.
