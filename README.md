[![License](https://img.shields.io/github/license/project-openubl/xhandler-mobile?logo=apache)](https://www.apache.org/licenses/LICENSE-2.0)

[![Project Chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg?style=for-the-badge&logo=zulip)](https://projectopenubl.zulipchat.com/)

# xhandler-mobile

Mobile app (Android/iOS) for a company to create, sign and send SUNAT electronic
documents, deliver them to its customers and keep them backed up. Built with Flutter
and [flutter_rust_bridge](https://github.com/fzyzcjy/flutter_rust_bridge) on top of
[xhandler-rust](https://github.com/project-openubl/xhandler-rust).

Design: [docs/DESIGN.md](docs/DESIGN.md).

## Development

Requirements: Flutter (stable, see `FLUTTER_VERSION` in
`.github/workflows/ci.yml`), Rust, the Android SDK/NDK for Android builds
and Xcode for iOS builds.

```shell
flutter run                         # on a connected device or emulator
flutter test                        # Dart tests
(cd rust && cargo test)             # Rust bridge tests
(cd rust && cargo test -- --ignored)  # also sends to SUNAT beta
```

The Rust code the app calls lives in `rust/src/api/`. After changing it,
regenerate the Dart bindings (`lib/src/rust/`):

```shell
cargo install flutter_rust_bridge_codegen --version 2.13.0
flutter_rust_bridge_codegen generate
```

`rust/Cargo.toml` pins
[xhandler-rust](https://github.com/project-openubl/xhandler-rust) by commit.
To work on both at once, temporarily point it to a local checkout:
`xhandler = { path = "../../xhandler-rust/xhandler" }`.

## License

- [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
