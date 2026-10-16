# LCOS 0.9.5 track opened (2026-10-16 CT)

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
issue.net, Calamares branding, hooks 0095 and 8900, lcos-write-os-release.
Not changed: the lcos-base payload (os-release files), which goes with the 0.9.5 system debs.

## Kernel and apps
- LLK 7.2.6-lcos25 unchanged.
- Apps stay at the 0.9.4 set (Edit 0.9.4-2, Paint 0.9.4-9, City 0.9.4-8, About 0.9.4-8, Updates 0.9.4-7).
- System debs stay at 0.9.4 (lcos-base 0.9.4-7, the other seven 0.9.4-1). No package versions bumped.

## Rules for this open
No bake and no apt publish until Ted or the editor say go.
