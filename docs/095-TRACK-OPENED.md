# LCOS 0.9.5 track opened (2026-10-16 CT)

Re-applied 2026-10-16 CT on top of the reset to 0.9.4 (see "Reset 0.9.5 track to 0.9.4 release");
the first 0.9.5 history is kept on branch `backup/095-pre-reset` (a9b46ab).

Version bump only. No feature work in this open.

## Working tree
`/workspace/lcos-live-095` tracks `master` (0.9.5); `/workspace/lcos-live-094` is frozen at 0.9.4
(branch `lcos-0.9.4`, hotfixes only).

## 0.9.4 freeze
- Official LCOS 0.9.4 ISO: `lcos-live-094-05` (1516290048 bytes, SHA256
  aa888839d5b3ad443b2dc10ebb46dc0d4fe8594d860f79e421ba6abea987d56d).
- Tag `lcos-0.9.4-release` = branch `lcos-0.9.4` = `0cc29fbf`.
- Package tags `<pkg>/0.9.4-1` and `lcos-base/0.9.4-7` at `0cc29fbf`.
- Signed apt overlay live at lcosrepo1 `efca16a6` (Release SHA256 447475ef).

## Identity
`auto/config` iso-volume `LCOS 0.9.5`, image-name `lcos-live-095-01`; os-release, issue,
issue.net, Calamares branding, hook 8900, lcos-write-os-release.
The 0095 initramfs hook is kept byte-for-byte as in 0.9.4 (its log text still says 0.9.4).
Not changed: the lcos-base payload (os-release files), which goes with the 0.9.5 system debs.

## Kernel and apps
- LLK 7.2.6-lcos25 unchanged.
- Apps stay at the 0.9.4 set (Edit 0.9.4-2, Paint 0.9.4-9, City 0.9.4-8, About 0.9.4-8, Updates 0.9.4-7).
- System debs stay at 0.9.4 (lcos-base 0.9.4-7, the other seven 0.9.4-1). No package versions bumped.

## Rules for this open
No bake and no apt publish until Ted or the editor say go.

## Re-applied after the reset (2026-10-16 CT)
- lcos-base 0.9.5-3: reboot-required dpkg file trigger (r15 U-1), #112 HOME=/ fix, identity 0.9.5.
  Same payload as 0.9.5-2; new version because 0.9.5-1 and 0.9.5-2 were already tagged.
- lcos-desktop-config 0.9.5-1 (#143 lid suspend), the tagged deb reused byte-for-byte.
- Apps re-seeded byte-for-byte: Updates 0.9.5-1, About 0.9.5-2, City 0.9.5-1, Paint 0.9.5-1.
- Kernel: LLK 7.2.6-lcos25 stays seeded; the kernel package list and the 0095 hook are as in 0.9.4.
  lcos27 is seeded only after its PR is merged.
- Not re-applied: the per-build kernel naming experiment (kernel tag after lcos25) and its recipe changes.
