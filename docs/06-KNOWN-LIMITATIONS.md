# LCOS 0.6 — known limitations

## AMD graphics: blank / broken GL windows (not a 0.6 bake blocker)

**Status:** Known limitation (editor 2026-09-14 for IdeaPad class; extended 2026-09-16 for Beelink office AMD mini PCs). Same suspected class: **XLibre + `amdgpu` / Glamor / Mesa acceleration**, not an AbiWord- or Brave-only app bug. **Not** a reason to bake or hold `lcos-live-06-01`.

### Reports

| When | Hardware | Symptoms | Releases |
|------|----------|----------|----------|
| 2026-09-10…14 | Lenovo IdeaPad Flex 5, AMD Radeon Vega | Blank/unrendered GL windows (Brave Origin, Cool Retro Term, Maelstrom) | 0.4 / 0.5 |
| 2026-09-16 | Beelink OEM mini PCs, AMD (office; exact GPU TBD) | Apps lag, leave trails, jump/freeze; right half of window gone; Brave Origin small blank grey window then freeze on click. **0.3 OK; 0.4 and 0.5 unusable** | 0.4 / 0.5 |

Vendored `xserver-xlibre-video-amdgpu` is **25.1.2-1+lcos1** on official 0.3 through the 0.6 recipe seed — so “broke after 0.3” is **not** explained by an amdgpu package version bump alone. Suite Mesa/kernel/defaults or compositor interaction may still differ between ISOs; treat as stack-class until proven otherwise.

### Confirm checklist (when hardware is available)

Do **not** open a full investigation without this short pass:

1. Exact Beelink model + `lspci -nn | grep -i vga` (or About / GPU name).
2. Repro on stock 0.5 (or live 0.5) with compositing on vs off (XFCE Window Manager Tweaks → Compositor).
3. One soft-render / no-accel smoke: e.g. launch Brave with GPU disabled (`brave-origin --disable-gpu` or equivalent) and note if the window paints.
4. Compare: same machine on 0.3 ISO vs 0.5 ISO if still available.

If a cheap mitigation works (compositor off, `Option "AccelMethod" "none"`, env flags), consider for 0.6 docs or optional xorg snippet; if not, keep documented only.

### Release-notes wording (draft)

> On some AMD systems (including certain Vega laptops and Beelink mini PCs), OpenGL-accelerated windows may show blank, trail, or freeze under XLibre. This is a known limitation. Software rendering / disabling the compositor may help on affected machines.

