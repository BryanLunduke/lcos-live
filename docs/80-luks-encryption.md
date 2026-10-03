# GitHub #80 — LUKS encryption via Calamares

## Problem
Calamares offered “Encrypt system” (`luksGeneration: luks1`) but:
1. `cryptsetup` / `cryptsetup-initramfs` were not on the live ISO (partition create failed).
2. The installed system also lacked those packages (unlock at boot broken).
3. `grubcfg` was not in the exec sequence, so `GRUB_ENABLE_CRYPTODISK=y` was never set (grub-install failed).

## Fix (seeded for lcos-live-06-03)
- `config/package-lists/installer.list.chroot`: add `cryptsetup`, `cryptsetup-initramfs`
- `etc/calamares/modules/packages.conf`: `try_install` those on the target
- `etc/calamares/settings.conf`: run `grubcfg` before `bootloader`
- `etc/calamares/modules/grubcfg.conf`: new (sets CRYPTODISK when root is LUKS)

## Smoke test
1. Boot live ISO, run installer, check **Encrypt system**, set passphrase.
2. Complete install; reboot.
3. Enter passphrase at unlock prompt; reach desktop.
4. Confirm `cryptsetup` and `cryptsetup-initramfs` are installed; `grep CRYPTODISK /etc/default/grub` shows `y`.
