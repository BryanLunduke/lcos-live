#!/usr/bin/env python3
"""Draw LCOS 1.1 boot-menu art from the vector badge.

The badge itself comes from LCOS-Branding tools/render-lcos-logo.py
(logo/lcos-logo-black.svg). This script only composites that render into
boot-menu tiles, the GRUB theme, the rEFInd theme and the live splash.

Usage:
  packaging/render-bootmenu-assets.py LOGO_PNG
LOGO_PNG is a square RGBA render (the 512 px file from the vector renderer).
"""
import os
import subprocess
import sys

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PKG = os.path.join(ROOT, "packaging", "src", "lcos-bootmenu")
GRUB_THEME = os.path.join(PKG, "usr", "share", "grub", "themes", "lcos")
REFIND_THEME = os.path.join(PKG, "usr", "share", "lcos-bootmenu", "refind-theme")
LIVE_THEME = os.path.join(ROOT, "config", "bootloaders", "grub-pc", "live-theme")
ISO_SPLASH = os.path.join(ROOT, "config", "bootloaders", "isolinux", "splash.png")
SYS_SPLASH = os.path.join(ROOT, "config", "bootloaders", "syslinux_common", "splash.png")

NAVY = (13, 27, 48, 255)          # #0d1b30
NAVY_TILE = (14, 32, 58, 255)
WIN_BLUE = (0, 120, 215, 255)
HAIKU_BG = (246, 244, 236, 255)
MAC_BG = (32, 32, 34, 255)
LINUX_BG = (214, 216, 220, 255)
UNKNOWN_BG = (92, 98, 110, 255)
WHITE = (255, 255, 255, 255)

SANS = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
SANS_BOLD = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
MONO = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"

# Upstream rEFInd icon names that should read as "another Linux".
LINUX_OS_NAMES = [
    "linux", "ubuntu", "debian", "devuan", "fedora", "arch", "gentoo",
    "linuxmint", "opensuse", "suse", "manjaro", "elementary", "centos",
    "redhat", "endeavouros", "void", "mageia", "slackware", "kubuntu",
    "xubuntu", "lubuntu", "chakra", "crunchbang", "frugalware", "mandriva",
    "grub", "elilo", "chrome", "systemd", "clover", "gummiboot", "refit",
    "uefi", "legacy", "network", "freedos", "freebsd", "openbsd", "netbsd",
    "hwtest", "artful", "trusty", "xenial", "bionic", "zesty", "pop", "neon",
    "rocky", "alma", "nixos", "parrot", "kali", "deepin", "zorin", "mx",
    "peppermint", "solus", "kaos", "chakra", "calculate", "altlinux",
]


def save(im, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    im.save(path, optimize=True)


def gradient(w, h, top, bottom):
    im = Image.new("RGB", (w, h))
    px = im.load()
    for y in range(h):
        t = y / max(1, h - 1)
        row = tuple(int(a + (b - a) * t) for a, b in zip(top, bottom))
        for x in range(w):
            px[x, y] = row
    return im


def tile(size, fill, inset=16, radius=30):
    im = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle(
        [inset + 1, inset + 7, size - inset + 1, size - inset + 5],
        radius=radius, fill=(0, 0, 0, 120),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(5))
    im = Image.alpha_composite(im, shadow)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle(
        [inset, inset, size - 1 - inset, size - 1 - inset],
        radius=radius, fill=fill,
    )
    return im


def windows_icon(size=128):
    im = tile(size, WIN_BLUE)
    d = ImageDraw.Draw(im)
    # Four panes inset from the rounded tile, with a gap. Not a copied asset.
    left, right = 40, 88
    gap = 6
    pane = (right - left - gap) // 2
    for col in (0, 1):
        for row in (0, 1):
            x0 = left + col * (pane + gap)
            y0 = left + row * (pane + gap)
            d.rounded_rectangle(
                [x0, y0, x0 + pane, y0 + pane], radius=3, fill=WHITE,
            )
    return im


def haiku_icon(size=128):
    im = tile(size, HAIKU_BG, radius=30)
    d = ImageDraw.Draw(im)
    # Three separate leaves. Haiku's loader is recognised by the directory
    # name; the mark only has to read as a leaf at boot-menu size.
    cx, cy = size // 2, size // 2 + 6
    d.ellipse([cx - 34, cy - 28, cx - 4, cy + 4], fill=(45, 108, 214, 255))
    d.ellipse([cx + 4, cy - 28, cx + 34, cy + 4], fill=(240, 186, 32, 255))
    d.ellipse([cx - 16, cy - 2, cx + 16, cy + 32], fill=(52, 160, 78, 255))
    d.ellipse([cx - 6, cy - 6, cx + 6, cy + 6], fill=HAIKU_BG)
    return im


def mac_icon(size=128):
    im = tile(size, MAC_BG)
    # Simple apple: body, leaf, bite. Drawn here, not traced from Apple's art.
    body = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    bd = ImageDraw.Draw(body)
    bd.ellipse([40, 44, 92, 100], fill=(236, 236, 238, 255))
    bd.polygon([(62, 46), (78, 30), (84, 48), (70, 52)], fill=(120, 190, 96, 255))
    bite = Image.new("L", (size, size), 0)
    ImageDraw.Draw(bite).ellipse([78, 58, 108, 92], fill=255)
    sil = body.getchannel("A")
    sil = Image.composite(Image.new("L", (size, size), 0), sil, bite)
    body.putalpha(sil)
    return Image.alpha_composite(im, body)


def linux_icon(size=128):
    im = tile(size, LINUX_BG, radius=30)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle([38, 46, 90, 84], radius=8, fill=(120, 126, 136, 255))
    d.rounded_rectangle([44, 52, 84, 74], radius=4, fill=(70, 74, 82, 255))
    d.rectangle([58, 84, 70, 90], fill=(120, 126, 136, 255))
    d.rectangle([50, 90, 78, 94], fill=(120, 126, 136, 255))
    d.ellipse([76, 66, 82, 72], fill=(90, 210, 120, 255))
    return im


def unknown_icon(size=128):
    im = tile(size, UNKNOWN_BG)
    d = ImageDraw.Draw(im)
    font = ImageFont.truetype(SANS_BOLD, 48)
    d.text((size // 2, size // 2 + 2), "?", font=font, fill=WHITE, anchor="mm")
    return im


def lcos_icon(size, logo):
    im = tile(size, NAVY_TILE, radius=30)
    inner = size - 44
    badge = logo.resize((inner, inner), Image.Resampling.LANCZOS)
    im.alpha_composite(badge, ((size - inner) // 2, (size - inner) // 2))
    return im


def tool_base(size=128):
    im = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    m = 28
    d.ellipse([m, m, size - 1 - m, size - 1 - m], fill=(48, 54, 66, 255), outline=(168, 176, 188, 255), width=3)
    return im


def tool_shutdown(size=128):
    im = tool_base(size)
    d = ImageDraw.Draw(im)
    c = size // 2
    d.arc([c - 16, c - 14, c + 16, c + 18], start=-50, end=230, fill=WHITE, width=4)
    d.line([c, c - 22, c, c + 2], fill=WHITE, width=4)
    return im


def tool_reboot(size=128):
    im = tool_base(size)
    d = ImageDraw.Draw(im)
    c = size // 2
    d.arc([c - 16, c - 16, c + 16, c + 16], start=40, end=320, fill=WHITE, width=4)
    d.polygon([(c + 14, c - 18), (c + 22, c - 4), (c + 6, c - 4)], fill=WHITE)
    return im


def tool_firmware(size=128):
    im = tool_base(size)
    d = ImageDraw.Draw(im)
    c = size // 2
    d.rounded_rectangle([c - 12, c - 10, c + 12, c + 10], radius=3, outline=WHITE, width=3)
    d.line([c - 18, c - 6, c - 12, c - 6], fill=WHITE, width=3)
    d.line([c - 18, c + 6, c - 12, c + 6], fill=WHITE, width=3)
    d.line([c + 12, c - 6, c + 18, c - 6], fill=WHITE, width=3)
    d.line([c + 12, c + 6, c + 18, c + 6], fill=WHITE, width=3)
    return im


def selection(size, radius, stroke):
    im = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    pad = 4
    gd.rounded_rectangle(
        [pad, pad, size - 1 - pad, size - 1 - pad],
        radius=radius, outline=(255, 255, 255, 110), width=stroke + 8,
    )
    glow = glow.filter(ImageFilter.GaussianBlur(2))
    im = Image.alpha_composite(im, glow)
    d = ImageDraw.Draw(im)
    d.rounded_rectangle(
        [pad, pad, size - 1 - pad, size - 1 - pad],
        radius=radius, outline=(255, 255, 255, 235), width=stroke,
    )
    return im


def mouse_pointer():
    im = Image.new("RGBA", (32, 32), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    pts = [(4, 2), (4, 26), (10, 20), (15, 30), (19, 28), (14, 18), (22, 18)]
    d.polygon(pts, fill=WHITE, outline=(0, 0, 0, 255))
    return im


def refind_font(path):
    """96 monospace glyphs, white on transparency, nothing clipped."""
    point = 18
    font = ImageFont.truetype(MONO, point)
    chars = [chr(c) for c in range(32, 127)] + ["?"]
    assert len(chars) == 96
    ascent, descent = font.getmetrics()
    height = ascent + descent + 2
    # One cell is the advance of "M" so the row stays monospaced.
    cell = max(font.getbbox("M")[2], 1) + 1
    im = Image.new("RGBA", (cell * 96, height), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    # rEFInd draws this bitmap as-is on a light field and inverts the RGB
    # on a dark field (libeg/text.c, BGBrightness < 128). Glyphs must be
    # black with a real alpha, the same as upstream's fonts. A white glyph
    # inverts to black and disappears on the navy banner.
    for i, ch in enumerate(chars):
        d.text((i * cell, 1), ch, font=font, fill=(0, 0, 0, 255))
    save(im, path)


def grub_fonts(directory):
    os.makedirs(directory, exist_ok=True)
    for size in (16, 20):
        out = os.path.join(directory, "dejavu-%d.pf2" % size)
        subprocess.check_call([
            "grub-mkfont", "-o", out, "-s", str(size),
            "--range=0x0-0x024f", SANS,
        ])


def banner():
    im = gradient(1920, 1080, (22, 40, 64), (8, 14, 24)).convert("RGBA")
    d = ImageDraw.Draw(im)
    font = ImageFont.truetype(SANS, 36)
    d.text((960, 168), "Choose a system to start", font=font, fill=(232, 236, 244, 255), anchor="mm")
    return im.convert("RGB")


def splash(logo):
    im = gradient(640, 480, (22, 40, 64), (8, 14, 24)).convert("RGBA")
    badge = logo.resize((150, 150), Image.Resampling.LANCZOS)
    im.alpha_composite(badge, ((640 - 150) // 2, 28))
    return im.convert("RGB")


def grub_theme_text():
    # desktop-image stays a real bitmap. GRUB 2.12 gfxmenu always scales it,
    # and a missing image leaves "null src bitmap" (the PR #2 failure). A
    # solid 16x16 tile cannot distort the separate unscaled logo.
    return """# LCOS 1.1 GRUB theme. Navy field, smooth badge, DejaVu instead of Unifont.
# desktop-image must be set: GRUB 2.12 gfxmenu (view.c init_background)
# always calls grub_video_bitmap_create_scaled() on it. With none, that
# leaves "null src bitmap in grub_video_bitmap_create_scaled" in grub_errno,
# printed as "Press any key to continue..." when a menu entry boots (UEFI).
# background.png is a 16x16 solid #0d1b30 tile. Stretching a solid colour
# cannot distort the logo, which is a separate unscaled image.
desktop-image: "background.png"
desktop-image-scale-method: "stretch"
desktop-color: "#0d1b30"
title-color: "#ffffff"
title-font: "DejaVu Sans Regular 16"
title-text: ""
message-font: "DejaVu Sans Regular 16"
terminal-font: "DejaVu Sans Regular 16"

+ image {
        left = 50%-100
        top = 2%
        width = 200
        height = 200
        file = "lcos-logo.png"
}

+ boot_menu {
        left = 18%
        width = 64%
        top = 56%
        height = 34%
        item_font = "DejaVu Sans Regular 16"
        item_color = "#c5cdd8"
        selected_item_font = "DejaVu Sans Regular 16"
        selected_item_color = "#ffffff"
        item_height = 32
        item_padding = 2
        item_spacing = 4
        icon_width = 28
        icon_height = 28
        item_icon_space = 12
}

+ label {
        top = 100%-36
        left = 0
        width = 100%
        height = 20
        text = "@KEYMAP_SHORT@"
        align = "center"
        color = "#9aa3b2"
        font = "DejaVu Sans Regular 16"
}

+ progress_bar {
        id = "__timeout__"
        left = 20%
        top = 100%-64
        height = 14
        width = 60%
        font = "DejaVu Sans Regular 16"
        text_color = "#0d1b30"
        fg_color = "#ffffff"
        bg_color = "#24344c"
        border_color = "#8ea0b8"
        text = "@TIMEOUT_NOTIFICATION_SHORT@"
}
"""


def refind_theme_text():
    return """# LCOS rEFInd theme. Paths are relative to EFI/refind (the directory
# that contains refind_x64.efi), not to this file.
icons_dir themes/lcos/icons
banner themes/lcos/background.png
banner_scale fillscreen
selection_big themes/lcos/selection_big.png
selection_small themes/lcos/selection_small.png
big_icon_size 128
small_icon_size 64
font themes/lcos/dejavu-mono-16.png
"""


def main():
    if len(sys.argv) != 2:
        sys.exit("usage: render-bootmenu-assets.py LOGO_PNG")
    logo = Image.open(sys.argv[1]).convert("RGBA")
    big = {
        # Not os_lcos.png: rEFInd treats the volume name as an icon hint,
        # so a disk labelled LCOS would paint every other OS with this badge.
        "lcos-badge": lcos_icon(128, logo),
        "os_win": windows_icon(),
        "os_win8": windows_icon(),
        "os_mac": mac_icon(),
        "os_haiku": haiku_icon(),
        "os_beos": haiku_icon(),
        "os_unknown": unknown_icon(),
        "func_shutdown": tool_shutdown(),
        "func_reset": tool_reboot(),
        "func_firmware": tool_firmware(),
        "mouse": mouse_pointer(),
    }
    linux = linux_icon()
    for name in LINUX_OS_NAMES:
        big["os_" + name] = linux

    icon_dir = os.path.join(REFIND_THEME, "icons")
    for name, im in big.items():
        save(im, os.path.join(icon_dir, name + ".png"))
    save(selection(144, 36, 5), os.path.join(REFIND_THEME, "selection_big.png"))
    save(selection(64, 18, 3), os.path.join(REFIND_THEME, "selection_small.png"))
    save(banner(), os.path.join(REFIND_THEME, "background.png"))
    refind_font(os.path.join(REFIND_THEME, "dejavu-mono-16.png"))
    with open(os.path.join(REFIND_THEME, "theme.conf"), "w") as fh:
        fh.write(refind_theme_text())

    os.makedirs(os.path.join(GRUB_THEME, "icons"), exist_ok=True)
    grub_map = {
        "gnu-linux": linux,
        "linux": linux,
        "windows": big["os_win"],
        "osx": big["os_mac"],
        "darwin": big["os_mac"],
        "haiku": big["os_haiku"],
        "beos": big["os_haiku"],
        "unknown": big["os_unknown"],
    }
    for name, im in grub_map.items():
        save(im.resize((64, 64), Image.Resampling.LANCZOS),
             os.path.join(GRUB_THEME, "icons", name + ".png"))
    badge = logo.resize((200, 200), Image.Resampling.LANCZOS)
    save(badge, os.path.join(GRUB_THEME, "lcos-logo.png"))
    solid = Image.new("RGB", (16, 16), (13, 27, 48))
    save(solid, os.path.join(GRUB_THEME, "background.png"))
    grub_fonts(GRUB_THEME)
    with open(os.path.join(GRUB_THEME, "theme.txt"), "w") as fh:
        fh.write(grub_theme_text())

    # Live ISO GRUB theme is the same art. live-build copies config/bootloaders.
    os.makedirs(LIVE_THEME, exist_ok=True)
    for name in ("theme.txt", "background.png", "lcos-logo.png",
                 "dejavu-16.pf2", "dejavu-20.pf2"):
        src = os.path.join(GRUB_THEME, name)
        dst = os.path.join(LIVE_THEME, name)
        with open(src, "rb") as fh:
            data = fh.read()
        with open(dst, "wb") as fh:
            fh.write(data)
    live_icons = os.path.join(LIVE_THEME, "icons")
    os.makedirs(live_icons, exist_ok=True)
    for name in os.listdir(os.path.join(GRUB_THEME, "icons")):
        src = os.path.join(GRUB_THEME, "icons", name)
        with open(src, "rb") as fh:
            data = fh.read()
        with open(os.path.join(live_icons, name), "wb") as fh:
            fh.write(data)

    spl = splash(logo)
    save(spl, ISO_SPLASH)
    save(spl, SYS_SPLASH)
    print("boot menu art written")


if __name__ == "__main__":
    main()
