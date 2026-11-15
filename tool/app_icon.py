"""Writes every size of the app icon Android and iOS need, from Project
OpenUBL's logo (tool/openubl-logo.png, the ghost of the website and of the
GitHub organization).

Run from the repo root: python3 tool/app_icon.py .  (needs Pillow)
"""
import json
import sys
from pathlib import Path

from PIL import Image

repo = Path(sys.argv[1])
S = 1024
BLUE = (31, 78, 121)

logo = Image.open(repo / "tool/openubl-logo.png").convert("RGBA")
logo = logo.crop(logo.getchannel("A").getbbox())


def centered(art, side, fit):
    """[art] shrunk to [fit] of its longest side, centered on a clear [side] square."""
    ratio = fit / max(art.size)
    art = art.resize((round(art.width * ratio), round(art.height * ratio)), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    canvas.paste(art, ((side - art.width) // 2, (side - art.height) // 2))
    return canvas


# Full icon: the logo on blue, no transparency (the App Store rejects alpha)
icon = Image.new("RGB", (S, S), BLUE)
icon.paste(centered(logo, S, S * 0.70), (0, 0), centered(logo, S, S * 0.70))

# Adaptive icon foreground: the logo alone, inside the circle of 66 of 108 dp
# every launcher mask keeps (a round mask cuts the corners of a 66 dp square)
alpha = logo.getchannel("A")
radius = max(
    ((x - logo.width / 2) ** 2 + (y - logo.height / 2) ** 2) ** 0.5
    for y in range(0, logo.height, 2)
    for x in range(0, logo.width, 2)
    if alpha.getpixel((x, y)) >= 128
)
foreground = centered(logo, S, S * 64 / 108 / 2 * max(logo.size) / radius)

res = repo / "android/app/src/main/res"
for density, scale in {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}.items():
    folder = res / f"mipmap-{density}"
    icon.resize((round(48 * scale),) * 2, Image.Resampling.LANCZOS).save(folder / "ic_launcher.png")
    foreground.resize((round(108 * scale),) * 2, Image.Resampling.LANCZOS).save(
        folder / "ic_launcher_foreground.png"
    )
(res / "mipmap-anydpi-v26").mkdir(exist_ok=True)
(res / "mipmap-anydpi-v26/ic_launcher.xml").write_text(
    '<?xml version="1.0" encoding="utf-8"?>\n'
    '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
    '    <background android:drawable="@color/ic_launcher_background" />\n'
    '    <foreground android:drawable="@mipmap/ic_launcher_foreground" />\n'
    "</adaptive-icon>\n"
)
(res / "values/ic_launcher_background.xml").write_text(
    '<?xml version="1.0" encoding="utf-8"?>\n'
    "<resources>\n"
    '    <color name="ic_launcher_background">#%02X%02X%02X</color>\n' % BLUE
    + "</resources>\n"
)

# Notification small icon: Android draws only its shape, in white; an
# adaptive icon there shows as a grey square or is refused (Android 8.0).
# The ghost's outline, with its face cut out.
alpha = logo.getchannel("A").point(lambda a: 255 if a >= 128 else 0)
face = logo.convert("L").point(lambda v: 255 if v < 90 else 0)
shape = Image.composite(Image.new("L", logo.size, 0), alpha, face)
glyph = Image.new("RGBA", logo.size, (255, 255, 255, 0))
glyph.putalpha(shape)
side = max(glyph.size)
square = centered(glyph, side, side)
for density, scale in {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}.items():
    folder = res / f"drawable-{density}"
    folder.mkdir(exist_ok=True)
    # 24 dp with a 2 dp margin
    inner = round(20 * scale)
    canvas = Image.new("RGBA", (round(24 * scale),) * 2, (255, 255, 255, 0))
    offset = (canvas.width - inner) // 2
    canvas.paste(square.resize((inner, inner), Image.Resampling.LANCZOS), (offset, offset))
    canvas.save(folder / "ic_notification.png")

ios = repo / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
for image in json.loads((ios / "Contents.json").read_text())["images"]:
    points = float(image["size"].split("x")[0])
    size = round(points * int(image["scale"][0]))
    icon.resize((size, size), Image.Resampling.LANCZOS).save(ios / image["filename"])

# Google Play's high-resolution icon
(repo / "docs/store").mkdir(exist_ok=True)
icon.resize((512, 512), Image.Resampling.LANCZOS).save(repo / "docs/store/icon-512.png")
print("written")
