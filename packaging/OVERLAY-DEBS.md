# LCOS 0.3 overlay debs

Rebuilt **2026-09-02** (America/Chicago) from files already in `/workspace/lcos-live-03`
(`config/includes.chroot` → `packaging/src` → `dpkg-deb`), then **lcos-desktop-config
look files restored from frozen 0.2** `/workspace/lcos-live` includes and that package
rebuilt alone. **Not** from github.com/BryanLunduke/LCOS-Branding. **Not** a bake.
**Not** an upload. **Not** an InRelease.

Unsigned. Editor signs InRelease / Release.gpg before upload to
https://lcos.lunduke.com/ (repo BryanLunduke/lcosrepo1).

0.2 tree `/workspace/lcos-live` is unchanged. ISO includes in `lcos-live-03` were
**not** rewritten.

Output: `packaging/debs/` (also copied into `config/packages.chroot/`).

## Overlay first-boot look (0.2) — lcos-desktop-config

`lcos-desktop-config` 0.3-1 ships the frozen **0.2** first-boot look (extracted
from the **new** deb after restore):

- ThemeName: **Clearlooks-Phenix**
- IconThemeName: **elementary-xfce**
- xfwm theme: **Clearlooks**
- WALL / xfce4-desktop last-image: `/usr/share/backgrounds/lcos/lcos-desktop-stock.jpg`
- No `desktop-icons/gravity` in the overlay xfce4-desktop.xml (0.2 file)

Lunduke-Steel / LCOS-Flat-Stock are **not** the overlay default. Extra wallpapers
(`lcos-desktop-desk-coffee.jpg`, `lcos-desktop-desk-oak-map.jpg`, 4k wood) are
**installed** by `lcos-branding` (backgrounds, xfce4 backdrops, desktop-base)
but are **not** the default wallpaper.

New packages (also in `packages.chroot`):

- **lcos-themes** — Lunduke-Steel + Lunduke-Parchment (installed extras)
- **lcos-icon-theme** — LCOS-Flat-Stock (installed extra; inherits elementary-xfce)

`lcos-desktop` Depends on both plus clearlooks / desktop-config / base.

Replaces kept: `lcos-base` Replaces `base-files`; `lcos-desktop-config` Replaces
`libgarcon-common`, `xfce4-panel`, `xfce4-helpers`, `xfce4-settings`.

## Apt-repo (UNSIGNED)

Working tree: `packaging/apt-repo/`

- Layout: `dists/excalibur/main/binary-amd64/Packages(.gz)` plus `binary-all`,
  `pool/main/...`
- Unsigned `dists/excalibur/Release` via `apt-ftparchive` using
  `packaging/apt-repo/apt-ftparchive-release.conf` (Origin/Label LCOS, Suite
  and Codename excalibur, Architectures amd64, Components main).
- **No** InRelease, **no** Release.gpg in this tree. Pending editor sign.
- Pool includes overlay debs (including lcos-themes + lcos-icon-theme) plus
  XLibre 25.1.9-1+lcos1 and `xserver-xlibre-video-vmware_25.0.0-2+lcos1_amd64.deb`
  (vmwgfx/KMS). Does **not** include vmware `25.0.0-1` / `*2d-only*`, README,
  vendor `packaging/debs/xlibre-25.0.0.12-vendor/`, or lunduke-paint.

Signed snapshot of the previous tree (InRelease Date Wed, 26 Aug 2026 00:51:00
+0000 / Aug 29 file mtime + 2D vmware 25.0.0-1) was moved aside, **not**
destroyed, **not** overwriting `packaging/apt-repo-signed-0.3-overlay-only/`:

`packaging/apt-repo-signed-0.3-xlibre-25.1.9-2d-vmware/`

## Package table (this rebuild; sha256sum of real files)

| Package | Version | Arch | Bytes | SHA256 |
|---------|---------|------|-------|--------|
| lcos-archive-keyring | 0.3-1 | all | 6784 | 32dfe620a1b4c2b93d5e83a6ea04da5e3332d6dac6e1b2f98e1de17ab6a17585 |
| lcos-base | 0.3-1 | all | 2156 | 6ea7ce81339306a7a962a01c5388e3c2486c52cd3ef276f200e2f2bebc896dfd |
| lcos-branding | 0.3-1 | all | 7600452 | a3e88798b4dcdea186aff27df8b11b945b337ffb3ef91c028d564f101a2478c8 |
| lcos-desktop-config | 0.3-1 | all | 20448 | e06bd84220006c1a2c31592d090edcfc2ecf9a7a2ecd5c891cecd33447139fe0 |
| lcos-desktop | 0.3-1 | all | 1376 | 18f96887d6a30689140a69045c12402deea0ba7ae25f3f523e0440a2cc5848a3 |
| lcos-icon-theme | 0.3-1 | all | 73344 | 628555b04966e497454fd7276526d428ee93dee49678abd325b65f2876ed5f25 |
| lcos-theme-clearlooks | 0.3-1 | all | 85640 | 0d7a24fed9e71d5e7db0bf1e0282be6632a83e802a3916f8c551b595a9a0e7ad |
| lcos-themes | 0.3-1 | all | 74736 | 0693f85588842ba5ac9ba8f515c70793f3d8ce3d23b61bbd6959852276cbe12a |
| lcos-zork | 0.3-1 | all | 156300 | eb92ac89426bb4d09363593bde5bdf39d966a1ffd9b890144c07daf5260d303f |
| micropolis | 0.0.20071228-10 | amd64 | 369556 | 48ce956c97a2aae64124ddd23109e36a1355754151210e1b9d20721b04bf67c1 |
| micropolis-data | 0.0.20071228-10 | all | 2465808 | 8d30b1cd0eb340f42ae71ea596a28bbdd57111afa1f381755d8c445a5e8e7b5c |

## What each contains

- **lcos-archive-keyring** — public key `.gpg` + `.asc` + overlay `sources.list.d`. Fingerprint `5A01 D4BD CDD1 E153 1D45  6A75 60D6 E7F6 CBD6 D572`.
- **lcos-base** — Depends keyring + branding. os-release/issue LCOS 0.3, `lcos-write-os-release`, `grub.d/lcos.cfg` (1024x768 splash). Replaces `base-files`.
- **lcos-branding** — 0.2-locked stock wallpaper (jpg/png), 4K wood, GRUB splashes, logos; extra coffee + oak-map wallpapers installed but not default; legacy `lcos-bw-720.jpg`. Replaces `lcos-branding (<< 0.3)`.
- **lcos-desktop-config** — XFCE xdg/skel with **0.2 first-boot look**, linger wallpaper script, menus, Micropolis launcher. No live installer bits. Replaces `libgarcon-common`, `xfce4-panel`, `xfce4-helpers`, `xfce4-settings`.
- **lcos-desktop** — metapackage Depends base + desktop-config + clearlooks + lcos-themes + lcos-icon-theme.
- **lcos-theme-clearlooks** — Clearlooks + Clearlooks-Phenix trees.
- **lcos-themes** — Lunduke-Steel + Lunduke-Parchment (installed extras, not overlay first-boot default).
- **lcos-icon-theme** — LCOS-Flat-Stock (installed extra, not overlay first-boot default).
- **lcos-zork** — z3 + desktops; Depends frotz, cool-retro-term.
- **micropolis / micropolis-data** — republished Bookworm debs, copyright kept, not rebuilt, not re-signed.

- **lcos-appimage-thumbnailer** — tumbler `.thumbnailer` + script extracting Type-2 `.DirIcon` (no menu hooks).
