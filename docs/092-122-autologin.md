# #122: the installer ignores "Log in automatically" (fixed in the 0.9.2 recipe)

2026-10-09 CT. Recipe-only fix. No package changed.

## Where
- Script: `config/includes.chroot/usr/lib/lcos/lcos-calamares-fix-lightdm`, a recipe
  include. No lcos-* package ships it.
- Called by: `config/includes.chroot/etc/calamares/modules/shellprocess.conf`, as
  `/usr/lib/lcos/lcos-calamares-fix-lightdm ${USER}`, in the target chroot.
- Exec order (settings.conf): ... users, displaymanager, ..., shellprocess, ... umount.
- users.conf: `doAutologin: true`, so the box is ticked by default.

## Cause
Since #89 (0.8) the script always wrote `autologin-user=$USER` and
`autologin-user-timeout=0` into `/etc/lightdm/lightdm.conf.d/50-lcos.conf`, whatever
the user chose.

## What Calamares 3.3.14 writes (displaymanager main.py, DMlightdm.set_autologin)
It rewrites every line containing `autologin-user=` in the target's
`/etc/lightdm/lightdm.conf` to:
- `autologin-user=<user>` when the box is ticked
- `#autologin-user=` when it isn't

The stock lightdm.conf has `#autologin-user=` in `[Seat:*]`. Calamares also prepends a
second `[Seat:*]` header because its header check always fails (the lines it compares
still end in newlines). That is upstream behaviour and harmless.

## Fix
The script now takes the choice from Calamares' own output. It is ON only if the
target's lightdm.conf has an uncommented `autologin-user=<name>` naming a real target
user other than `lcos` or `root`. `$1` is only a cross-check: if it differs, the
lightdm.conf user is used and a note is printed.
- ON: 50-lcos.conf gets `autologin-user=<user>` and `autologin-user-timeout=0`, plus
  `user-session=xfce` and `greeter-session=lightdm-gtk-greeter`.
- OFF: 50-lcos.conf keeps only the session and greeter lines. Every active
  `autologin-user` and `autologin-user-timeout` line is removed from
  /usr/share/lightdm/lightdm.conf.d, /etc/xdg/lightdm/lightdm.conf.d,
  /etc/lightdm/lightdm.conf.d and /etc/lightdm/lightdm.conf. Commented lines are kept.
- `autologin-session` is left alone (LCOS never adds it). LightDM's
  `lightdm-autologin` PAM has no group check and LCOS sets no `autologin-group`,
  so group membership doesn't matter.
- The self-checks are kept, and the S0x to S20 lightdm rc rename (#89) is unchanged.

## Live session
Unchanged. `etc/lightdm/lightdm.conf.d/50-lcos.conf` still says
`autologin-user=lcos`, and the script runs only from Calamares shellprocess in the target.

## Implications
The fix reaches users only through a new ISO (0.9.2). Existing installs that
deliberately turned autologin off are not changed by Updates. Workaround:
`sudo sed -i '/^autologin-user/d' /etc/lightdm/lightdm.conf.d/50-lcos.conf`
