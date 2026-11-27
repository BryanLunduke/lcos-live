#!/bin/bash
# Build the LCOS 1.1.0 system overlay debs (unsigned). lcos-base 1.1.0-3 (firmware-mediatek added to the backports pin, 2026-11-27; 1.1.0-2 was the dirty writeback cap, LCOS #201, and the SingleDriver snippet plus Depends libegl1, #202). lcos-branding 1.1.0-1. lcos-desktop-config 1.1.0-3 (NoDisplay for Print Settings, Advanced Network Configuration, Bluetooth Manager, Bluetooth Adapters, Panel, and Volume Control, 2026-11-27; 1.1.0-2 was Lunduke Terminal, Command Center, and the hot-plug display divert). lcos-zork 1.1.0-1 (launchers use lunduke-terminal). Other metapackages stay 0.9.4-1.
# (lcos-base Depends and pin as 1.0.1-5, incl. less, plus libegl1; lcos-desktop-config 1.1.0-3 hides the settings apps Command Center replaced):
# lcos-base (identity 1.1.0; Depends eject, cifs-utils, keyutils,
# gvfs-backends, dialog as 0.9.2-5; ships the lcos-amd-backports.pref apt pin
# incl. i386 Mesa, #129), lcos-branding, lcos-desktop-config,
# lcos-appimage-thumbnailer, lcos-archive-keyring (key unchanged),
# lcos-desktop, lcos-theme-clearlooks, lcos-zork.
# Copied from build-101-system-debs.sh. Usage:
#   packaging/build-110-system-debs.sh [--seed] [--only pkg[,pkg...]]
# lcos-bootmenu 1.1.0-1 is the UEFI rEFInd picker and the GRUB theme.
# It is not a version bump of any other package.
# --seed copies the debs into config/packages.chroot, moves older versions
# of the same packages there to packages.chroot/superseded/ (gitignored), and rewrites SHA256SUMS for every top-level deb.
# Builds straight from packaging/src/<pkg>. Editor signs later.
set -euo pipefail
ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/packaging/src"
DEBDIR="$ROOT/packaging/debs"
mkdir -p "$DEBDIR"

build() {
	local name="$1" ver="$2" root="$SRC/$1"
	grep -q "^Version: ${ver}\$" "$root/DEBIAN/control" || { echo "version mismatch $name" >&2; exit 2; }
	local isize
	isize=$(du -sk --exclude=DEBIAN "$root" | awk '{print $1}')
	sed -i "s/^Installed-Size:.*/Installed-Size: ${isize}/" "$root/DEBIAN/control"
	( cd "$root" && find . -type f ! -path './DEBIAN/*' -print0 | sort -z \
		| xargs -0 md5sum | sed 's|  \./|  |' ) > "$root/DEBIAN/md5sums"
	chmod 0755 "$root/DEBIAN"
	chmod 0644 "$root/DEBIAN/control" "$root/DEBIAN/md5sums"
	for c in conffiles triggers; do [ -f "$root/DEBIAN/$c" ] && chmod 0644 "$root/DEBIAN/$c"; done
	for s in postinst postrm preinst prerm; do
		[ -f "$root/DEBIAN/$s" ] && chmod 0755 "$root/DEBIAN/$s"
	done
	find "$root" -path "$root/DEBIAN" -prune -o -type d -exec chmod 0755 {} +
	# executables we ship
	for x in usr/local/sbin/lcos-write-os-release usr/lib/lcos/lcos-display-fix usr/lib/lcos/plymouth-quit-greeter usr/bin/lcos-appimage-thumbnailer usr/lib/lcos/lcos-reboot-required etc/grub.d/05_lcos_quirks etc/grub.d/06_lcos_bootmenu usr/sbin/lcos-bootmenu usr/libexec/system-sleep/lcos-sleep; do
		[ -f "$root/$x" ] && chmod 0755 "$root/$x"
	done
	local out="$DEBDIR/${name}_${ver}_all.deb"
	rm -f "$out"
	fakeroot dpkg-deb --root-owner-group -Zxz --build "$root" "$out" >/dev/null
	echo "BUILT $out $(sha256sum "$out" | cut -d' ' -f1)"
}

VER=0.9.4-1
BASEVER=1.1.0-3
DCVER=1.1.0-3
BRVER=1.1.0-1
ZORKVER=1.1.0-1
BOOTVER=1.1.0-1
ver_of() { case "$1" in lcos-base) echo "$BASEVER";; lcos-branding) echo "$BRVER";; lcos-desktop-config) echo "$DCVER";; lcos-zork) echo "$ZORKVER";; lcos-bootmenu) echo "$BOOTVER";; *) echo "$VER";; esac; }
PKGS="lcos-branding lcos-base lcos-desktop-config lcos-appimage-thumbnailer lcos-archive-keyring lcos-desktop lcos-theme-clearlooks lcos-zork lcos-bootmenu"
SEED=
while [ $# -gt 0 ]; do
	case "$1" in
	--seed) SEED=1 ;;
	--only) shift; PKGS=$(echo "$1" | tr , ' ') ;;
	*) echo "unknown arg $1" >&2; exit 2 ;;
	esac
	shift
done
for p in $PKGS; do build "$p" "$(ver_of "$p")"; done

if [ -n "$SEED" ]; then
	PC="$ROOT/config/packages.chroot"
	for p in $PKGS; do
		PV=$(ver_of "$p")
		for old in "$PC/${p}"_*_all.deb; do
			[ -e "$old" ] && [ "$(basename "$old")" != "${p}_${PV}_all.deb" ] && { echo "SUPERSEDED $(basename "$old")"; mkdir -p "$PC/superseded"; mv -n "$old" "$PC/superseded/"; }
		done
		cp -f "$DEBDIR/${p}_${PV}_all.deb" "$PC/"
		echo "SEEDED ${p}_${PV}_all.deb"
	done
	( cd "$PC" && sha256sum -- *.deb > SHA256SUMS && sha256sum -c --quiet SHA256SUMS && echo "SHA256SUMS: $(wc -l < SHA256SUMS) debs OK" )
fi
