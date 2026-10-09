# lcos-base 0.9.1-3 (overlay) vs 0.9.1-2 (091-01 ISO)

2026-10-09 CT, editor decision.

- **The lcos-live-091-01 ISO ships lcos-base 0.9.1-2** (SHA256 bdb5d70ca9b08efdfee85cf12a377670b000ad19920684c5006c33b8af723a20). The ISO is not rebuilt.
- **The LCOS 0.9.1 apt overlay ships lcos-base 0.9.1-3** (SHA256 a06ab4d76b21740d48bfe154b73df34f41d95e240ff8882b16d404428ea2c628). config/packages.chroot now seeds -3 for any later bake.
- Only change: `eject, cifs-utils, keyutils` moved from Depends to Recommends (control Depends, Recommends and Description text, plus changelog). Every installed file is byte-identical to 0.9.1-2.
- Why: the Updates tool runs plain `apt-get -s upgrade`, then `apt-get install --only-upgrade <reviewed pins>`. That never installs new packages, so with the three packages in Depends it kept lcos-base back on 0.8 systems. With Recommends, lcos-base upgrades normally.
- Caveat: LCOS sets `APT::Install-Recommends "false"` (/etc/apt/apt.conf.d/00recommends), so upgraded 0.8 systems still do not get eject, cifs-utils or keyutils automatically. ISO installs (0.9, 0.9.1) already have them from the package lists.
- Tags: `lcos-base/0.9.1-2` and `lcos-0.9.1-release` (the ISO, 403714f2) are unchanged. `lcos-base/0.9.1-3` marks this commit.
