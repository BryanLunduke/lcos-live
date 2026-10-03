#!/bin/bash
# Build LCOS 0.8 overlay .debs (unsigned). Editor signs later.
# Do not generate keys. Do not touch /workspace/lcos-live or XLibre archives.
set -euo pipefail

ROOT=/workspace/lcos-live-08
CHROOT="$ROOT/config/includes.chroot"
SRC="$ROOT/packaging/src"
DEBDIR="$ROOT/packaging/debs"
PKGCHROOT="$ROOT/config/packages.chroot"
MAINT="LCOS <lcos@lunduke.com>"
VER="0.8-1"
KEYRING_VER="0.8-1"  # overlay.list not a conffile; version-neutral comments
EXPECTED_FP="5A01 D4BD CDD1 E153 1D45  6A75 60D6 E7F6 CBD6 D572"

mkdir -p "$SRC" "$DEBDIR"

copy_from_chroot() {
	# copy_from_chroot <pkgroot> <relpath starting with / >
	local pkgroot="$1"
	local rel="${2#/}"
	local src="$CHROOT/$rel"
	local dest="$pkgroot/$rel"
	if [ ! -e "$src" ]; then
		echo "MISSING (skip): $src" >&2
		return 1
	fi
	mkdir -p "$(dirname "$dest")"
	cp -a "$src" "$dest"
}

write_copyright() {
	local dest="$1"
	local pkg="$2"
	local extra="${3:-}"
	mkdir -p "$(dirname "$dest")"
	cat > "$dest" <<EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: $pkg
Source: LCOS 0.4 overlay (https://lunduke.com)

Files: *
Copyright: 2026 Lunduke / LCOS
License: LCOS-overlay
 LCOS overlay packaging. Artwork and config are 0.2-locked LCOS assets
 unless noted. Packages are unsigned until the editor signs the archive.
$extra
EOF
}

finish_pkg() {
	local pkgroot="$1"
	local name="$2"
	# Installed-Size in KiB of payload (not DEBIAN)
	local isize
	isize=$(du -sk --exclude=DEBIAN "$pkgroot" | awk '{print $1}')
	# Inject Installed-Size if not already present
	if ! grep -q '^Installed-Size:' "$pkgroot/DEBIAN/control"; then
		sed -i "/^Architecture:/a Installed-Size: $isize" "$pkgroot/DEBIAN/control"
	fi
	# conffiles: etc/ files except identity (os-release/issue) and the
	# distro overlay apt source — those are distro-managed, not user config.
	# Keep grub.d/lcos.cfg as conffile. (0.8: overlay.list caused dpkg
	# prompts on 0.4→0.5 when only the version comment changed.)
	if [ -d "$pkgroot/etc" ]; then
		( cd "$pkgroot" && find etc -type f | sort | sed 's|^|/|' \
			| grep -v -E '^/etc/os-release$|^/etc/issue$|^/etc/issue\.net$|^/etc/apt/sources\.list\.d/lcos-overlay\.list$' ) \
			> "$pkgroot/DEBIAN/conffiles"
		if [ ! -s "$pkgroot/DEBIAN/conffiles" ]; then
			rm -f "$pkgroot/DEBIAN/conffiles"
		fi
	fi
	# md5sums
	( cd "$pkgroot" && find . -type f ! -path './DEBIAN/*' -print0 \
		| sort -z | xargs -0 md5sum | sed 's|  \./|  |' ) > "$pkgroot/DEBIAN/md5sums"
	chmod 0755 "$pkgroot/DEBIAN"
	chmod 0644 "$pkgroot/DEBIAN/control"
	[ -f "$pkgroot/DEBIAN/md5sums" ] && chmod 0644 "$pkgroot/DEBIAN/md5sums"
	[ -f "$pkgroot/DEBIAN/conffiles" ] && chmod 0644 "$pkgroot/DEBIAN/conffiles"
	# scripts stay executable
	if [ -x "$pkgroot/usr/local/bin/lcos-set-wallpaper" ]; then
		chmod 0755 "$pkgroot/usr/local/bin/lcos-set-wallpaper"
	fi
	if [ -x "$pkgroot/usr/local/sbin/lcos-write-os-release" ]; then
		chmod 0755 "$pkgroot/usr/local/sbin/lcos-write-os-release"
	fi
	if [ -f "$pkgroot/DEBIAN/postinst" ]; then
		chmod 0755 "$pkgroot/DEBIAN/postinst"
	fi
	local out="$DEBDIR/${name}_${VER}_all.deb"
	# metapackage / others use VER 0.4-1 all; caller may override out via env
	if [ -n "${DEB_OUT:-}" ]; then
		out="$DEB_OUT"
	fi
	rm -f "$out"
	fakeroot dpkg-deb --root-owner-group --build "$pkgroot" "$out"
	echo "BUILT $out"
}

# ---------------------------------------------------------------------------
# 1) lcos-archive-keyring
# ---------------------------------------------------------------------------
echo "=== lcos-archive-keyring ==="
# Verify fingerprint BEFORE packaging. Do not replace the key.
FP=$(gpg --show-keys --with-fingerprint --with-colons \
	"$CHROOT/usr/share/keyrings/lcos-archive-keyring.gpg" \
	| awk -F: '/^fpr:/{print $10; exit}')
FP_SPACED=$(echo "$FP" | sed 's/\(....\)/\1 /g;s/ $//;s/\(.....\) \(....\)/\1  \2/')
# gpg colon fpr is 40 hex. Expected spaced form:
FP_HUMAN=$(echo "$FP" | sed 's/.\{4\}/& /g;s/ $//' | sed 's/^\(\([^ ]* \)\{4\}[^ ]*\) /\1  /')
echo "Packaged key fingerprint (raw): $FP"
echo "Human: $FP_HUMAN"
echo "Expected: $EXPECTED_FP"
# Compare compacted hex
EXP_HEX=$(echo "$EXPECTED_FP" | tr -d ' ')
if [ "$FP" != "$EXP_HEX" ]; then
	echo "STOP: key fingerprint mismatch. Will not replace the key file." >&2
	echo "  got:      $FP" >&2
	echo "  expected: $EXP_HEX" >&2
	exit 2
fi
UID_LINE=$(gpg --show-keys "$CHROOT/usr/share/keyrings/lcos-archive-keyring.gpg" 2>/dev/null | awk '/^uid/{sub(/^uid[[:space:]]+/,""); print; exit}')
echo "UID: $UID_LINE"
if [ "$UID_LINE" != "LCOS Archive Signing Key <lcos@lunduke.com>" ]; then
	echo "STOP: UID mismatch: [$UID_LINE]" >&2
	exit 2
fi

rm -rf "$SRC/lcos-archive-keyring"
mkdir -p "$SRC/lcos-archive-keyring/DEBIAN"
copy_from_chroot "$SRC/lcos-archive-keyring" /usr/share/keyrings/lcos-archive-keyring.gpg
copy_from_chroot "$SRC/lcos-archive-keyring" /usr/share/keyrings/lcos-archive-keyring.asc
copy_from_chroot "$SRC/lcos-archive-keyring" /usr/share/keyrings/README.lcos-keyring
copy_from_chroot "$SRC/lcos-archive-keyring" /etc/apt/sources.list.d/lcos-overlay.list
write_copyright "$SRC/lcos-archive-keyring/usr/share/doc/lcos-archive-keyring/copyright" \
	lcos-archive-keyring \
	"
Files: usr/share/keyrings/lcos-archive-keyring.*
Copyright: 2026 LCOS Archive Signing Key <lcos@lunduke.com>
License: public-key
 Public key only. Fingerprint 5A01 D4BD CDD1 E153 1D45  6A75 60D6 E7F6 CBD6 D572.
"
cat > "$SRC/lcos-archive-keyring/DEBIAN/control" <<EOF
Package: lcos-archive-keyring
Version: $KEYRING_VER
Section: misc
Priority: optional
Architecture: all
Maintainer: $MAINT
Homepage: https://lunduke.com
Description: LCOS archive signing keyring and overlay apt source
 Public keyring for the LCOS overlay at https://lcos.lunduke.com/apt
 plus /etc/apt/sources.list.d/lcos-overlay.list (signed-by this key).
 .
 Fingerprint: 5A01 D4BD CDD1 E153 1D45  6A75 60D6 E7F6 CBD6 D572
 UID: LCOS Archive Signing Key <lcos@lunduke.com>
 .
 lcos-overlay.list is not a conffile (same lesson as os-release): point
 releases must refresh the distro overlay source without dpkg prompts.
 Local edits may be overwritten on upgrade; add extras in another .list.
 .
 Unsigned package; editor signs the archive later. Do not replace this key.
EOF
DEB_OUT="$DEBDIR/lcos-archive-keyring_${KEYRING_VER}_all.deb" finish_pkg "$SRC/lcos-archive-keyring" lcos-archive-keyring

# ---------------------------------------------------------------------------
# 2) lcos-branding
# ---------------------------------------------------------------------------
echo "=== lcos-branding ==="
# WARNING 0.8: packaging/src/lcos-branding includes Plymouth + LightDM helpers.
# This script section does NOT copy those yet — prefer rebuild from packaging/src
# (see docs/07-TRACK-OPENED.md) until this section is extended.
rm -rf "$SRC/lcos-branding"
mkdir -p "$SRC/lcos-branding/DEBIAN"
# backgrounds/lcos (LCOS stock + 4k wood + Flat Stock desk)
copy_from_chroot "$SRC/lcos-branding" /usr/share/backgrounds/lcos/lcos-desktop-stock.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/backgrounds/lcos/lcos-desktop-stock.png
copy_from_chroot "$SRC/lcos-branding" /usr/share/backgrounds/lcos/lcos-desktop-4k-wood.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/backgrounds/lcos/lcos-desktop-desk-coffee.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/backgrounds/lcos/lcos-desktop-desk-oak-map.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/backgrounds/lcos/lcos-desktop-synthwave.jpg
# xfce4 backdrops copies
copy_from_chroot "$SRC/lcos-branding" /usr/share/xfce4/backdrops/lcos-desktop-stock.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/xfce4/backdrops/lcos-desktop-stock.png
copy_from_chroot "$SRC/lcos-branding" /usr/share/xfce4/backdrops/lcos-desktop-4k-wood.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/xfce4/backdrops/lcos-desktop-desk-coffee.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/xfce4/backdrops/lcos-desktop-desk-oak-map.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/xfce4/backdrops/lcos-desktop-synthwave.jpg
# desktop-base (stock + extra old bw-720 because it is present + Flat Stock desk)
copy_from_chroot "$SRC/lcos-branding" /usr/share/images/desktop-base/lcos-desktop-stock.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/images/desktop-base/lcos-desktop-stock.png
copy_from_chroot "$SRC/lcos-branding" /usr/share/images/desktop-base/lcos-bw-720.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/images/desktop-base/lcos-desktop-desk-coffee.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/images/desktop-base/lcos-desktop-desk-oak-map.jpg
copy_from_chroot "$SRC/lcos-branding" /usr/share/images/desktop-base/lcos-desktop-synthwave.jpg
# grub splashes
copy_from_chroot "$SRC/lcos-branding" /usr/share/grub/lcos-splash.png
copy_from_chroot "$SRC/lcos-branding" /usr/share/grub/lcos-splash-1024x768.png
copy_from_chroot "$SRC/lcos-branding" /usr/share/grub/lcos-splash-4k.png
# pixmaps
copy_from_chroot "$SRC/lcos-branding" /usr/share/pixmaps/lcos-logo.png
copy_from_chroot "$SRC/lcos-branding" /usr/share/pixmaps/lcos256.png
copy_from_chroot "$SRC/lcos-branding" /usr/share/pixmaps/lcos32.png
# Do NOT include /usr/share/backgrounds/xfce (stock XFCE, not LCOS-specific)
write_copyright "$SRC/lcos-branding/usr/share/doc/lcos-branding/copyright" lcos-branding
cat > "$SRC/lcos-branding/DEBIAN/control" <<EOF
Package: lcos-branding
Version: $VER
Section: x11
Priority: optional
Architecture: all
Maintainer: $MAINT
Homepage: https://lunduke.com
Provides: lcos-branding
Replaces: lcos-branding (<< 0.4)
Conflicts: lcos-branding (<< 0.4)
Description: LCOS 0.4 artwork (0.2-locked wallpapers, splash, logos)
 Current 0.2-locked LCOS artwork: stock wallpaper (jpg/png), 4K wood
 backdrop, GRUB splash (default / 1024x768 / 4K), and logos.
 Also ships the extra legacy desktop-base lcos-bw-720.jpg.
 Replaces old lcos-branding 1.0-2 / 0.2.0 (bw-720 + lcos32 only).
EOF
finish_pkg "$SRC/lcos-branding" lcos-branding

# ---------------------------------------------------------------------------
# 3) lcos-theme-clearlooks
# ---------------------------------------------------------------------------
echo "=== lcos-theme-clearlooks ==="
rm -rf "$SRC/lcos-theme-clearlooks"
mkdir -p "$SRC/lcos-theme-clearlooks/DEBIAN"
mkdir -p "$SRC/lcos-theme-clearlooks/usr/share/themes"
cp -a "$CHROOT/usr/share/themes/Clearlooks" "$SRC/lcos-theme-clearlooks/usr/share/themes/"
cp -a "$CHROOT/usr/share/themes/Clearlooks-Phenix" "$SRC/lcos-theme-clearlooks/usr/share/themes/"
write_copyright "$SRC/lcos-theme-clearlooks/usr/share/doc/lcos-theme-clearlooks/copyright" \
	lcos-theme-clearlooks \
	"
Files: usr/share/themes/Clearlooks/*
Copyright: Clearlooks theme authors
License: GPL-2+
 Vendored from the LCOS 0.2-locked live tree (Clearlooks xfwm4).

Files: usr/share/themes/Clearlooks-Phenix/*
Copyright: Clearlooks-Phenix authors
License: GPL-3+
 Vendored from the LCOS 0.2-locked live tree.
"
cat > "$SRC/lcos-theme-clearlooks/DEBIAN/control" <<EOF
Package: lcos-theme-clearlooks
Version: $VER
Section: x11
Priority: optional
Architecture: all
Maintainer: $MAINT
Homepage: https://lunduke.com
Recommends: gtk2-engines
Description: Clearlooks and Clearlooks-Phenix themes for LCOS
 Vendored Clearlooks (xfwm4) and Clearlooks-Phenix (GTK2/3 + xfwm4)
 theme trees used by the LCOS XFCE desktop.
EOF
finish_pkg "$SRC/lcos-theme-clearlooks" lcos-theme-clearlooks

# NOTE 0.5-2: lcos-themes + lcos-icon-theme removed (non-default).
# Do not rebuild/seed those packages.

# ---------------------------------------------------------------------------
# 4) lcos-desktop-config
# ---------------------------------------------------------------------------
echo "=== lcos-desktop-config ==="
rm -rf "$SRC/lcos-desktop-config"
mkdir -p "$SRC/lcos-desktop-config/DEBIAN"
# /etc/xdg/xfce4/**
while IFS= read -r f; do
	rel="${f#"$CHROOT"}"
	copy_from_chroot "$SRC/lcos-desktop-config" "$rel"
done < <(find "$CHROOT/etc/xdg/xfce4" -type f | sort)
copy_from_chroot "$SRC/lcos-desktop-config" /etc/xdg/menus/xfce-applications.menu
copy_from_chroot "$SRC/lcos-desktop-config" /etc/xdg/autostart/lcos-set-wallpaper.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /etc/xdg/mimeapps.list
# /etc/skel/.config/xfce4/**
while IFS= read -r f; do
	rel="${f#"$CHROOT"}"
	copy_from_chroot "$SRC/lcos-desktop-config" "$rel"
done < <(find "$CHROOT/etc/skel/.config/xfce4" -type f | sort)
copy_from_chroot "$SRC/lcos-desktop-config" /etc/skel/.config/autostart/lcos-set-wallpaper.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /etc/skel/.config/mimeapps.list
copy_from_chroot "$SRC/lcos-desktop-config" /usr/local/bin/lcos-set-wallpaper
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/applications/lcos-micropolis.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/local/share/applications/micropolis.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/local/share/applications/xfce4-about.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/applications/xfce4-file-manager.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/applications/xfce4-mail-reader.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/applications/xfce4-terminal-emulator.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/applications/xfce4-web-browser.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/desktop-directories/xfce-science.directory
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/xfce4/helpers/cool-retro-term.desktop
copy_from_chroot "$SRC/lcos-desktop-config" /usr/share/xfce4/helpers/lunduke-edit.desktop
# Skip: lightdm, hostname/hosts/issue (base), live-only installer bits
write_copyright "$SRC/lcos-desktop-config/usr/share/doc/lcos-desktop-config/copyright" lcos-desktop-config
cat > "$SRC/lcos-desktop-config/DEBIAN/control" <<EOF
Package: lcos-desktop-config
Version: $VER
Section: x11
Priority: optional
Architecture: all
Maintainer: $MAINT
Homepage: https://lunduke.com
Depends: lcos-branding (>= 0.4), lcos-theme-clearlooks (>= 0.4)
Replaces: libgarcon-common, xfce4-panel, xfce4-helpers, xfce4-settings
Recommends: elementary-xfce-icon-theme, gtk2-engines
Description: LCOS XFCE defaults (xdg, skel, wallpaper, menus)
 System and skel XFCE look: xfconf XML, panel default.xml, helpers.rc,
 applications menu, wallpaper autostart + linger script, Bob Micropolis
 launcher, Hidden stock helper .desktop overrides, Science directory hide,
 and Cool Retro Term as the XFCE terminal helper.
 .
 Live-only installer bits are not included.
EOF
finish_pkg "$SRC/lcos-desktop-config" lcos-desktop-config

# ---------------------------------------------------------------------------
# 5) lcos-base  (identity from BASE_VER / IDENTITY_REL — not chroot os-release)
# ---------------------------------------------------------------------------
echo "=== lcos-base ==="
BASE_VER="0.8-1"
IDENTITY_REL="${BASE_VER%%-*}"   # e.g. 0.7 from 0.7-1
rm -rf "$SRC/lcos-base"
mkdir -p "$SRC/lcos-base/DEBIAN"
mkdir -p "$SRC/lcos-base/usr/lib" "$SRC/lcos-base/etc" \
	"$SRC/lcos-base/usr/local/sbin" "$SRC/lcos-base/etc/default/grub.d"
cat > "$SRC/lcos-base/usr/lib/os-release" <<OS
PRETTY_NAME="LCOS ${IDENTITY_REL}"
NAME="LCOS"
VERSION_ID="${IDENTITY_REL}"
VERSION="${IDENTITY_REL} (excalibur)"
VERSION_CODENAME=excalibur
ID=lcos
ID_LIKE="devuan debian"
HOME_URL="https://lunduke.com"
SUPPORT_URL="https://lunduke.com"
BUG_REPORT_URL="https://lunduke.com"
OS
cp -a "$SRC/lcos-base/usr/lib/os-release" "$SRC/lcos-base/etc/os-release"
printf '%s\n' "LCOS ${IDENTITY_REL} \\n \\l" > "$SRC/lcos-base/etc/issue"
printf '%s\n' "LCOS ${IDENTITY_REL}" > "$SRC/lcos-base/etc/issue.net"
cat > "$SRC/lcos-base/usr/local/sbin/lcos-write-os-release" <<WR
#!/bin/sh
set -e
# Rewrite LCOS identity files on the installed target.
# Does NOT overwrite a user-chosen /etc/hostname from the users page.
cat > /etc/os-release <<OS
PRETTY_NAME="LCOS ${IDENTITY_REL}"
NAME="LCOS"
VERSION_ID="${IDENTITY_REL}"
VERSION="${IDENTITY_REL} (excalibur)"
VERSION_CODENAME=excalibur
ID=lcos
ID_LIKE="devuan debian"
HOME_URL="https://lunduke.com"
SUPPORT_URL="https://lunduke.com"
BUG_REPORT_URL="https://lunduke.com"
OS
mkdir -p /usr/lib
cp -f /etc/os-release /usr/lib/os-release
printf "%s\\n" "LCOS ${IDENTITY_REL} \\\\n \\\\l" > /etc/issue
printf "%s\\n" "LCOS ${IDENTITY_REL}" > /etc/issue.net
if [ ! -s /etc/hostname ]; then
	printf "%s\\n" "LCOS" > /etc/hostname
fi
WR
chmod 0755 "$SRC/lcos-base/usr/local/sbin/lcos-write-os-release"
# Force-rewrite identity on configure (noninteractive apt keeps old conffiles)
cat > "$SRC/lcos-base/DEBIAN/postinst" <<'PI'
#!/bin/sh
set -e
if [ "$1" = configure ]; then
  /usr/local/sbin/lcos-write-os-release || true
fi
PI
chmod 0755 "$SRC/lcos-base/DEBIAN/postinst"
copy_from_chroot "$SRC/lcos-base" /etc/default/grub.d/lcos.cfg
# Skip /etc/hostname and /etc/hosts
write_copyright "$SRC/lcos-base/usr/share/doc/lcos-base/copyright" lcos-base
cat > "$SRC/lcos-base/DEBIAN/control" <<EOF
Package: lcos-base
Version: $BASE_VER
Section: admin
Priority: optional
Architecture: all
Maintainer: $MAINT
Homepage: https://lunduke.com
Depends: lcos-archive-keyring (>= ${IDENTITY_REL}), lcos-branding (>= ${IDENTITY_REL})
Replaces: base-files
Description: LCOS ${IDENTITY_REL} identity, GRUB splash drop-in, overlay membership
 os-release / issue for LCOS ${IDENTITY_REL} (excalibur), lcos-write-os-release,
 and /etc/default/grub.d/lcos.cfg (BACKGROUND lcos-splash-1024x768.png,
 GFXMODE=1024x768, GFXPAYLOAD keep).
 .
 Depends on the overlay keyring and branding artwork.
 Postinst re-applies identity on configure so apt upgrades overwrite
 stale conffile text kept by noninteractive Updates.
EOF
DEB_OUT="$DEBDIR/lcos-base_${BASE_VER}_all.deb" finish_pkg "$SRC/lcos-base" lcos-base

# ---------------------------------------------------------------------------
# 6) lcos-desktop metapackage
# ---------------------------------------------------------------------------
echo "=== lcos-desktop ==="
rm -rf "$SRC/lcos-desktop"
mkdir -p "$SRC/lcos-desktop/DEBIAN"
write_copyright "$SRC/lcos-desktop/usr/share/doc/lcos-desktop/copyright" lcos-desktop
cat > "$SRC/lcos-desktop/DEBIAN/control" <<EOF
Package: lcos-desktop
Version: $VER
Section: metapackages
Priority: optional
Architecture: all
Maintainer: $MAINT
Homepage: https://lunduke.com
Depends: lcos-base (>= 0.8), lcos-desktop-config (>= 0.8), lcos-theme-clearlooks (>= 0.8), plymouth, libplymouth5, pulseaudio, pulseaudio-utils, pavucontrol, xfce4-pulseaudio-plugin, alsa-utils, xfce4-power-manager, xfce4-power-manager-plugins, upower, lcos-appimage-thumbnailer (>= 0.8), tumbler
Recommends: xfce4, lightdm, lightdm-gtk-greeter, elementary-xfce-icon-theme, gtk2-engines, lcos-zork, micropolis, lunduke-paint
Description: LCOS 0.8 XFCE desktop edition metapackage
 Pulls LCOS identity, XFCE look, and Clearlooks. Depends on
 Plymouth, PulseAudio/ALSA stack, XFCE power manager, and AppImage
 thumbnailer/tumbler so upgrades get boot splash and media bits. Recommends
 the XFCE/LightDM stack plus Zork, Micropolis, and Lunduke Paint. Does not
 depend on Calamares or live-config installer bits.
EOF
finish_pkg "$SRC/lcos-desktop" lcos-desktop

# ---------------------------------------------------------------------------
# 7) lcos-zork
# ---------------------------------------------------------------------------
echo "=== lcos-zork ==="
rm -rf "$SRC/lcos-zork"
mkdir -p "$SRC/lcos-zork/DEBIAN"
copy_from_chroot "$SRC/lcos-zork" /usr/share/games/zork/zork1.z3
copy_from_chroot "$SRC/lcos-zork" /usr/share/games/zork/zork2.z3
copy_from_chroot "$SRC/lcos-zork" /usr/share/games/zork/zork3.z3
copy_from_chroot "$SRC/lcos-zork" /usr/share/games/zork/LICENSE
copy_from_chroot "$SRC/lcos-zork" /usr/share/applications/lcos-zork1.desktop
copy_from_chroot "$SRC/lcos-zork" /usr/share/applications/lcos-zork2.desktop
copy_from_chroot "$SRC/lcos-zork" /usr/share/applications/lcos-zork3.desktop
write_copyright "$SRC/lcos-zork/usr/share/doc/lcos-zork/copyright" lcos-zork \
	"
Files: usr/share/games/zork/*
Copyright: see /usr/share/games/zork/LICENSE
License: MIT
 Z-machine story files and LICENSE as shipped in the LCOS 0.2-locked tree.
"
cat > "$SRC/lcos-zork/DEBIAN/control" <<EOF
Package: lcos-zork
Version: $VER
Section: games
Priority: optional
Architecture: all
Maintainer: $MAINT
Homepage: https://lunduke.com
Depends: frotz, cool-retro-term
Description: Zork I–III for LCOS (frotz + Cool Retro Term)
 Story files zork{1,2,3}.z3 plus desktop launchers that open each game
 in cool-retro-term running frotz.
EOF
finish_pkg "$SRC/lcos-zork" lcos-zork

# ---------------------------------------------------------------------------
# 8) Micropolis republish (copy, do not rebuild, do not re-sign)
# ---------------------------------------------------------------------------
echo "=== micropolis (copy) ==="
cp -a "$PKGCHROOT/micropolis_0.0.20071228-10_amd64.deb" "$DEBDIR/"
cp -a "$PKGCHROOT/micropolis-data_0.0.20071228-10_all.deb" "$DEBDIR/"
cp -a "$PKGCHROOT/micropolis.copyright" "$DEBDIR/"

# ---------------------------------------------------------------------------
# Install new LCOS debs into packages.chroot; replace old branding
# ---------------------------------------------------------------------------
echo "=== packages.chroot ==="
rm -f "$PKGCHROOT/lcos-branding_1.0-2_all.deb"
for deb in "$DEBDIR"/lcos-*.deb; do
	cp -a "$deb" "$PKGCHROOT/"
done
# leftover 0.2.0 branding at tree root
rm -f "$ROOT/lcos-branding_0.2.0_all.deb"

echo "DONE build"
