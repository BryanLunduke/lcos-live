# Metapackage sketch (0.3)

## lcos-base

Identity + apt overlay membership for any LCOS install (desktop or future spins).

Depends:
- `lcos-branding` (or `lcos-artwork`) — os-release assets, issue, pixmaps, grub splash drop-in
- `lcos-archive-keyring` — ships keyring + sources.list.d/lcos-overlay.list
- Recommend: nothing that pulls a full desktop

Contents (or Depends pulling content packages):
- `/etc/os-release` NAME=LCOS VERSION=0.3
- `/usr/local/sbin/lcos-write-os-release` (or move under /usr/sbin)
- `/etc/default/grub.d/lcos.cfg` (GFXMODE=1024x768, BACKGROUND=lcos-splash-1024x768.png)

## lcos-desktop

XFCE LCOS desktop edition. Depends:

- `lcos-base`
- `lcos-desktop-config` — xdg/skel XFCE XML, wallpaper script, menus, Clearlooks theme package
- `lcos-theme-clearlooks` (if split)
- Devuan: `xfce4`, `lightdm`, `lightdm-gtk-greeter`, `elementary-xfce-icon-theme`, `gtk2-engines`, …
- XLibre stack (from LCOS overlay once vendored): `xlibre`, `xserver-xlibre`, input/video `*-all`
- Apps (optional Recommends): `brave-origin`, `cool-retro-term`, `gnumeric`, `abiword`, `galculator`, `vlc`, `aisleriot`, `maelstrom`, `lunduke-paint`, `lcos-micropolis`, `lcos-zork`

Not Depends (seed / installer ISO only):
- `calamares`, live-config hooks, live sudoers

## Naming

Prefer exact names `lcos-base` and `lcos-desktop` (editor direction). Avoid conflicting with any future `lcos-branding` Provides.
