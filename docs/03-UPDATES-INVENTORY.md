# LCOS 0.3 UPDATES inventory

Branched 2026-08-22 from official 0.2 (`lcos-live-02-10.iso`,
SHA256 f9d5b534239928e578cb4f9072cf0ab80f03ad3a8198391c498c703c00b09c16).

0.2 tree `/workspace/lcos-live` is FROZEN. This tree is `/workspace/lcos-live-03`.

Direction (editor via Nedry): thin signed LCOS apt overlay + Devuan Excalibur
for security. Not a fork. Hostname `lcos.lunduke.com`. ISO is the edition;
apt ages it. No background auto-update. Do not point users at xlibre-deb.github.io.

## Split legend

- **OVERLAY** — belongs in the signed LCOS apt repo (lcos.lunduke.com)
- **SEED** — bake-only / live-ISO seed (hooks, live-config, Calamares live bits)
- **REBUILD** — must become a proper .deb (or be vendored into overlay) before 0.3 public

---

## A. OVERLAY (publish as debs on lcos.lunduke.com)

| Item | Today | Notes |
|------|-------|-------|
| `lcos-branding` | vendored `packages.chroot/lcos-branding_1.0-2_all.deb` | Already a deb. Republish/resign under LCOS overlay. Stale `lcos-branding_0.2.0_all.deb` at tree root is leftover — do not ship both. |
| Wallpapers / GRUB splash / logos | includes: `usr/share/backgrounds/lcos/*`, `usr/share/xfce4/backdrops/*`, `usr/share/grub/lcos-splash*.png`, `usr/share/pixmaps/lcos*.png`, desktop-base copies | Fold into `lcos-branding` or `lcos-artwork`. |
| Clearlooks + Clearlooks-Phenix | vendored theme trees under `usr/share/themes/` (~1.2MB, 253 files) | Package as `lcos-theme-clearlooks` (or fold into branding). |
| XFCE defaults (xdg + skel) | panel, xsettings IconThemeName=elementary-xfce, wallpaper XML, helpers.rc, menus, Hidden stock desktops | Package as `lcos-desktop-config` (or metapackage content). |
| Wallpaper linger script | `usr/local/bin/lcos-set-wallpaper` + xdg/skel autostart | Part of desktop-config. |
| Micropolis | Bookworm debs in `packages.chroot/` + SDL runtime from Excalibur | Republish under LCOS overlay (or keep as seed-only game). Copyright kept. |
| Zork I–III | `usr/share/games/zork/*.z3` + MIT LICENSE + `lcos-zork{1,2,3}.desktop` | Package as `lcos-zork` (data + desktops); Depends: `frotz`, `cool-retro-term`. |
| OS identity helpers | `usr/local/sbin/lcos-write-os-release`, live `8900` identity, `/etc/os-release` template | Package as `lcos-base` content (VERSION bump to 0.3). |
| Installed GRUB drop-in | `etc/default/grub.d/lcos.cfg` + hook 5010 | Package in `lcos-base` / branding. |
| Metapackages | (new) `lcos-base`, `lcos-desktop` | See packaging/METAPACKAGES.md |

## B. SEED-ONLY (stay in live-build recipe; not for apt upgrades)

| Item | Why seed-only |
|------|----------------|
| live-config `2000-lcos-installer-desktop`, `2010-lcos-xfce-skel` | Live boot only |
| Calamares modules + branding QML + shellprocess cleanup | Installer ISO |
| Live sudoers / polkit Calamares exceptions | Removed on install |
| `lcos-trust-installer` + autostart | Live only |
| Bootloader menu branding hooks (`0100` binary, isolinux/syslinux/grub-pc splash + theme title LCOS) | ISO media |
| Fail-the-bake hooks 0110–0113, no-systemd hooks | Build gate |
| `archives/brave.*` | Third-party browser; keep as seed or document separately (not LCOS overlay) |
| Pin prefs `no-systemd`, xorg demotion | Seed policy for bake |
| live-build `auto/config`, helpers/debootstrap-excalibur | Bake host |

## C. REBUILD / MIGRATE (must not stay as seed forever)

| Item | Action for 0.3 |
|------|----------------|
| **XLibre** (`archives/xlibre.list` → xlibre-deb.github.io) | **Do not point users at xlibre-deb.github.io.** Vendor XLibre debs into LCOS overlay (or packages.chroot until overlay exists), drop public xlibre list from installed system. |
| Micropolis Bookworm debs | Rebuild or resign into LCOS overlay (not Bookworm apt pin). |
| Clearlooks file dump | Turn into a real `.deb`. |
| Includes-only artwork / XFCE XML | Absorb into `lcos-branding` / `lcos-desktop-config`. |
| Zork loose files | Turn into `lcos-zork` deb. |
| Duplicate branding `0.2.0` at tree root | Delete from 0.3 tree once 1.0-2 is the overlay package. |

## D. Plain Devuan Excalibur (stay on Devuan mirrors)

Everything else in package-lists: XFCE stack, LightDM, elogind, sysvinit,
live-boot/config, Calamares + grub stack, gnumeric/abiword, aisleriot,
maelstrom, nano, galculator, frotz, SDL1.2, elementary-xfce-icon-theme,
network-manager, etc. Security updates come from Devuan excalibur-security.

Brave Origin stays on Brave’s apt (seed archive), not LCOS overlay.

## E. Version bump (when Nedry says)

- `os-release` / issue / branding.desc → LCOS 0.3
- Next ISO: `lcos-live-03-01.iso`
