#!/bin/bash
# Build the LCOS 0.9 system overlay debs touched for 0.9 (unsigned):
#   lcos-base 0.9-1      (identity 0.9, amdgpu->modesetting xorg snippets,
#                         insserv overrides for lightdm/plymouth)
#   lcos-branding 0.9-1  (lcos-display-fix without plymouth quit)
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
	for x in usr/local/sbin/lcos-write-os-release usr/lib/lcos/lcos-display-fix usr/lib/lcos/plymouth-quit-greeter; do
		[ -f "$root/$x" ] && chmod 0755 "$root/$x"
	done
	local out="$DEBDIR/${name}_${ver}_all.deb"
	rm -f "$out"
	fakeroot dpkg-deb --root-owner-group -Zxz --build "$root" "$out" >/dev/null
	echo "BUILT $out $(sha256sum "$out" | cut -d' ' -f1)"
}

build lcos-branding 0.9-1
build lcos-base 0.9-1
