# #123: LUKS encrypted install, installer side (0.9.2 recipe)

2026-10-09 CT. Recipe-only change; no package changed. Kernel side: LLK lcos18 (DM_CRYPT).

## Already present
- `config/package-lists/installer.list.chroot`: cryptsetup and cryptsetup-initramfs
  (#80). The 091-01 image already had cryptsetup, cryptsetup-bin and
  cryptsetup-initramfs 2:2.7.5-2, dmsetup 2:1.02.205-2, libcryptsetup12,
  initramfs-tools 0.148.4, busybox and keyutils. lvm2 isn't needed because
  Calamares uses plain LUKS partitions.
- `packages.conf`: try_install cryptsetup and cryptsetup-initramfs. try_remove covers
  live-boot, live-config, live-config-sysvinit, calamares and
  calamares-settings-debian only, so cryptsetup is never removed.
- `partition.conf`: `luksGeneration: luks1` (GRUB 2.12 cryptodisk can't do LUKS2 argon2).
- grubcfg (Calamares 3.3.14): writes `GRUB_ENABLE_CRYPTODISK=y` when `/` is LUKS
  and there is no unencrypted `/boot`. It also adds `cryptdevice=`/`root=/dev/mapper/...`
  kernel parameters; initramfs-tools ignores `cryptdevice` and uses crypttab.

## Added
- `settings.conf` exec order: ... machineid, **luksbootkeyfile**, fstab, ...,
  packages, shellprocess, **initramfscfg**, **initramfs**, grubcfg, bootloader, umount.
  - luksbootkeyfile must run BEFORE fstab, as in Calamares' upstream default
    sequence. fstab only writes `/crypto_keyfile.bin` into crypttab if the file
    already exists in the target.
  - initramfs runs after packages (live-boot/live-config removal) and after
    shellprocess (conf-hook below).
- `modules/initramfs.conf`: kernel "all", be_unsafe false. The module writes
  `UMASK=0077` to /etc/initramfs-tools/conf.d/calamares-safe-initramfs.conf, then runs
  `update-initramfs -k all -c -t`.
- shellprocess step (#123), active only when `/crypto_keyfile.bin` exists and
  crypttab references it: writes `CRYPTSETUP=y` and `KEYFILE_PATTERN=/crypto_keyfile.bin`
  to /etc/cryptsetup-initramfs/conf-hook and `UMASK=0077`, and chmods the keyfile
  to 600. No Calamares module writes the Debian KEYFILE_PATTERN; without it,
  cryptsetup-initramfs won't embed the key and you'd be asked for the passphrase twice.
- initramfscfg (3.3.14) copies `encrypt_hook` (keyfile + crypttab into the initrd)
  only when `/` is LUKS.

## Unencrypted path
luksbootkeyfile: "Nothing to do for LUKS" (returns ok). fstab: crypttab has the header
only. initramfscfg: no hook copied. The shellprocess #123 step does nothing (no keyfile).
initramfs: a normal rebuild of the 7.2.6-lunduke initrd plus a harmless UMASK file.
grubcfg: no CRYPTODISK.
