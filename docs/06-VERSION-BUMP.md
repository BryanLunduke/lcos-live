# LCOS 0.6 — version bump / track open

**Date:** 2026-09-15 (America/Chicago)

## What happened

- Branched `/workspace/lcos-live-05` → `/workspace/lcos-live-06` (rsync; no cache/chroot/ISO).
- Left `/workspace/lcos-live-05` frozen (official 0.5).
- Identity bumped **0.5 → 0.6** (os-release, issue, hook 8900, Calamares version/shortVersion, lcos-write-os-release, lcos-base postinst kept).
- Overlay packages rebuilt at **0.6-1** from `packaging/src` (not a full wipe via `build-overlay-debs.sh` branding path — that script still lacks Plymouth copies; use src rebuild until extended).

## Rebuilt 0.6-1 debs (seed + packaging/debs)

- lcos-base
- lcos-archive-keyring
- lcos-branding (includes Plymouth + LightDM helper)
- lcos-desktop
- lcos-desktop-config
- lcos-theme-clearlooks
- lcos-appimage-thumbnailer
- lcos-zork

## WAITING_ON_PHIL

Do **not** fake 0.6 binaries:

| Package | Seed now | packaging/src control | Action |
|---------|----------|----------------------|--------|
| lunduke-paint | **0.5-12** (kept) | bumped to 0.6-1 placeholder | Phil must supply `lunduke-paint_0.6-1_amd64.deb` |
| lcos-updates | **0.5-1** (kept) | bumped to 0.6-1 placeholder | Phil must supply `lcos-updates_0.6-1_amd64.deb` |

See also `config/packages.chroot/WAITING_ON_PHIL-paint-updates.txt`.

## Not bumped

- xlibre* / micropolis* (unchanged)

## Lessons kept from 0.5

- lcos-base postinst → `lcos-write-os-release`
- os-release / issue / issue.net **not** conffiles (only `grub.d/lcos.cfg`)
- `lcos-overlay.list` **not** a conffile; comments version-neutral (keyring **0.6-2**)
- no lcos-themes / lcos-icon-theme
- sudo in Calamares users.conf defaultGroups
- Plymouth force-confold before packages
- Updates upgrade policy


## 0.6-2 — lcos-archive-keyring overlay.list conffile fix (2026-09-15 CT)

Seen on **0.4→0.5**: `/etc/apt/sources.list.d/lcos-overlay.list` was a **conffile**, and
the only change was the first comment line (`LCOS 0.4` → `LCOS 0.5`). Noninteractive
Upgrades kept the old file / prompted interactively.

Fix (same lesson as os-release / issue):

- Comments in `lcos-overlay.list` are **version-neutral** (`LCOS thin signed overlay` — no `0.6` / `0.5`).
- File is **not** listed in `DEBIAN/conffiles` (shipped as a normal package file).
- Local hand-edits may be overwritten on upgrade; users who need extras should add another `.list`.
- `build-overlay-debs.sh` `finish_pkg` now excludes `lcos-overlay.list` alongside os-release/issue.
- Package bumped to **lcos-archive-keyring 0.6-2**; seeded in `packaging/debs` + `config/packages.chroot` (0.6-1 seed removed). Apt **not** published.

## Next bake

`lcos-live-06-01.iso` — Chloe owns bake; do not bake until Ted says go. Do not push apt to lcosrepo1 until editor signs.

## Apt staging

Unsigned restage under `packaging/apt-repo/` for rebuilt 0.6-1 overlay pkgs + still-seeded paint/updates 0.5 + xlibre/micropolis. No publish.

## Related

- Known limitations (AMD GL): [`06-KNOWN-LIMITATIONS.md`](06-KNOWN-LIMITATIONS.md)

## Seed adds (2026-09-19)

- **gvfs**, **udisks2**, **thunar-volman** — removable media / trash in Thunar (~15 MiB installed). No **gvfs-backends**.
- **iputils-ping** — `ping` CLI.

## Seed adds (2026-09-19 evening)

- **xdg-user-dirs** — create/register Desktop, Documents, Downloads, etc. for Thunar (Thunar Recommends; was missing because Recommends are not installed).

## 0.6-02 → next bake 0.6-03 (2026-09-20 CT)

- **Last official non-KernelTest bake on disk:** `lcos-live-06-02.iso`
  (SHA256 `97ee5f65093634631c6ebc0f41842a4d3eee44c57f756c6398a8d297268b50ef`).
- **Next bake filename:** `lcos-live-06-03.iso` (Chloe/Ted; do not bake from this doc alone).
- **Default kernel unchanged:** Devuan `linux-image` via live-build. Do **not**
  pull `lunduke-linux-kernel` / `linux-image-7.2.6-lunduke` into main ISO seed.
- **Optional LLK:** packaged for apt overlay as `lunduke-linux-kernel`
  (see [`06-LUNDUKE-LINUX-KERNEL.md`](06-LUNDUKE-LINUX-KERNEL.md)). Staging
  unsigned pending editor InRelease; see `/workspace/lcos-llk-apt-staging/`.
