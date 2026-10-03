# LLK bake notes (LCOS 0.8)

Recipe-local wiring so Lunduke Linux Kernel is the default ISO kernel.
**Do not publish apt.**

## Seed when Ted gives paths

Copy into `config/packages.chroot/`:

- `linux-image-7.2.6-lunduke` (7.2.6-lcos8)
- `linux-headers-7.2.6-lunduke` (7.2.6-lcos8)
- metapackage only if Ted provides a stable seed name (e.g. `lunduke-linux-kernel`)

Do **not** seed lcos5/lcos6 (or older) LLK debs.

## live-build already set

- `auto/config` / `config/chroot`: `--linux-packages none` / `LB_LINUX_PACKAGES="none"`
- Package list: `config/package-lists/kernel-lunduke.list.chroot`
- Initramfs hook: `config/hooks/live/0095-lunduke-initramfs.hook.chroot` (`KVER=7.2.6-lunduke`)

## KernelTest lesson — override `binary_linux-image`

Stock `/usr/lib/live/build/binary_linux-image` **exits early** when
`LB_LINUX_PACKAGES=none`, so `chroot/boot/vmlinuz-*` and `initrd.img-*` never
land in `binary/live`. Before `lb build`, either:

1. Symlink/copy this helper over the live-build script in the `/tmp` bake tree, **or**
2. Set `LIVE_BUILD` so `scripts/build/binary_linux-image` resolves to
   `helpers/binary_linux-image` from this recipe

(Helper path: `helpers/binary_linux-image` — same as stock minus the early exit.)

## Hold

- lcos8 seeded for lcos-live-07-03; do not bake from this note alone
- No apt / InRelease publish from this wiring step

## BOOTIA32 / 32-bit EFI (GitHub #90)

Stock `binary_grub-efi` only emits `bootia32.efi` on amd64 when signed GRUB
exists. LCOS ships unsigned EFI, so prior ISOs were bootx64-only.

Recipe-local fix: `helpers/binary_grub-efi` and
`local/live-build/scripts/build/binary_grub-efi` always generate i386-efi when
`/usr/lib/grub/i386-efi/configfile.mod` is present (`grub-efi-ia32-bin` is in
`installer.list.chroot`).

Before `lb build`, same pattern as `binary_linux-image`:

1. Copy/symlink `helpers/binary_grub-efi` over `/usr/lib/live/build/binary_grub-efi`, **or**
2. `export LIVE_BUILD=/workspace/lcos-live-08/local/live-build`

Verify after bake prep / on ISO: `EFI/BOOT/BOOTIA32.EFI` or `EFI/boot/bootia32.efi`,
plus `boot/grub/i386-efi/`.

