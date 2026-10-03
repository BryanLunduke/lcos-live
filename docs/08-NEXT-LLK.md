# LCOS 0.8 — next LLK checklist (beyond 7.2.6-lcos8)

**Status:** Ted building **7.2.6-lcos9** on shared box → `/workspace/lcos-kernel/debs-lcos9/`.  
Chloe does **not** build kernel debs. Seed into `config/packages.chroot/` + `kernel-lunduke.list.chroot` when debs appear (same pattern as lcos8).  
**Do not invent debs. No apt publish from this note.**

## Config changes for lcos9+ (Editor / Ted)

Keep **EARLY_PRINTK**. Fail-safe GRUB entry stays loud (`nosplash` / verbose path unchanged).

| Item | Setting | Why |
|---|---|---|
| Quieter early boot | `CONFIG_X86_VERBOSE_BOOTUP=n` | Less console spam before Plymouth; keep `EARLY_PRINTK` |
| VMware / virt SCSI | `CONFIG_SCSI_BUSLOGIC=y` (or `m`) | Common hypervisor disks |
| | `CONFIG_FUSION=y` (or `m`) + Fusion MPT family as needed | |
| | `CONFIG_VMWARE_PVSCSI=y` (or `m`) | VMware PV SCSI |
| Vintage Mac AirPort (b43) | `CONFIG_B43=m` (preferred) | MacBook4,1 SoftMAC; firmware already on ISO via `firmware-b43-installer` |
| | Enable **SSB** / **BCMA** (and PHY options `make oldconfig` asks for) | Required deps for b43 |
| | `CONFIG_B43LEGACY=m` if cheap | Very old BCM4301/4306 |
| Avoid | `broadcom-sta` / `wl` DKMS | No plain `non-free`; firmware+b43 path only |

## Root cause note (GitHub #90 Wi-Fi)

ISO already has `firmware-b43-installer` (blobs extracted), `firmware-brcm80211`, `bluez-firmware`.  
**LLK 7.2.6-lcos8** had `CONFIG_B43` / `CONFIG_B43LEGACY` **unset** and SSB/BCMA off — driver missing, not firmware missing.

## Seed steps (when debs-lcos9 appears)

1. Copy `linux-image-7.2.6-lunduke_*lcos9*.deb`, `linux-headers-7.2.6-lunduke_*lcos9*.deb`, and `lunduke-linux-kernel_*lcos9*.deb` (if present) into `config/packages.chroot/`.
2. Remove prior `*lcos8*` LLK debs from `packages.chroot/`.
3. Keep package **names** in `kernel-lunduke.list.chroot` (`linux-image-7.2.6-lunduke` etc.) unless ABI/version string changes.
4. Update `hooks/live/0095-lunduke-initramfs.hook.chroot` `KVER=` if needed.
5. Write `SEED-llk-7.2.6-lcos9.txt` with SHA256s; retire lcos8 seed note.

## Verify after bake

- `modinfo b43` works on live ISO.
- MacBook4,1: AirPort sees firmware under `/lib/firmware/b43/`.
- Fail-safe GRUB still verbose; normal boot quieter / Plymouth path intact.
