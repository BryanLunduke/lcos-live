# 0.3 apt sources draft

## Installed system (goal)

1. Devuan Excalibur (main + contrib + non-free-firmware) — OS + security
2. Devuan excalibur-security / excalibur-updates — as today
3. LCOS overlay — `https://lcos.lunduke.com/apt` suite `excalibur` component `main`
   - signed-by `/usr/share/keyrings/lcos-archive-keyring.gpg` (editor ships key)
4. Brave (optional, existing) — Brave’s apt, not LCOS
5. **No** `xlibre-deb.github.io` on installed systems

Draft drop-in in recipe:
`config/includes.chroot/etc/apt/sources.list.d/lcos-overlay.list`

Keyring file is a stub until editor publishes the key:
`config/includes.chroot/usr/share/keyrings/lcos-archive-keyring.gpg` — PLACEHOLDER, do not invent a key.

Devuan lines remain owned by live-build / calamares unpack (not duplicated here).

## Bake-time

Until overlay hosts XLibre + branding:
- keep vendored debs in `packages.chroot` OR a private bake-only archive
- drop `config/archives/xlibre.list.*` from the *installed* image path once overlay carries XLibre
