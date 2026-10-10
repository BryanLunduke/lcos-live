# gvfs-backends for LCOS 0.9.2 (Thunar SMB browsing)

2026-10-09 CT, editor approved.

- User report: Thunar Preferences > Advanced warned that GVFS network support was missing, despite 0.9's SMB support (cifs-utils + LLK CIFS). `sudo apt install gvfs-backends` fixed it; SMB shares then showed in Thunar.
- ISO: `gvfs-backends` added to config/package-lists/desktop.list.chroot next to gvfs (reverses the 2026-09-19 omission).
- lcos-base 0.9.2-3 (SHA256 b868c3e72f3233c906e0a889d51efa80d6e1e6ea59d8f0bd296bd37d171ca063): `gvfs-backends` added to **Recommends**, not Depends. No installed files change except the changelog.

## Why Recommends, not Depends

The Updates tool (lcos-updates src/helper.cpp) simulates plain `apt-get -s upgrade`, then installs exactly that set with `apt-get install --only-upgrade <name=version pins>`. Packages that upgrade would keep back are only probed and reported, never installed. A new hard Depends would therefore keep lcos-base 0.9.2-3 back on 0.8/0.9/0.9.1 systems, and with it the 0.9.2 identity and the #115/#118 AMD override removal. With APT::Install-Recommends "false", a Recommends does not hold lcos-base back, but it is not installed automatically either.

No packaging-only approach can make the current Updates tool install a new package. Result: ISO installs of 0.9.2 get gvfs-backends; upgraded systems get lcos-base 0.9.2-3 cleanly, but need `sudo apt install gvfs-backends` (release notes) unless lcos-updates is changed to also install kept-back packages that add only new packages with no removals (`upgrade --with-new-pkgs` semantics). That would be an editor decision and would take effect from the run after the new lcos-updates is installed.

## Dependency pull (apt-simulated on the 0.9.1-01 package DB, Install-Recommends false)

16 new packages, all Devuan excalibur stable, no systemd, no Samba server: gvfs-backends 1.57.2-2+deb13u1, samba-libs / libsmbclient0 2:4.22.11+dfsg-0+deb13u1, libldb2, libtevent0t64, liblmdb0, libgoa-1.0-0b + libgoa-1.0-common (GNOME Online Accounts library only, no daemon), libgdata22 + libgdata-common, libmsgraph-1-1, libcdio19t64, libcdio-cdda2t64, libcdio-paranoia2t64, libavahi-glib1, psmisc. gvfs-backends is in Devuan stable, so it is not copied into the LCOS overlay.

## Simulated Updates runs (overlay staging with lcos-base 0.9.2-3)

- 0.9.1-01 DB (lcos-base 0.9.1-2): 11 upgraded, 0 new, 0 removed, 0 kept back; lcos-base -> 0.9.2-3.
- 0.8-04 DB (lcos-base 0.7-2): 28 upgraded, 0 new, 0 removed, 0 kept back; lcos-base -> 0.9.2-3.
