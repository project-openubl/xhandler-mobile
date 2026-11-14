"""Draws XHandler's app icon and writes every size Android and iOS need.

Run from the repo root: python3 tool/app_icon.py .  (needs Pillow)
"""
import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

repo = Path(sys.argv[1])
S = 1024
BLUE = (31, 78, 121)
GREEN = (46, 160, 67)


def draw_art(image):
    """The document with "XH" and a green check, on a 1024 canvas."""
    draw = ImageDraw.Draw(image)
    left, top, right, bottom = 262, 170, 762, 854
    fold = 130
    draw.polygon(
        [(left, top), (right - fold, top), (right, top + fold), (right, bottom), (left, bottom)],
        fill="white",
    )
    draw.polygon(
        [(right - fold, top), (right - fold, top + fold), (right, top + fold)],
        fill=(205, 216, 228),
    )
    font = ImageFont.truetype(str(repo / "assets/fonts/OpenSans-Bold.ttf"), 230)
    box = draw.textbbox((0, 0), "XH", font=font)
    draw.text(
        ((left + right - fold // 2) / 2 - (box[2] - box[0]) / 2 - box[0], 300 - box[1]),
        "XH",
        font=font,
        fill=BLUE,
    )
    for y in (610, 680):
        draw.rounded_rectangle((left + 70, y, right - 70, y + 26), radius=13, fill=(190, 200, 212))
    cx, cy, r = 700, 790, 150
    draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=GREEN, outline="white", width=22)
    draw.line(
        [(cx - 70, cy + 5), (cx - 15, cy + 60), (cx + 75, cy - 55)],
        fill="white",
        width=40,
        joint="curve",
    )


# Full icon: the art on blue, no transparency (the App Store rejects alpha)
icon = Image.new("RGB", (S, S), BLUE)
draw_art(icon)

# Adaptive icon foreground: the art alone, shrunk into the 66 of 108 dp
# every launcher mask keeps
art = Image.new("RGBA", (S, S), (0, 0, 0, 0))
draw_art(art)
art = art.crop(art.getbbox())
fit = S * 62 / 108  # a little inside the 66 dp
ratio = fit / max(art.size)
art = art.resize((round(art.width * ratio), round(art.height * ratio)), Image.Resampling.LANCZOS)
foreground = Image.new("RGBA", (S, S), (0, 0, 0, 0))
foreground.paste(art, ((S - art.width) // 2, (S - art.height) // 2))

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

ios = repo / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
for image in json.loads((ios / "Contents.json").read_text())["images"]:
    points = float(image["size"].split("x")[0])
    size = round(points * int(image["scale"][0]))
    icon.resize((size, size), Image.Resampling.LANCZOS).save(ios / image["filename"])

# Google Play's high-resolution icon
(repo / "docs/store").mkdir(exist_ok=True)
icon.resize((512, 512), Image.Resampling.LANCZOS).save(repo / "docs/store/icon-512.png")
print("written")
