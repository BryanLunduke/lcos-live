#!/bin/bash
# Build the LCOS 0.9.2 system overlay debs (unsigned), all at 0.9.2-1 (version
# bump only from 0.9.1): lcos-base (identity 0.9.2; Recommends eject,
# cifs-utils, keyutils as 0.9.1-3; 0.9.2-2 drops the AMD DDX override #115/#118),
# lcos-branding, lcos-desktop-config, lcos-appimage-thumbnailer,
# lcos-archive-keyring (key unchanged), lcos-desktop, lcos-theme-clearlooks,
# lcos-zork.
# Copied from build-091-system-debs.sh. Usage:
#   packaging/build-092-system-debs.sh [--seed] [--only pkg[,pkg...]]
# --seed copies the debs into config/packages.chroot, removes older versions
# of the same packages there, and rewrites SHA256SUMS for every top-level deb.
# Builds straight from packaging/src/<pkg> (does NOT regenerate src from
# config/includes.chroot like build-overlay-debs.sh). Editor signs later.
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
	[ -f "$root/DEBIAN/conffiles" ] && chmod 0644 "$root/DEBIAN/conffiles"
	for s in postinst postrm preinst prerm; do
		[ -f "$root/DEBIAN/$s" ] && chmod 0755 "$root/DEBIAN/$s"
	done
	find "$root" -path "$root/DEBIAN" -prune -o -type d -exec chmod 0755 {} +
	# executables we ship
	for x in usr/local/sbin/lcos-write-os-release usr/lib/lcos/lcos-display-fix usr/lib/lcos/plymouth-quit-greeter usr/bin/lcos-appimage-thumbnailer; do
		[ -f "$root/$x" ] && chmod 0755 "$root/$x"
	done
	local out="$DEBDIR/${name}_${ver}_all.deb"
	rm -f "$out"
	fakeroot dpkg-deb --root-owner-group -Zxz --build "$root" "$out" >/dev/null
	echo "BUILT $out $(sha256sum "$out" | cut -d' ' -f1)"
}

VER=0.9.2-1
BASEVER=0.9.2-5
ver_of() { [ "$1" = lcos-base ] && echo "$BASEVER" || echo "$VER"; }
PKGS="lcos-branding lcos-base lcos-desktop-config lcos-appimage-thumbnailer lcos-archive-keyring lcos-desktop lcos-theme-clearlooks lcos-zork"
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
			[ -e "$old" ] && [ "$(basename "$old")" != "${p}_${PV}_all.deb" ] && { echo "REMOVE $(basename "$old")"; rm -f "$old"; }
		done
		cp -f "$DEBDIR/${p}_${PV}_all.deb" "$PC/"
		echo "SEEDED ${p}_${PV}_all.deb"
	done
	( cd "$PC" && sha256sum -- *.deb > SHA256SUMS && sha256sum -c --quiet SHA256SUMS && echo "SHA256SUMS: $(wc -l < SHA256SUMS) debs OK" )
fi
