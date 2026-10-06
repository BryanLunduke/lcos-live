# LCOS 0.9 track opened (2026-10-06 CT)

Repo layout: `BryanLunduke/lcos-live` is ONE recipe tree tracked over time
(repo root = live-build recipe). `master` now carries 0.9. Official 0.8 is
frozen on branch `lcos-0.8` (= b2f8abe + d59b293, the image-name that baked
`lcos-live-08-04`). Working tree: `/workspace/lcos-live-09` (git clone).

## Identity
`auto/config` iso-volume `LCOS 0.9`, image-name `lcos-live-09-01`;
os-release/issue/Calamares branding 0.9 (includes.chroot, hook 8900,
lcos-base 0.9-1 package payload).

## Fix 1: AMD GPUs use modesetting + glamor (lcos-base 0.9-1)
Files (package payload, so apt upgraders get them):
- `/usr/share/X11/xorg.conf.d/05-lcos-amdgpu-modesetting.conf`
  OutputClass `MatchDriver "amdgpu"` -> `Driver "modesetting"`,
  `Option "AccelMethod" "glamor"`.
- `/usr/share/X11/xorg.conf.d/15-lcos-amdgpu-hotplug.conf`
  `Option "HotplugDriver" "modesetting"` for hot-plugged amdgpu GPUs.

Why /usr/share and not /etc (verified in XLibre 25.1.9 source,
`hw/xfree86/common/xf86Config.c` + `xf86platformBus.c`): the server opens
`/usr/share/X11/xorg.conf.d` BEFORE `/etc/X11/xorg.conf.d`;
`xf86OutputClassDriverList()` appends matched drivers in config order and the
first driver to probe claims the GPU ("the module from the first Driver entry
will be enabled", xorg.conf(5)). An `/etc` OutputClass would land after
`10-amdgpu.conf` and lose. `05-` sorts before `10-amdgpu.conf`. HotplugDriver
is the opposite (`xf86PlatformFindHotplugDriver` keeps the LAST match), hence
the separate `15-` file. Per-machine opt-out: a `Device` section with
`Driver "amdgpu"` in `/etc/X11/xorg.conf.d/` (see comment in the file).
`xserver-xlibre-video-amdgpu` stays installed (harmless fallback). Mesa,
xfwm4 compositing and LIBGL settings are untouched.

## Fix 2: one Plymouth quitter + LightDM after elogind
Quitters found (0.8-04 chroot + recipe):
1. LightDM built-in (`src/seat-local.c`): `plymouth deactivate` when X takes
   the VT, `plymouth quit --retain-splash` on X ready, plain quit on X stop or
   when no display replaces Plymouth. **KEPT, the single quitter.**
2. `/etc/init.d/plymouth start` (`plymouth quit --retain-splash`, runs after
   `$all`, i.e. right after lightdm forks). **Disabled** via
   `/etc/insserv/overrides/plymouth` (empty Default-Start; Default-Stop 0 6
   kept so the shutdown splash still works) shipped in lcos-base 0.9-1;
   postinst re-runs update-rc.d.
3. `/usr/lib/lcos/lcos-display-fix` (`plymouth quit`, run twice as LightDM
   greeter-setup and session-setup script; 0.8 "hold Plymouth until X"
   polish). **Removed** the quit; script still seeds .Xauthority/xhost.
   Shipped in lcos-branding 0.9-1 (0.7-1 as built never contained it; on 0.8
   it was ISO-only) and in includes.chroot (identical copy).
4. 0.7-era `/usr/lib/lcos/plymouth-quit-greeter` (`plymouth quit`): already a
   wrapper for lcos-display-fix in src; lcos-branding 0.9-1 ships the wrapper,
   so 0.7 upgraders lose that quit too.
5. initramfs `scripts/panic/plymouth` (only on initramfs panic, to show the
   rescue shell): left alone (not part of normal boot).

LightDM ordering: `/etc/insserv/overrides/lightdm` adds `elogind seatd` to
Should-Start (insserv.conf has no `$x-display-manager` facility, so elogind's
`X-Start-Before: $x-display-manager` was a no-op and `.depend.start` had
`lightdm: dbus` only). Result: `lightdm: elogind seatd`; rc2.d
S01seatd, S02elogind, S03lightdm; no S plymouth link; K01plymouth in rc0/rc6.

`quiet splash` stays on the normal boot cmdline.

## Bake lcos-live-09-01 (2026-10-06 CT)
- Bake tree `/tmp/lcos-live-09`. `local/live-build/scripts/build/` now carries
  binary_grub_cfg, binary_linux-image, binary_grub-efi plus symlinks
  `efi-image` / `grub-cpmodules` -> `/usr/lib/live/build/` (binary_grub-efi
  copies them from its own dir; the first bake failed without them).
- ISO `lcos-live-09-01.iso` 1427341312 bytes, SHA256
  c966216903de884e0dc51bd66a7ec9451e1f89cae28216a20b24696b3cd4433c,
  prerelease https://github.com/BryanLunduke/lcos-testing/releases/tag/lcos-live-09-01
- Verified in squashfs: rc2.d S01seatd S02elogind S03lightdm, no S plymouth,
  K01plymouth in rc0/rc6; `.depend.start` `lightdm: elogind seatd`;
  05-/15- lcos amdgpu snippets in /usr/share/X11/xorg.conf.d.
- OutputClass precedence proven in QEMU (-vga std, bochs-drm): a 05- file
  saying fbdev beat a 10- file saying modesetting ("Matched fbdev as
  autoconfigured driver 0", FBDEV(0) claimed the device). Same ordering puts
  05-lcos-amdgpu-modesetting ahead of 10-amdgpu.conf on AMD.
- LightDM log on every boot: "Plymouth is running on VT 1 ... not replacing
  it" -> "Quitting Plymouth" (the only quit).
