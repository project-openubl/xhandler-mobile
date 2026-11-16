# Store texts

"What's new" of each release, in Spanish, shown in Google Play (es-419, up to 500 characters) and
the App Store (es-MX):

- `android/es-419/changelogs/<version code>.txt` for one release; `tool/release_version.sh <tag>`
  prints its version code.
- `android/es-419/changelogs/default.txt` when that file doesn't exist.

The layout is fastlane supply's (and F-Droid's). See docs/STORE.md, Release CI.
