# 0.9.3 — #135: XDG desktop portal (Chromium/Brave file pickers)

Issue: https://github.com/BryanLunduke/LCOS/issues/135 — in Brave (Chromium),
Drive upload / Gmail attach silently do nothing on 0.8 installed and 0.9.2 live.
LCOS shipped no xdg-desktop-portal; reporter fixed it with
`apt-get install xdg-desktop-portal-gtk`. Editor approved for 0.9.3 (2026-10-12 CT).

## Changes
- `config/package-lists/desktop.list.chroot`: `xdg-desktop-portal`, `xdg-desktop-portal-gtk`.
- `lcos-base` 0.9.3-2 → **0.9.3-3**: `Depends: ... xdg-desktop-portal-gtk`
  (upgraders get it via Updates, which installs kept-back upgrades that only add packages).
  Built with `packaging/build-093-system-debs.sh --seed --only lcos-base`;
  0.9.3-2 removed from `config/packages.chroot`, SHA256SUMS 30/30.
  sha256 8b60c0d02a6e20d45baebf2a297bc17c8571a508c15237c7768c2ec5e0a5d1ae.
- No lcos-desktop-config bump needed (see below).

## Dependency check (apt-simulated in the lcos-live-093-02 rootfs, excalibur + security/updates/backports)
12 new packages, ~15.1 MB installed, ~4.2 MB download, 0 removed, no systemd:

| package | version | installed KiB |
|---|---|---|
| xdg-desktop-portal | 1.20.3+ds-1 | 2169 |
| xdg-desktop-portal-gtk | 1.15.3-1 | 715 |
| gstreamer1.0-plugins-good | 1.26.2-1+deb13u2 | 8139 |
| gstreamer1.0-plugins-base | 1.26.2-1+deb13u2 | 2606 |
| bubblewrap | 0.12.0-1~deb13u1 | 142 |
| libvisual-0.4-0, libwavpack1, libopencore-amrnb0/-amrwb0, libdv4t64, libcdparanoia0, libiec61883-0 | | ~1340 |

fuse3/libfuse3-4, libpipewire-0.3-0t64, libsystemd0 (library only), dbus-x11,
gsettings-desktop-schemas, GTK3 were already on the ISO. Suggests
(xdg-desktop-portal-gnome, evince, accountsservice) are not pulled
(apt-recommends false; recommends is only librsvg2-common, already present).
Largest cost is gstreamer plugins-good (portal's hard dependency).

## Portal selection
`xfce4-session` (already on the ISO) ships `/usr/share/xdg-desktop-portal/xfce-portals.conf`
with `default=gtk;` (xapp first for Wallpaper/Screenshot/Background — not installed,
falls back to gtk). `startxfce4`/xinitrc sets `XDG_CURRENT_DESKTOP=XFCE`. So no
LCOS portals.conf is needed. gtk.portal's legacy `UseIn=gnome` is irrelevant once
a portals.conf matches.

## DBus activation environment (no systemd)
Portals start by D-Bus activation (`Exec=/usr/libexec/xdg-desktop-portal[-gtk]`;
`SystemdService=` is ignored without systemd --user). Session bus comes from
`75dbus_dbus-launch` (`use-session-dbus` set in Xsession.options); then
`95dbus_update-activation-env` runs `dbus-update-activation-environment --all`
(DISPLAY, XAUTHORITY, …) and xfce4 xinitrc pushes XDG_CURRENT_DESKTOP,
XDG_RUNTIME_DIR, etc. So the portal gets DISPLAY.

## Risks / to verify on the next test ISO
- Not runtime-tested yet (no ISO baked by request). QEMU check: Brave/Chromium
  "Upload"/"Attach" opens the GTK chooser; `ps` shows xdg-desktop-portal(-gtk);
  Firefox and LCOS apps unchanged; GTK apps don't get a ~25 s startup stall
  (classic symptom if the portal can't start).
- Portal now also serves Settings (color-scheme), Notification, Inhibit, Print
  for portal-aware apps (Flatpak, Chromium, Firefox w/ GTK_USE_PORTAL); behavior
  could change subtly (e.g. Chromium dark-mode via Settings portal).
- Live session started via autologin goes through the same Xsession path; confirm.
- xdg-document-portal needs FUSE (`/dev/fuse`); harmless if unavailable.
- Updates path: Depends-adding upgrades need Updates 0.9.2-2+ (kept-back install);
  0.9.1/0.8 still need two Updates runs as before.
