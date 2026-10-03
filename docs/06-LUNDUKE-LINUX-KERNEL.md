# Lunduke's Linux Kernel (optional overlay)

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
