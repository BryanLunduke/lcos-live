# LCOS 0.8 — track opened

**Date:** 2026-09-28 (America/Chicago)

## What happened

- Frozen `/workspace/lcos-live-07` for hotfixes only (last ISO `lcos-live-07-08`).
- Branched `/workspace/lcos-live-07` → `/workspace/lcos-live-08` (`rsync -a`; no cache/chroot/binary/.build).
- Left `/workspace/lcos-live-07` frozen (not gutted). Left `/workspace/lcos-live-06` untouched.
- Identity bumped **0.7 → 0.8** (os-release, issue, issue.net, hook 8900, Calamares version/shortVersion, lcos-write-os-release in includes + lcos-base src, auto `--image-name` / `--iso-volume`, `config/binary` `LB_ISO_VOLUME`).
- `build-overlay-debs.sh` ROOT/VER/KEYRING_VER/BASE_VER pointed at 0.8 for **future** rebuilds — **no debs built**.
- Seeded app/overlay `.deb` files remain **0.7 track** until Phil supplies 0.8 (see `config/packages.chroot/WAITING_ON_PHIL-0.8-apps.txt`).
- **No ISO baked. No apt publish/sign/republish.**

## Not invented

- No `*_0.8-*_*.deb` packages
- No package filename renames in `packages.chroot/`
- No Version bumps inside existing `.deb` binaries

## Packaging/src notes

- Identity file contents under `packaging/src/lcos-base/` (os-release/issue/write script) and Description strings that named “LCOS 0.7” were bumped to **0.8**.
- `DEBIAN/control` **Version:** fields still reflect last built 0.7 package versions (placeholders until Phil/rebuild). Do not treat as shipped 0.8 debs.

## Next bake

`lcos-live-08-01.iso` — Chloe owns bake; do not bake until Ted says go.

## Related

- Frozen 0.7 facts: `/workspace/lcos-live-07/docs/07-OFFICIAL-RELEASE.md`
- Prior track open: `docs/07-TRACK-OPENED.md`
