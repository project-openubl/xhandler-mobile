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

icon = Image.new("RGB", (S, S), BLUE)
draw = ImageDraw.Draw(icon)
# The document, with a folded corner
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
text = "XH"
box = draw.textbbox((0, 0), text, font=font)
draw.text(
    ((left + right - fold // 2) / 2 - (box[2] - box[0]) / 2 - box[0], 300 - box[1]),
    text,
    font=font,
    fill=BLUE,
)
# Lines of the document
for y in (610, 680):
    draw.rounded_rectangle((left + 70, y, right - 70, y + 26), radius=13, fill=(190, 200, 212))
# Accepted: a green check
cx, cy, r = 700, 790, 150
draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=GREEN, outline="white", width=22)
draw.line([(cx - 70, cy + 5), (cx - 15, cy + 60), (cx + 75, cy - 55)], fill="white", width=40, joint="curve")

android = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
for density, size in android.items():
    icon.resize((size, size), Image.LANCZOS).save(
        repo / f"android/app/src/main/res/mipmap-{density}/ic_launcher.png"
    )

ios = repo / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
for image in json.loads((ios / "Contents.json").read_text())["images"]:
    points = float(image["size"].split("x")[0])
    size = round(points * int(image["scale"][0]))
    icon.resize((size, size), Image.LANCZOS).save(ios / image["filename"])

print("written")
