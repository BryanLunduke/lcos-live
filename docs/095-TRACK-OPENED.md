# LCOS 0.9.5 track opened (2026-10-16 CT)

Re-applied 2026-10-16 CT on top of the reset to 0.9.4 (see "Reset 0.9.5 track to 0.9.4 release");
the first 0.9.5 history is kept on branch `backup/095-pre-reset` (a9b46ab).

Version bump only. No feature work in this open.

## Working tree
`/workspace/lcos-live-095` tracks `master` (0.9.5); `/workspace/lcos-live-094` is frozen at 0.9.4
(branch `lcos-0.9.4`, hotfixes only).

## 0.9.4 freeze
- Official LCOS 0.9.4 ISO: `lcos-live-094-05` (1516290048 bytes, SHA256
  aa888839d5b3ad443b2dc10ebb46dc0d4fe8594d860f79e421ba6abea987d56d).
- Tag `lcos-0.9.4-release` = branch `lcos-0.9.4` = `0cc29fbf`.
- Package tags `<pkg>/0.9.4-1` and `lcos-base/0.9.4-7` at `0cc29fbf`.
- Signed apt overlay live at lcosrepo1 `efca16a6` (Release SHA256 447475ef).

## Identity
`auto/config` iso-volume `LCOS 0.9.5`, image-name `lcos-live-095-01`; os-release, issue,
issue.net, Calamares branding, hook 8900, lcos-write-os-release.
The 0095 initramfs hook differs from 0.9.4 only in its "0.9.5" comment and log text.
Not changed: the lcos-base payload (os-release files), which goes with the 0.9.5 system debs.

## Kernel and apps
- LLK 7.2.6-lcos25 unchanged.
- Apps stay at the 0.9.4 set (Edit 0.9.4-2, Paint 0.9.4-9, City 0.9.4-8, About 0.9.4-8, Updates 0.9.4-7).
- System debs stay at 0.9.4 (lcos-base 0.9.4-7, the other seven 0.9.4-1). No package versions bumped.

## Rules for this open
No bake and no apt publish until Ted or the editor say go.

## Re-applied after the reset (2026-10-16 CT)
- lcos-base 0.9.5-3: reboot-required dpkg file trigger (r15 U-1), #112 HOME=/ fix, identity 0.9.5.
  Same payload as 0.9.5-2; new version because 0.9.5-1 and 0.9.5-2 were already tagged.
- lcos-desktop-config 0.9.5-1 (#143 lid suspend), the tagged deb reused byte-for-byte.
- Apps re-seeded byte-for-byte: Updates 0.9.5-1, About 0.9.5-2, City 0.9.5-1, Paint 0.9.5-1.
- Kernel: LLK 7.2.6-lcos27 (PR #23, merge bb839085, tag 7.2.6-lcos27) replaced lcos25, same package names
  and kernel release 7.2.6-lunduke. The kernel package list is as in 0.9.4.
- Not re-applied: the per-build kernel naming experiment (kernel tag after lcos25) and its recipe changes.

## Package marks (review 1.0b U-1, 2026-10-18 CT)
- Calamares `packages` (try_remove) runs `apt-get --purge remove <pkg>` and then
  `apt-get --purge autoremove`, one package at a time. Removing `calamares` therefore
  autoremoved everything only it pulled in. That was the installer stack, plus `fdisk`,
  which was auto-marked because libkpmcore12 was its only reverse dependency.
  Every install since 0.9.2 has shipped without fdisk.
- Hook normal/0116-lcos-mark-manual marks these as manual:
  - all Priority required/important packages (15 were auto on 095-06, fdisk among them);
  - the direct Depends of xfce4 and network-manager-gnome (so removing a metapackage
    no longer makes Remove Unused offer xfce4-panel);
  - a short list of user tools.
- The hook fails the bake if:
  - the live image has anything autoremovable; or
  - simulating the installer's removal would purge anything outside an
    installer-stack allowlist (Calamares, Qt6/KF6, live-boot/config, kpmcore,
    libpython3.x, libpwquality, etc.).
- Simulated on 095-06:
  - Calamares sequence before: 89 purged incl. fdisk; after: 88, no fdisk.
  - Post-install autoremove: 0.
- Existing installs: not changed by this hook (see review report, proposal for lcos-base).

## Kernel lcos28 (2026-10-19 CT)
- LLK 7.2.6-lcos28 (PR #24, merge 0ee2c315, tag 7.2.6-lcos28) replaced lcos27: lcos27 plus
  `CONFIG_KEYBOARD_APPLESPI=m` (applespi, ACPI APP000D), the internal SPI keyboard and trackpad of the
  12-inch Retina MacBook (2015, MacBook8,1). Same package names and kernel release 7.2.6-lunduke.
- The image deb differs from lcos27 only by applespi.ko. initramfs-tools MODULES=most includes it,
  so the keyboard is also there at the encrypted-disk passphrase prompt.
- Checked without an ISO build: lcos28 kernel boots the 095-07 live system in QEMU (with the 095-07 initrd
  and with an lcos28 initrd); apt upgrade lcos27 to lcos28 in a 095-07 chroot upgrades the three packages
  in place, removes nothing. Not tested on MacBook hardware.
