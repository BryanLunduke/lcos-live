# LCOS live-build recipe (1.0.2 hotfix)

> **1.0.2 hotfix (2026-11-12) on frozen branch `lcos-1.0.1`.** Identity is
> **1.0.2**. Next test bake: **`lcos-live-102-01.iso`**. The change is the
> AMD rootless X fix (#202): XLibre `2:25.1.11-1+lcos2` (SingleDriver) and
> `lcos-base` `1.0.2-1`. Kernel stays LLK 7.2.15-lcos33. Apps stay 1.0.1-1.
> `lcos-desktop-config` stays 1.0.1-2. Not published.
> `master` is the 1.1 track and still needs the same XLibre change.
> Current versions and seeds: `LCOS-VERSION.txt`, `config/packages.chroot/SHA256SUMS`
> and the `config/packages.chroot/SEED-*.txt` notes.
> The 1.0.1, 1.0.0, 0.9.x and 0.8 notes below are kept for history.

Lunduke Computer Operating System. Devuan Excalibur live ISO with XLibre,
XFCE, Calamares, and a thin signed LCOS apt overlay. No systemd. No Refracta.
No debian-installer. No AI.

*History (0.8 open, 2026-09-28):* Tree: `/workspace/lcos-live-08/` (0.8 recipe). Branched from frozen 0.7
(`/workspace/lcos-live-07/`, last ISO `lcos-live-07-08.iso`, SHA256
`c27376f042e3b3153899636b3ffc0eaa9cf44dbe31c8cf56393e78d0a0816cde`,
1409286144 bytes; tag `lcos-live-07-08`). Prior official 0.6:
`/workspace/lcos-live-06/` (`lcos-live-06-03.iso`); prior 0.5:
`/workspace/lcos-live-05/` (`lcos-live-05-05.iso`).
**Official 0.7 is frozen** at `/workspace/lcos-live-07/`. **Official 0.6 is frozen** at `/workspace/lcos-live-06/`. **Official 0.5 is frozen** at `/workspace/lcos-live-05/`. Frozen 0.4:
`/workspace/lcos-live-04/`. Frozen 0.3: `/workspace/lcos-live-03/`. Frozen 0.2:
`/workspace/lcos-live/`.
Next bake filename on this tree: **`lcos-live-08-01.iso`**. Identity is **0.8**. Seeded overlay/app debs remain **0.7 track** until Phil supplies 0.8 (see `config/packages.chroot/WAITING_ON_PHIL-0.8-apps.txt`). Default ISO kernel: **Lunduke Linux Kernel** 7.2.6-lcos8 (carried seed). See `docs/08-TRACK-OPENED.md`, `docs/07-OFFICIAL-RELEASE.md`, `helpers/README-LLK-BAKE.md`.
Point-release policy: upgrades via Updates/`apt`; do not overwrite existing user XFCE configs.
Public apt overlay remains the signed **0.7** tree (`lcosrepo1` master `53439b7`) until a future 0.8 publish. Do **not** publish apt from this track-open. See `docs/08-TRACK-OPENED.md`.

## Locked stack

- Suite: Devuan `excalibur` (never the moving `stable` alias)
- Mirror: set in `auto/config`. Build-time fetches are pinned to FAU over HTTPS;
  the installed system's apt sources use `deb.devuan.org` (#163)
- Init: sysvinit (`--initsystem sysvinit`, `sysvinit-core`, `live-config-sysvinit`)
- Kernel (default ISO): **Lunduke Linux Kernel** (`linux-image-7.2.15-lunduke`, carried from 1.0.1);
  live-build `--linux-packages none` + `kernel-lunduke.list.chroot`. Seeded
  7.2.15-lcos33 debs (see `config/packages.chroot/SEED-llk-7.2.15-lcos33.txt`). When the
  kernel release changes, keep the package list, `KVER` in
  `config/hooks/live/0095-lunduke-initramfs.hook.chroot` and the seeded debs in step. Bake
  override: `helpers/binary_linux-image` — see `helpers/README-LLK-BAKE.md`.
- Per-machine kernel options (1.0.1): the UEFI live menu and the installed system's
  GRUB set `${lcos_quirks}` from SMBIOS (`config/bootloaders/grub-pc/config.cfg`,
  hook `0105-lcos-grub-dmi-quirks.hook.binary`, lcos-base `/etc/grub.d/05_lcos_quirks`).
  Only entry: Dell XPS 13 DX13260 (SKU 0E53) gets `xe.enable_panel_replay=0`.
- Display: XLibre (vendored debs in `config/packages.chroot/` / overlay).
  Not Xorg, not Wayland. Do **not** point users at `xlibre-deb.github.io`.
- Desktop: XFCE + LightDM. Default look: Clearlooks-Phenix / Clearlooks /
  elementary-xfce (base only; hidpi/dark stripped at bake) / stock wallpaper.
  Non-default Lunduke themes and LCOS-Flat-Stock icon set are **not** seeded.
- Live user / hostname: `lcos` / `LCOS`
- Boot menu text: LCOS
- Installer: **Calamares** (`--debian-installer none`). Devuan-safe config
  (no systemd modules).
- Browser: Brave Origin from Brave’s apt (seed archives). Not vendored into
  the LCOS overlay.
- Paint: **Lunduke Paint** only (`lunduke-paint`). No mtPaint.
- Text editor: **Lunduke Edit** (`lunduke-edit`). Mousepad removed. XFCE Preferred Applications TextEditor + mime defaults point at Edit.
- Updates UI: **Check for updates…** (`lcos-updates`). Manual only — no
  background auto-update, no PackageKit.
- AppImage icons: **tumbler** + `lcos-appimage-thumbnailer` (`.DirIcon` →
  Thunar / xfdesktop). No menu integration.

- Boot splash: **Plymouth** theme `lcos` (three-frame “Starting your
  computer…” cycle). Live `--bootappend-live` and installed
  `GRUB_CMDLINE_LINUX_DEFAULT` use `quiet splash`; failsafe keeps `nosplash`.
  Theme ships in `lcos-branding` and under
  `config/includes.chroot/usr/share/plymouth/themes/lcos/`.
  Bake uses `config/includes.chroot_before_packages/etc/apt/apt.conf.d/`
  `--force-confold` so branding/plymouth conffile order does not hang the build.
- Installer art: Calamares welcome `lcos-05-ideals.png`; progress slideshow
  `lcos-05-slide-01`…`06` (680×360, top-anchored, no sidebands). Asset
  filenames kept; Calamares `version` / `shortVersion` are **1.0.2**.

## Apt overlay

Installed systems age via:

1. Devuan Excalibur (+ updates/security)
2. LCOS overlay: `https://lcos.lunduke.com/apt` suite `excalibur` component `main`
   (`signed-by=/usr/share/keyrings/lcos-archive-keyring.gpg`)
3. Brave’s apt (browser only)

Keyring + `sources.list.d/lcos-overlay.list` ship in `lcos-archive-keyring`.
Editor owns the private signing key and DNS. Overlay packages live under
`packaging/debs/` and are published to `BryanLunduke/lcosrepo1` (GitHub Pages
at `lcos.lunduke.com`). Branding source is that overlay — do **not** use
`BryanLunduke/LCOS-Branding`.

See `docs/03-UPDATES-INVENTORY.md`, `docs/03-SOURCES-DRAFT.md`,
`docs/08-TRACK-OPENED.md`, `docs/07-TRACK-OPENED.md`, and `packaging/OVERLAY-DEBS.md`.

## live-build mode

Host `live-build` only documents `--mode debian`. This recipe uses
`--mode debian` + Devuan mirrors + `--keyring-packages devuan-keyring`
+ `--initsystem sysvinit` + a custom debootstrap script
(`helpers/debootstrap-excalibur`).

## ISO names

Sequential: `lcos-live-VV-BB.iso` where `VV` is the version without the dot
(`08` = 0.8, `097` = 0.9.7, `100` = 1.0.0) and `BB` is the build number. Do not use `notes/` or
`grubtest`-style names.

Private test uploads: `BryanLunduke/lcos-testing` Release assets.

## 0.8 seed highlights (history)

- Overlay identity packages **0.7-1** (base, branding, desktop, desktop-config,
  clearlooks, archive-keyring, appimage-thumbnailer, zork)
- Lunduke Paint **0.7-1** (Phil delivered)
- Updates **0.7-1** (Phil delivered)
- Lunduke Edit **0.7-5** seeded; Mousepad removed from desktop.list
- **LLK default** (carried from 0.7): `--linux-packages none`,
  `kernel-lunduke.list.chroot`, initramfs hook, `helpers/binary_linux-image`
  override; **7.2.6-lcos8** debs seeded.
- Theme trim hook `5040-lcos-strip-unused-icon-themes.hook.chroot`
- Lessons from 0.5 kept: base postinst identity rewrite; os-release/issue not
  conffiles; no lcos-themes/icon-theme; sudo in Calamares defaultGroups;
  Plymouth force-confold; Updates upgrade policy

## Bake

Chloe owns ISO/image builds. Do not bake unless Ted says go.

```
cd <lcos-live checkout on master>
lb config
sudo lb build
```

Log: as Chloe records for that run.

Do **not** publish apt from the 1.0.0 track until approved; the public overlay
is the signed 0.9.7 tree (`lcosrepo1` `f3b29f0`). See `LCOS-VERSION.txt`.

## Roles (quick)

- **Ted** — Chief of Staff; coordinates; pulls the editor in for decisions
- **Chloe** — live-build / ISO / overlay publish (after sign)
- **Bob** — look-and-feel, default software list
- **Phil** — desktop apps (Lunduke Paint, Updates, …)

## Ideals (product)

No age/ID verification; no online accounts required; no AI; no weird politics;
no systemd; no forced Rust clones; modern tech under a 90s UI; upstream-first;
monarchy (not a community fork project). Support/bugs: Lunduke Journal Forum
(subscribers).
