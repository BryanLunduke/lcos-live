# LCOS 0.7 — track opened

**Date:** 2026-09-23 (America/Chicago)

## What happened

- Branched `/workspace/lcos-live-06` → `/workspace/lcos-live-07` (rsync; no cache/chroot/ISO/build products).
- Left `/workspace/lcos-live-06` frozen (official 0.6 / `lcos-live-06-03.iso`).
- Left `/workspace/lcos-0.6-apt-staging` and `/workspace/lcos-iso/` untouched.
- Identity bumped **0.6 → 0.7** (os-release, issue, issue.net, hook 8900, Calamares version/shortVersion, lcos-write-os-release in includes + lcos-base).
- Overlay packages rebuilt at **0.7-1** from `packaging/src` via `dpkg-deb` (same approach as 0.6 track open; do not rely on full wipe path in `build-overlay-debs.sh` for branding/Plymouth).
- `build-overlay-debs.sh` ROOT/VER/KEYRING_VER pointed at 0.7 for future rebuilds.
- **No ISO baked. No GitHub push. No apt publish/sign.**

## Rebuilt 0.7-1 debs (seed + packaging/debs)

| Deb | Bytes | SHA256 |
|-----|------:|--------|
| `lcos-base_0.7-1_all.deb` | 2584 | `45a82817d24f8485eac59702720bef97e817b5f3f3ca475a519b68c2ac3c4854` |
| `lcos-archive-keyring_0.7-1_all.deb` | 7176 | `3db646fed38ad207b917c6d41ded57f1dd76e9fa373d80c8516118a433bd4b58` |
| `lcos-branding_0.7-1_all.deb` | 8471056 | `925cb43ef7d44a7ba773737ffd5b945dabfcecf20a1de42b2113991b6b4f1f2c` |
| `lcos-desktop_0.7-1_all.deb` | 1748 | `502be0bb4a7dc9cce58c9469d2ab17d927b416f009ab70e7a4125dc17c14d809` |
| `lcos-desktop-config_0.7-1_all.deb` | 22552 | `140be73819a083a5436aa8ec16731d84275dc0313671e331e0a06f7d2cf1b2af` |
| `lcos-theme-clearlooks_0.7-1_all.deb` | 85864 | `585ea557feae1829fcb611e42a328c5b534b3674bf9b1e567444ff3974f2568b` |
| `lcos-appimage-thumbnailer_0.7-1_all.deb` | 3224 | `ad354560ed788e8b66f48a3a6b040e5dfc0991e23ba8425e9ea2620b5bcd9b13` |
| `lcos-zork_0.7-1_all.deb` | 156524 | `2a271e9e4a53c4ba224ede696e752388efeef30d6aa0045b4627f119fdcd5b4f` |
| `lunduke-paint_0.7-1_amd64.deb` | 647500 | `f5b445fefc37e41e6655ffda0764aa4c8c064d27f734ab5aa04cf68a9cebfae6` |
| `lcos-updates_0.7-1_amd64.deb` | 157292 | `bdf61b8e73255abf7cebae82140955a54970e421a81a1d8a3e1b0687086048f3` |



Package sources for 0.7 live under `/workspace/lcos-live-07/packaging/src/` (copy of the 0.6 recipe sources; frozen 0.6 tree unchanged).

## Paint / Updates (Phil delivered 2026-09-23 CT)

Phil supplied and seeded:

| Deb | Bytes | SHA256 |
|-----|------:|--------|
| `lunduke-paint_0.7-1_amd64.deb` | 647500 | `f5b445fefc37e41e6655ffda0764aa4c8c064d27f734ab5aa04cf68a9cebfae6` |
| `lcos-updates_0.7-1_amd64.deb` | 157292 | `bdf61b8e73255abf7cebae82140955a54970e421a81a1d8a3e1b0687086048f3` |


Sources: `/workspace/lunduke-paint/packaging/debs/` and `/workspace/lcos-updates/packaging/debs/`.
0.6 paint/updates seeds removed from `config/packages.chroot/`.


## Not bumped

- xlibre* / micropolis* (unchanged)
- Calamares slide PNG filenames (`lcos-05-slide-*.png`) kept; check later if any slide *artwork* still shows “0.6”
- Historical docs under `docs/06-*`, `docs/05-*`, `LCOS-06-PackageSourceList.md` (record of prior releases)
- `packaging/apt-repo*` indexes still describe 0.6 packages (unsigned restage deferred; do not publish)

## Lessons kept from 0.6

- lcos-base postinst → `lcos-write-os-release`
- os-release / issue / issue.net **not** conffiles (only `grub.d/lcos.cfg`)
- `lcos-overlay.list` **not** a conffile; comments version-neutral (keyring **0.7-1**, content unchanged)
- no lcos-themes / lcos-icon-theme
- sudo in Calamares users.conf defaultGroups
- Plymouth force-confold before packages
- Updates upgrade policy; point releases must `apt upgrade` cleanly from 0.6
- Do **not** overwrite user XFCE configs on upgrade (desktop-config remains skel/xdg defaults only)

## Next bake

`lcos-live-07-01.iso` — Chloe owns bake; do not bake until Ted says go. Do not push apt to lcosrepo1 until editor signs.

## Apt staging

Not restaged in this open. Paint/updates 0.7-1 are seeded; restage unsigned under `packaging/apt-repo/` when ready (and a new `/workspace/lcos-0.7-apt-staging/` if desired). No publish from this track-open.

## Related

- Prior bump notes: [`06-VERSION-BUMP.md`](06-VERSION-BUMP.md)
- Known limitations (AMD GL): [`06-KNOWN-LIMITATIONS.md`](06-KNOWN-LIMITATIONS.md)
- Official 0.6 facts (frozen tree): `/workspace/lcos-live-06/docs/06-OFFICIAL-RELEASE.md`

## Sanity rg leftovers (intentional)

Identity paths (`os-release`, `issue`, hook 8900, Calamares version/shortVersion, `lcos-write-os-release`) are **0.7**.

Intentionally still mentioning 0.6 / `lcos-live-06`:

- Branch lineage / freeze notices in `README.md`, `LCOS-VERSION.txt`, this doc
- Historical `docs/06-*`, `docs/05-*`, package source lists
- Calamares slide asset filenames `lcos-05-slide-*.png` / `lcos-05-ideals.png` (names kept since 0.5; artwork review later if “0.6” appears in pixels)
- `packaging/apt-repo*` still indexes 0.6 (unsigned restage deferred)
- Clearlooks theme numeric `0.6` shade/opacity values (not release identity)
- Debian upstream package versions containing `0.6` in package-source lists

`lcos-overlay.list` remains version-neutral (no 0.6/0.7 in comments).

Phil’s seeded `lunduke-paint_0.7-1` / `lcos-updates_0.7-1` are authoritative; `packaging/src/{lunduke-paint,lcos-updates}` are control placeholders only.
