# LCOS 0.9.3 track opened (2026-10-11 CT)

Version bump plus two carried fixes (#129 pin, firmware metapackages). No other feature work in this open.

## Working tree
Same precedent as 0.9.2: a new clone `/workspace/lcos-live-093` tracks `master`
(0.9.3), and `/workspace/lcos-live-092` now tracks branch `lcos-0.9.2` (frozen,
hotfixes only), as `/workspace/lcos-live-091` tracks `lcos-0.9.1`.

## 0.9.2 freeze
- Official LCOS 0.9.2 ISO: `lcos-live-092-02` (SHA256
  d0f9fe485b9c2afdaeb1762f9983a19697ffa6a4c7de27a3775dd1257b3228ff).
- Tag `lcos-0.9.2-release` = branch `lcos-0.9.2` = `b68d9fe6`.
- Package tags `<pkg>/0.9.2-1` and `lcos-base/0.9.2-5` at `b68d9fe6`.
- Signed apt overlay live at lcosrepo1 `0bd3bfbc` (0.9.2 + i386 Mesa for #129).
- master after the release, before this open: 0.9.3-only commit `e549152` (#129 pin).

## Identity
`auto/config` iso-volume `LCOS 0.9.3`, image-name `lcos-live-093-01`;
os-release, issue, issue.net, Calamares branding, hooks 0095 and 8900,
lcos-write-os-release, lcos-base 0.9.3-1 payload.

## Package lists
- `firmware-linux` and `firmware-linux-nonfree` added to hardware.list.chroot
  (0.9.1 had them; 092-02 lost them). Pinned to excalibur-backports with the AMD firmware.

## Kernel and apps
- LLK 7.2.6-lcos19 unchanged.
- App debs stay at the 0.9.2 set until Phil seeds 0.9.3:
  `config/packages.chroot/WAITING_ON_PHIL-0.9.3-apps.txt`.

## System packages 0.9.3-1
Built with `packaging/build-093-system-debs.sh`; all eight at 0.9.3-1. Unsigned, not tagged.
- lcos-base 0.9.3-1: identity 0.9.3; Depends unchanged from 0.9.2-5; now ships
  `/etc/apt/preferences.d/lcos-amd-backports.pref` (i386 Mesa at 990, #129;
  see docs/093-129-i386-mesa-pin.md), not a conffile. Tested with dpkg
  --unpack over an unowned old copy: replaced.
- Others: Version, changelog, 0.9.2 -> 0.9.3 in Description/copyright only.
See `config/packages.chroot/SEED-system-0.9.3-1.txt`.

## Rules for this open
No bake and no apt publish until Ted or the editor say go.
