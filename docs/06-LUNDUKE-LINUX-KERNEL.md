# Lunduke's Linux Kernel

## Current (LCOS 1.1, updated 2026-11-27 America/Chicago)

Lunduke's Linux Kernel (LLK) is the default and only ISO kernel (since LCOS 0.7).

| Item | Value |
|------|-------|
| Version | `7.3.6-lcos34` (Linux 7.3.6) |
| Kernel release | `7.3.6-lunduke` |
| Source | `BryanLunduke/lunduke-linux-kernel` master `7ddc16ae` (PR #31) |
| Seeded debs | `linux-image-7.3.6-lunduke`, `linux-headers-7.3.6-lunduke`, `lunduke-linux-kernel` (all `7.3.6-lcos34`) |
| Seed note | `config/packages.chroot/SEED-llk-7.3.6-lcos34.txt` |
| Package list | `config/package-lists/kernel-lunduke.list.chroot` |
| Initramfs hook | `config/hooks/live/0095-lunduke-initramfs.hook.chroot` (`KVER="7.3.6-lunduke"`) |
| Bake helper | `helpers/binary_linux-image` (see `helpers/README-LLK-BAKE.md`) |

When the kernel release changes, keep the package list, the hook `KVER` and the seeded debs in step.
LCOS 1.0.x ships `7.2.15-lcos33` (`7.2.15-lunduke`), frozen on branch `lcos-1.0.1`.
On upgraded systems the 7.3.6-lunduke kernel installs beside the older ones, which stay as GRUB fallbacks.

## History (2026-09-20, LCOS 0.6 era)

The notes below describe LLK as an optional overlay before it became the ISO default. Kept for history.

**Date:** 2026-09-20 (America/Chicago)

Optional alternate kernel for end users on LCOS. **Not** the default in official
ISOs (0.5 / 0.6). Official images keep the **Devuan-supplied** `linux-image`
from live-build (`LB_LINUX_PACKAGES="linux-image"`).

## Install (after apt overlay publish)

On any LCOS system with the signed overlay (`https://lcos.lunduke.com/apt`):

```bash
sudo apt update
sudo apt install lunduke-linux-kernel
```

Then reboot and choose the **7.2.6-lunduke** GRUB entry. The Devuan kernel
stays installed; LLK adds a boot entry alongside it.

### Package names

| Package | Role |
|---------|------|
| `lunduke-linux-kernel` | User-facing metapackage (**Lunduke's Linux Kernel**) |
| `linux-image-7.2.6-lunduke` | Concrete image (ABI **lcos4**, version `7.2.6-lcos4`) |
| `linux-headers-7.2.6-lunduke` | Headers (Recommends of the metapackage) |

## Policy

- Main recipe `/workspace/lcos-live-06/` must **not** seed LLK into
  `packages.chroot` or `package-lists` as default.
- KernelTest trees (`lcos-live-06-KernelTest*`) remain separate experiments.
- First published ABI: **lcos4** (KernelTest4).

## Staging / publish

Unsigned staging ready for editor sign:

- `/workspace/lcos-llk-apt-staging/` (see `README-SIGNING-BLOCKER.md`)
- Tarball: `/workspace/lcos-llk-apt-staging/lcos-llk-apt-UNSIGNED.tar.gz`

Publish target: `BryanLunduke/lcosrepo1` → `https://lcos.lunduke.com/apt`
(branch **master**).
