# XLibre from-source rebuild (LCOS 0.3)

Rebuilt 2026-08-25 (America/New_York) for this 0.3 recipe only.
**Not** added to the already-signed `packaging/apt-repo/` (that would
invalidate InRelease / Release.gpg). **Not** a user-facing apt source.
Bake installs these from `config/packages.chroot/`; the same bytes live
in `packaging/debs/xlibre/`.

Rollback of the previous vendored 25.0.0.12 / 7.8+4 set is under
`packaging/debs/xlibre-25.0.0.12-vendor/`.

No ISO was baked. Nothing was uploaded. `xlibre-deb.github.io` was not
added. LCOS-Branding was not used.

## Build environment

| Item | Value |
|------|-------|
| Method | Devuan Excalibur amd64 **chroot** (not a Trixie host build) |
| Bootstrap | `debootstrap --variant=minbase` using helper `lcos-live-03/helpers/debootstrap-excalibur` |
| Mirror | `http://ftp.fau.de/devuan/merged` |
| Keyring | `/usr/share/keyrings/devuan-archive-keyring.gpg` (devuan-keyring 2026.01.13) |
| Chroot libc | `libc6` 2.41-12+deb13u3 (Excalibur). Depends use `libc6 (>= 2.38)` or shlibdeps; nothing newer than Excalibur. |
| Toolchain | gcc 14.2.0, meson 1.7.0, ninja 1.12.1 |
| Maintainer | LCOS <lcos@lunduke.com> |
| Signing | **UNSIGNED** (`dpkg-deb --build`) |
| Server meson | `--buildtype=release`, `-Dxorg=true`, Xephyr/Xnest/Xvfb/xfbdev off, `-Dsystemd_logind=false`, `-Dseatd_libseat=true`, `-Dlegacy_nvidia_padding=false` |

Work lived under `/workspace/lcos-live-03` and `/tmp` (chroot `/tmp/excalibur-xlibre`, sources `/tmp/xlibre-build`). `/workspace/lcos-live` (0.2) was not touched.

## ABI (from xlibre-xserver-25.1.9)

Read after `ninja install` from `xorg-server.pc` and
`hw/xfree86/common/xf86Module.h`.

| Variable | Value | Notes |
|----------|-------|--------|
| `abi_xinput` | **26.0** | pkg-config + header `ABI_XINPUT_VERSION` |
| `abi_videodrv` (active) | **28.0** | `legacy_nvidia_padding=false` → `SET_ABI_VERSION(28, 0)` |
| pkg-config `abi_videodrv` raw | `28.128.0` | meson awk matches both `#ifdef` lines in `xf86Module.h` and concatenates `28.1`+`28.0`. **Ignored.** Provides use major **28**. |
| module dir | `/usr/lib/xorg/modules/xlibre-25` | 25.1 ABI tag (was `xlibre-25.0` on 25.0.0.12) |

`xserver-xlibre-core` Provides: `xorg-input-abi-26`, `xorg-video-abi-28`,
`xorg-video-abi-25` (NVIDIA compat, same as the old 25.0.0.12 package),
`xserver-xorg-core (= 2:21.98)`, `xserver-xorg-video-modesetting`.

Drivers Depend on those ABI virtuals plus `xserver-xlibre-core (>= 2:25.1.9)`.

## Git tags (shallow clone `--depth 1 --branch TAG`, not master)

| Repo | Tag | Commit |
|------|-----|--------|
| [X11Libre/xserver](https://github.com/X11Libre/xserver) | **xlibre-xserver-25.1.9** | `f844d7a86c10fd5cc89083e7daf97b862b8ca1fd` |
| [X11Libre/xf86-input-libinput](https://github.com/X11Libre/xf86-input-libinput) | xlibre-xf86-input-libinput-25.0.1 | `4eb6691efeef4969a05b1d6b77d980943fb9760e` |
| [X11Libre/xf86-video-amdgpu](https://github.com/X11Libre/xf86-video-amdgpu) | xlibre-xf86-video-amdgpu-25.1.2 | `8b491b5a07064d9d8f849c51c9dd8354706a2337` |
| [X11Libre/xf86-video-ati](https://github.com/X11Libre/xf86-video-ati) | xlibre-xf86-video-ati-25.0.1 | `e192d6a87495e3b91a1c85c3a2243def23abecd7` |
| [X11Libre/xf86-video-fbdev](https://github.com/X11Libre/xf86-video-fbdev) | xlibre-xf86-video-fbdev-25.0.0 | `b69995d4da347283400d9cc185eeda041288c9da` |
| [X11Libre/xf86-video-nouveau](https://github.com/X11Libre/xf86-video-nouveau) | xlibre-xf86-video-nouveau-25.0.1 | `6cfa57f1eeb19a9a09f0aaea49d5cf24a37905ee` |
| [X11Libre/xf86-video-vesa](https://github.com/X11Libre/xf86-video-vesa) | xlibre-xf86-video-vesa-25.0.0 | `850ec6dc643bf18d9011770b5b6fef7edfb927ce` |
| [X11Libre/xf86-video-vmware](https://github.com/X11Libre/xf86-video-vmware) | xlibre-xf86-video-vmware-25.0.0 | `3580a57072304cecdf256733acfba1dc11cd366d` |

No `xf86-video-radeon` repo (radeon lives in ati). No invented tags.
No intel/qxl/legacy tail. 25.2.2 was not used.

## Package table

| Package | Version | Tag | ABI | Bytes | SHA256 | Status |
|---------|---------|-----|-----|------:|--------|--------|
| xserver-xlibre-core | 2:25.1.9-1+lcos1 | xlibre-xserver-25.1.9 | provides input-26 / video-28 | 1553512 | e34b86d703cf851988f799f9bd125ad98a48a5ff28bdfe459010806cbb2f3821 | ok |
| xserver-xlibre-common | 2:25.1.9-1+lcos1 | xlibre-xserver-25.1.9 | n/a | 16488 | 476bb5fcc91db89958811388c7c0992fb0b49b8110b19b4eecad14e5b5f2ad0a | ok |
| xserver-xlibre | 1:25.1.9-1+lcos1 | metapackage | n/a | 1380 | a460c0c5ace3e037ebf3edff1717c1fbcfdaaeb198edb37ad3403fb2c7217760 | ok |
| xlibre | 1:25.1.9-1+lcos1 | metapackage | n/a | 1476 | e0d8ddda1cda7493aff3ef736176238b747469890cb9b8dd98929c6e420f274c | ok |
| xlibre-x11-common | 1:25.1.9-1+lcos1 | session scripts (see notes) | n/a | 18392 | 2f977684848deb6861d1d85cbbcc53a5d0c993f950f428ac45e6420355c15156 | ok |
| xserver-xlibre-input-libinput | 25.0.1-1+lcos1 | xlibre-xf86-input-libinput-25.0.1 | input-26 | 43408 | 117afb33c0bbc2ac538beed60db7cea17b2b8425a08fcc1d6f41ce45f87ea2ec | ok |
| xserver-xlibre-input-all | 1:25.1.9-1+lcos1 | metapackage (Depends: libinput) | n/a | 1372 | f9f97b32ea398c363f9f844b4a91cca1b958207535b7ecbcf49277c0c709b77d | ok |
| xserver-xlibre-video-amdgpu | 25.1.2-1+lcos1 | xlibre-xf86-video-amdgpu-25.1.2 | video-28 | 71612 | 3e03da6ec399fadcf588f55f61504b3fc13124cbd770b153811b8afbd2bd5c67 | ok |
| xserver-xlibre-video-ati | 1:25.0.1-1+lcos1 | xlibre-xf86-video-ati-25.0.1 | video-28 | 146972 | d6dbccaea6995a0fb88fa3c0f4efd4aef92bbf4d384672ef40195c88831f421a | ok (ati+radeon) |
| xserver-xlibre-video-fbdev | 1:25.0.0-1+lcos1 | xlibre-xf86-video-fbdev-25.0.0 | video-28 | 10400 | d3e287036d8ec34495e8b261e72b7781d99a5331937c73c466d8db66a2b66389 | ok |
| xserver-xlibre-video-nouveau | 1:25.0.1-1+lcos1 | xlibre-xf86-video-nouveau-25.0.1 | video-28 | 85232 | b9d8acb02f60f8c9dcd74d6adcf7d27558b5e29ba53cbbb8e7eab8473ebd027d | ok |
| xserver-xlibre-video-vesa | 1:25.0.0-1+lcos1 | xlibre-xf86-video-vesa-25.0.0 | video-28 | 12708 | 6edf0cfd6c242759592e23b8bd74594fd320e12aa31c2f5f45fb09823a1c08e9 | ok |
| xserver-xlibre-video-vmware | 1:25.0.0-2+lcos1 | xlibre-xf86-video-vmware-25.0.0 | video-28 | 72620 | a5a920a8ad076458e06e5d5b7304e64856477e4a0d2fa75f1830c0d129ca6011 | ok (vmwgfx/KMS) |
| xserver-xlibre-video-all | 1:25.1.9-1+lcos1 | metapackage | n/a | 1416 | ee84ab83cb0a757325f3cbb45d6696b5cfc4e088dedc465eb77305f01e108fbb | ok |

`config/package-lists/xlibre.list.chroot` still lists names only so `lb`
installs these debs. Epochs kept where the old package had them (server
epoch 2; ati/fbdev/nouveau/vesa/vmware epoch 1) so versions sort newer
than 2:25.0.0.12-1 / 1:7.8+4 / 1:22.0.0.3-1.

## What failed / skipped / notes

| Item | Result |
|------|--------|
| Server 25.1.9 | Built (meson). `XLibre X Server 1.25.1.9` reported by `Xorg -version`. |
| libinput 25.0.1 | Built (meson) into `…/xlibre-25/input/libinput_drv.so`. |
| amdgpu 25.1.2 | Built (meson). Default meson `moduledir` is `xorg/modules`; rebuilt with `-Dmoduledir=xorg/modules/xlibre-25` so it matches the 25.1 loader path. |
| ati 25.0.1 | Built (autotools) against 25.1.9 ABI. **No 25.1 tag exists**; 25.0.1 is the latest xlibre tag and it compiled. Ships **both** `ati_drv.so` and `radeon_drv.so` in this one package (no invented xf86-video-radeon repo/package). Old 25.0.0.12 ati wrapper depended on a missing `xserver-xlibre-video-radeon`. |
| fbdev / nouveau / vesa | Built (autotools). |
| vmware 25.0.0 | Rebuilt 2026-08-25 (ET) with vmwgfx/KMS as `1:25.0.0-2+lcos1`. This tag’s `configure.ac` never assigns `BUILD_VMWGFX=yes` (no `--enable-vmwgfx` flag). Forced with `export BUILD_VMWGFX=yes` before `./configure --with-xorg-module-dir=/usr/lib/xorg/modules/xlibre-25 --enable-vmwarectrl-client`. libdrm / xatracker / libudev already present in the Excalibur chroot; configure printed “whether to build Kernel Mode Setting and 3D: yes” and `config.h` has `#define BUILD_VMWGFX 1`. Stripped `vmware_drv.so` is 178584 B (2D-only was 65224 B) and links libxatracker2 / libdrm2 / libeudev1. Also ships `vmwarectrl`. Old 2D deb kept as `packaging/debs/xlibre/xserver-xlibre-video-vmware_25.0.0-1+lcos1.2d-only.deb`. No `xlibre-xf86-video-vmware-25.1.*` tag exists (only 25.0.0). |
| intel, qxl, evdev, wacom, … | Skipped (not needed; video-all Depends only on drivers actually built). |
| Xephyr / Xvfb / Xnest / -dev / -dbgsym / -legacy | Not packaged. |
| xlibre-x11-common files | Session infrastructure (`Xsession`, `Xsession.d`, `rgb.txt`, init script) reused from the old 7.8+4 vendor package (not ABI-dependent; xserver source does not ship them). Repackaged 1:25.1.9-1+lcos1. Dropped the old `changelog.xorg.old.gz`, which is why the deb is ~18 KiB vs ~215 KiB. |
| Trixie host build | Not used. Host `apt` on Trixie had a security/base version skew (`libxfont2` 1:2.0.6-1+deb13u1 vs -dev 1:2.0.6-1+b3); Excalibur chroot avoided that. |
| Install test | In the Excalibur chroot: all 13 runtime/meta debs (everything except the `xlibre` fonts/apps metapackage) `dpkg -i` + configure together. `dpkg -C` clean. `xlibre-x11-common` Conflicts/Provides `x11-common` as designed (had to remove Debian `x11-common` first in the build chroot because `keyboard-configuration` had pulled it). No leftover Depends on 25.0.0.12 packages. |

## video-all Depends (built set)

`xserver-xlibre-video-amdgpu, xserver-xlibre-video-ati, xserver-xlibre-video-fbdev, xserver-xlibre-video-nouveau, xserver-xlibre-video-vesa, xserver-xlibre-video-vmware`

## Module layout on disk

```
/usr/lib/xorg/modules/xlibre-25/
  libglamoregl.so libexa.so libfbdevhw.so libint10.so
  libshadow.so libshadowfb.so libvgahw.so libwfb.so
  extensions/libglx.so
  drivers/modesetting_drv.so          (from core)
  drivers/{amdgpu,ati,radeon,fbdev,nouveau,vesa,vmware}_drv.so
  input/libinput_drv.so
  input/inputtest_drv.so              (from core; unused)
```

xlibre-debian `debian/` from `xlibre-debian/xlibre-server` was inspected as a
**template** only (file split, Provides). Their apt source was not added.

## SHA256SUMS

See `packaging/debs/xlibre/SHA256SUMS` (same bytes as `config/packages.chroot/`).

## Update: 25.1.11-1+lcos1 (2026-11-04, America/Chicago)

Rebuilt from tag **xlibre-xserver-25.1.11** (`ec1f2d37daa1450d8452abb547de4546321d7bb9`) with the
recipe above; only tag and version changed. Excalibur chroot re-created over HTTPS
(`https://ftp.fau.de/devuan/merged`; plain HTTP is blocked from the build box) with
libc6 2.41-12+deb13u4. Meson needs `--libdir=lib` to keep `/usr/lib/xorg/modules/xlibre-25`
(default would be the multiarch path). ABI unchanged (input 26.0, video 28.0, ext 11.0), so the
drivers were **not** rebuilt. Details and SHA256s: `config/packages.chroot/SEED-xlibre-25.1.11-1.txt`.
25.1.9 debs kept in `packaging/debs/xlibre-25.1.9-rollback/`.

| Package | Version | SHA256 |
|---|---|---|
| xlibre-x11-common | 1:25.1.11-1+lcos1 | d399b08e512b3269385ec342e0882ce3edd046717e8242e0c85817985baa3ccc |
| xlibre | 1:25.1.11-1+lcos1 | 9d3521a16007fffa6d57b0f1230f69e9a0ab752d21e999593a161e70215f1330 |
| xserver-xlibre-common | 2:25.1.11-1+lcos1 | 22ef0de657658a2dd9afe1d145dccd51f999ea69d702be14441d88b40b4eeed5 |
| xserver-xlibre-core | 2:25.1.11-1+lcos1 | 97cf1a6fb042e9d2cd3249ae420398a2adaa57d964f199913b0ad6989abbd6b2 |
| xserver-xlibre-input-all | 1:25.1.11-1+lcos1 | 8110eaad5fd06698ec1658a0e7b3464edbafe286e94e5132b324e62e10e3947f |
| xserver-xlibre-video-all | 1:25.1.11-1+lcos1 | e2eb436353f7ea6b75c9f88c94959d5337ee6ee0bf50486cb4f683ceb8c09d6b |
| xserver-xlibre | 1:25.1.11-1+lcos1 | 4aa7391aa6a88f01d6a16eb2e601af616591c81aaf42593ef5385be26adb1f84 |

## Update: 25.1.11-1+lcos3 (2026-11-12, America/Chicago)

LCOS 1.1.0 port of the 1.0.2 #202 hotfix (lcos-live PR #17). Dev/test on
master only. Not baked. No apt publish. No GitHub release. Identity stays
1.1.0 (os-release, issue, Calamares, iso volume are not touched).

The seven server and metapackage debs are the PR #17 `+lcos2` build,
reversioned to `+lcos3`. They were not compiled again. `Xorg` is
byte-identical to that build (BuildID `61c36fb470d674050d83680064715fadb75d5382`).
NEEDED still includes `libnettle.so.8`, `libunwind.so.8`, and `libGL.so.1`.
`strings` has `SingleDriver`. `xorg.conf(5)` documents it. Source is tag
**xlibre-xserver-25.1.11** (`ec1f2d37daa1450d8452abb547de4546321d7bb9`) plus
the two cherry-picks below. Patches: `packaging/xlibre/hotfix-202/`. The
third commit on XLibre PR #1749 (`f06db2d6c`) was not taken. ABI is still
input 26.0 / video 28.0 / extension 11.0, so the drivers were not rebuilt.
`xserver-xlibre-video-amdgpu` SHA256 is still
`3e03da6ec399fadcf588f55f61504b3fc13124cbd770b153811b8afbd2bd5c67`.

| Patch | Upstream commit | What |
|---|---|---|
| `packaging/xlibre/hotfix-202/0001-xfree86-common-introduce-SingleDriver-server-flag.patch` | `54a4b5f670de257c83cdb8b6a743a1592e2e78d4` | SingleDriver server flag |
| `packaging/xlibre/hotfix-202/0002-xfree86-man-add-SingleDriver-server-flag-to-man-page.patch` | `7d7a6c513be268483ecb52ceb341d5600a7878c5` | man page |

The option does nothing unless a config turns it on. That file is
`/usr/share/X11/xorg.conf.d/05-lcos-singledriver.conf` in **lcos-base 1.1.0-4**
(added in 1.1.0-3; `ServerFlags` / `Option "SingleDriver" "on"`). It is not
in the xserver deb. A later ServerFlags section can set it off.

`xserver-xlibre-core` 2:25.1.11-1+lcos3 does not depend on `libegl1`
(`+lcos1` did). Glamor dlopens libEGL through libepoxy. Qt and VLC were
the other packages that pulled it in, so removing either and running
autoremove can drop it. **lcos-base 1.1.0-4** depends on `libegl1`, and
`config/package-lists/xlibre.list.chroot` lists it so the ISO keeps it.

### Why +lcos3

The repo's X revision is `25.1.11-1+lcosN` (epoch 2 on
`xserver-xlibre-core` and `xserver-xlibre-common`, epoch 1 on the
metapackages). `+lcos1` is what master shipped. `+lcos2` is the 1.0.2
hotfix. `dpkg --compare-versions` says `2:25.1.11-1+lcos3` is greater than
`2:25.1.11-1+lcos2`, and the same for epoch 1: after the shared prefix
`1+lcos` the numbers 3 and 2 decide it.

`+lcos1.1` does not sort above `+lcos2`. The number after `lcos` is 1
versus 2, so the `.1` is never compared. A Debian revision of `1.1+lcos1`
does sort above `1+lcos2` (`.` sorts after `+`), but it leaves the
`+lcosN` series this tree has used since 25.1.9. `+lcos3` stays in that
series, so an upgrade from master's `+lcos1` or from the 1.0.2 `+lcos2`
packages selects it.

Control fields that embed the revision (`Version`, `Depends` lower bounds,
`Provides` versions) say `+lcos3`. Payload files are the `+lcos2` files.
`xserver-xlibre-core` and `xserver-xlibre-common` also gain a changelog
stanza for `+lcos3`; their other files match `+lcos2`. The five
metapackage / `xlibre-x11-common` payloads match `+lcos2` entirely.
Previous `+lcos1` debs of these seven packages are in
`packaging/debs/xlibre-25.1.11-1+lcos1-rollback/`.

### Meson command (the one that produced the +lcos2 binaries)

Excalibur chroot, libc6 2.41-12+deb13u4, gcc 14.2.0, meson 1.7.0, ninja
1.12.1. `libunwind-dev` and `nettle-dev` installed. Recorded with the
1.0.2 build and not re-run for `+lcos3`:

```
meson setup /tmp/xlibre-build \
  --prefix=/usr \
  --libdir=lib \
  --buildtype=release \
  -Dxorg=true \
  -Dxephyr=false \
  -Dxnest=false \
  -Dxvfb=false \
  -Dxfbdev=false \
  -Dglamor=true \
  -Dudev=true \
  -Dudev_kms=true \
  -Dsystemd_logind=false \
  -Dseatd_libseat=true \
  -Dlegacy_nvidia_padding=false \
  -Dxcsecurity=true \
  -Dlibunwind=true \
  -Dsha1=libnettle \
  -Ddocs=true \
  -Ddevel-docs=false \
  -Ddocs-pdf=false
```

`-Dsha1=libnettle` and `-Dlibunwind=true` are explicit: sha1 `auto` prefers
libmd when `libmd-dev` is present, and libunwind defaults to false.

### XLibre PR #4080 is not in this build

[X11Libre/xserver#4080](https://github.com/X11Libre/xserver/pull/4080)
merged to `release/25.1` on 2026-11-12 (merge
`c66273f7b623b7eba3e5b7cf958794673c918525`, patch commit
`6f3d19537721929b639d69739bb0873fdcc0747b`). It deletes `libxserver_glx`
from `xorg_link` in `hw/xfree86/meson.build`, reverting
`2e425acb3514e637cfdd8a3f93ae140976069992`. That is the fix for the crash
in X11Libre issue #4076 (AMD Radeon 9070 / 9060 XT). It is one line, and
it applies on top of 25.1.11.

It is not in these debs. The `+lcos2` binary still links `libGL.so.1`
because of `2e425acb3`, and that link was left as upstream 25.1.11 shipped
it. Taking #4080 means compiling Xorg again. That would no longer be the
PR #17 build, and it would change NEEDED and the shlibdeps line. A later
1.1 rebuild can take the revert. It was not added to the 1.0.2 hotfix.

| Package | Version | SHA256 |
|---|---|---|
| xlibre-x11-common | 1:25.1.11-1+lcos3 | c5d9fb765810145720afaba0989d23654c0c0d59ba5d2717907af655a168067e |
| xlibre | 1:25.1.11-1+lcos3 | d84b0094229d7a7e18bece2efd48297434c5c3ff945678be109c0343f829ed06 |
| xserver-xlibre-common | 2:25.1.11-1+lcos3 | 430fc544b28fb06f05baef46c9dd3e420114eca2817dbed57b23ebda44fc01c3 |
| xserver-xlibre-core | 2:25.1.11-1+lcos3 | 8eec6ac88bf66ba58aaf813ec12a6158fc685bbf31e3aade1b73a2e902c4717e |
| xserver-xlibre-input-all | 1:25.1.11-1+lcos3 | 9fee90c3afcbbb06f1d26f48487a291517789e533aaa5e5ac1990ef0453acb1f |
| xserver-xlibre-video-all | 1:25.1.11-1+lcos3 | 65c8f0db13a899d03cb5b905adf675bb217240bb085c188442ec15671a7eddd5 |
| xserver-xlibre | 1:25.1.11-1+lcos3 | 347fd4172a690e86fa3e36de550ce8de1c1e40ddc98608c1b24670ceb947d04a |
| lcos-base | 1.1.0-4 | d7ffe03ebad0eaabc04474edb4536e119252d9c5cff2d83a622ff7f4f0bd70f0 |
