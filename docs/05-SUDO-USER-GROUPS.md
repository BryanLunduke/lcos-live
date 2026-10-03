# Install user sudo group (2026-09-14)

**Bug:** Fresh Calamares installs could not `sudo` (e.g. `sudo apt update`)
because `users.conf` had no `defaultGroups`, so the created user was not in
`sudo`. Devuan already grants `%sudo` in `/etc/sudoers`.

**Fix:** `config/includes.chroot/etc/calamares/modules/users.conf` now lists
`sudo` (and common device groups) in `defaultGroups`. No `sudoersGroup` key
(avoid duplicate `/etc/sudoers.d/10-installer`).

**Existing installs:** as root, `usermod -aG sudo <username>` then re-login.
