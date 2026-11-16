# Store readiness

What's needed to publish XHandler on Google Play and the App Store (DESIGN §13,
phase 8). Texts shown to users are in Spanish. Items marked **(owner)** need the
project owner's accounts, keys or legal review; nothing here was submitted.

## Owner checklist

1. **(owner)** Google Play developer account for the OpenUBL organization, app
   `io.github.projectopenubl.xhandler` created in Play Console.
2. **(owner)** Upload key: `keytool -genkeypair -v -keystore release.jks -keyalg RSA
   -keysize 4096 -validity 10000 -alias upload`, kept out of git. Enable Play App
   Signing. Locally, `android/key.properties` (git-ignored):
   ```properties
   # storeFile is relative to android/app
   storeFile=release.jks
   storePassword=…
   keyAlias=upload
   keyPassword=…
   ```
3. **(owner)** Apple Developer Program membership; App ID
   `io.github.projectopenubl.xhandler`; App Store Connect app record; distribution
   certificate; App Store Connect API key (for CI).
4. **(owner)** Publish the privacy policy below at a stable URL (e.g. the project
   website) and enter it in both stores.
5. **(owner)** Review and submit the Data safety form and App privacy labels below.
6. **(owner)** Export compliance answers (below) — a legal decision.
7. **(owner)** Screenshots (phone and tablet) from a device or emulator in test mode,
   and Play's 1024×500 feature graphic. The 512×512 Play icon is `docs/store/icon-512.png`.
8. **(owner)** Play Console's other "App content" forms: ads (none), content rating,
   target audience (adults, businesses), financial features (none), government apps
   (not affiliated). App Store: subtitle and keywords (e.g. subtitle "Facturas, boletas
   y guías SUNAT").
9. **(owner)** Optional integrations that need accounts (DESIGN §14): Google Drive /
   iCloud backups, Gmail API / Microsoft Graph email, SIRE.
10. Add the secrets in "Release CI" and release with release-tools' release-mobile. Before the
    store accounts exist, a release needs only the Android signing secrets ("Before the stores").

## Store listing (Spanish)

- **Name (30 max):** XHandler: Facturación SUNAT
- **Short description (80):** Emite facturas, boletas y guías electrónicas SUNAT desde tu celular.
- **Full description:**

  > XHandler es una aplicación de código abierto para emitir comprobantes electrónicos
  > de SUNAT desde tu teléfono, sin servidores intermedios: el comprobante se crea, se
  > firma con tu certificado digital y se envía a SUNAT directamente desde el equipo.
  >
  > - Facturas, boletas, notas de crédito y débito, guías de remisión, percepciones y
  >   retenciones.
  > - Venta rápida para mostrador y formulario completo (cuotas, ISC, ICBPER, IGV
  >   incluido o no).
  > - Funciona sin conexión: los comprobantes se envían cuando vuelve la señal.
  > - Anulaciones (comunicación de baja, resumen diario, reversión).
  > - PDF en A4 o ticket, envío por correo, WhatsApp u otras aplicaciones.
  > - Varias empresas en un mismo teléfono y modo prueba con SUNAT beta.
  > - Copias de seguridad cifradas con contraseña.
  > - Reporte mensual de ventas en Excel o CSV.
  >
  > Tus datos se guardan cifrados en tu teléfono. XHandler no tiene cuentas ni
  > servidores propios y no recopila información de uso.
  >
  > XHandler no está afiliado a SUNAT ni a ninguna entidad del Estado peruano; usa los
  > servicios públicos de SUNAT para enviar tus comprobantes.
- **Category:** Business (Play) / Business (App Store)
- **Contact:** the OpenUBL project's email and website **(owner)**

## Privacy policy (Spanish draft)

> **Política de privacidad de XHandler**
>
> XHandler es una aplicación de código abierto del proyecto OpenUBL para emitir
> comprobantes electrónicos de SUNAT. No tiene cuentas de usuario ni servidores propios:
> los desarrolladores no reciben ninguno de tus datos.
>
> **Quién es responsable.** Cada empresa que usa XHandler es la responsable de los
> datos personales de sus clientes (Ley 29733, Ley de Protección de Datos Personales) y
> los trata para emitir comprobantes, como exige la ley tributaria. Tus clientes pueden
> pedirte acceder a sus datos, corregirlos o suprimirlos; los comprobantes ya emitidos no
> se pueden modificar y se deben conservar.
>
> **Qué datos maneja y dónde quedan.** Los datos de tus empresas, clientes, productos
> y comprobantes, tu certificado digital y tus credenciales (clave SOL, credenciales de
> guías, contraseña de correo) se guardan solo en tu teléfono, en una base de datos
> cifrada y en el almacenamiento seguro del sistema (Keystore / Keychain).
>
> **A quién se envían, solo cuando tú lo pides o lo exige la ley:**
> - **SUNAT**, para enviar tus comprobantes y consultar su estado, con tus credenciales.
> - **El servicio de consulta de RUC/DNI** que configures (opcional, por ejemplo
>   Decolecta), que recibe el número de RUC o DNI consultado.
> - **Tu servidor de correo**, cuando envías un comprobante por correo desde tu cuenta.
> - **WhatsApp u otra aplicación** que elijas al compartir un comprobante.
> - **El lugar donde guardes tus copias de seguridad** (por ejemplo, Google Drive o tu
>   correo), que puede estar fuera del Perú. Las copias están cifradas con una contraseña
>   que solo tú conoces.
>
> **Qué no hacemos.** No usamos publicidad, analítica ni rastreo, y no vendemos ni
> compartimos datos.
>
> **Conservación y eliminación.** Los datos permanecen en tu teléfono hasta que elimines
> una empresa o desinstales la aplicación. La ley tributaria te obliga a conservar tus
> comprobantes (XML y constancias de SUNAT) por varios años y a entregarlos a tus
> clientes si los piden; haz copias de seguridad seguido.
>
> **Contacto:** _(correo del proyecto OpenUBL)_
>
> Última actualización: _(fecha de publicación)_

## Google Play Data safety (draft answers)

Play counts data as *collected* when the app sends it off the device. XHandler sends data
only to SUNAT, the optional lookup service and the user's own email server, never to the
developer.

| Question | Answer |
|---|---|
| Does the app collect or share user data? | Yes (collected, for app functionality) |
| Data types (required unless noted) | Personal info: name; email address (optional: email delivery); address (customers' and guías' addresses in the documents); user IDs (RUC, SOL user); other info (DNI/RUC of customers). Financial info: other financial info (the user's sales documents). Files and docs (optional: documents sent by email). |
| Shared with third parties? | No (sending to SUNAT and the user's email/WhatsApp is user-initiated) |
| Processed ephemerally? | No |
| Purpose | App functionality |
| Encrypted in transit? | Yes (HTTPS / TLS) |
| Users can request deletion? | Yes: deleting a company or uninstalling removes it from the device |
| Independent security review? | No |

## App Store privacy labels (draft)

- **Data used to track you:** none.
- **Data linked to you:** none collected by the developer. Apple's "data collection"
  means data sent to the developer or partners; XHandler sends data to SUNAT, the
  lookup service and the user's mail server on the user's behalf. Declare *Data Not
  Collected* unless Apple's review says otherwise **(owner)**.
- **Privacy manifest:** `ios/Runner/PrivacyInfo.xcprivacy` declares no tracking and
  the required-reason APIs of the native code without a manifest of its own (the Rust
  bridge and SQLite): file timestamps (C617.1), boot time (35F9.1) and disk space
  (E174.1). The Flutter engine and the plugins ship their own. Adjust it to the first
  upload's email from Apple if it lists anything else.

## Permissions

| Permission | Why (shown/declared) |
|---|---|
| Internet (Android) | Send documents to SUNAT, look up customers, send emails |
| Notifications (Android 13+, iOS) | Tell when SUNAT answers documents sent in the background; asked the first time a document stays pending |
| Background fetch / BGTaskScheduler (iOS), WorkManager (Android) | Send pending documents when the app is closed |
| Biometrics (`USE_BIOMETRIC` on Android, Face ID usage text on iOS) | Optional app lock with the phone's fingerprint, face or PIN; nothing biometric leaves the system |

No location, camera, contacts or storage permissions: files are picked and shared
through the system pickers and share sheet.

## Export compliance **(owner)**

The app uses encryption for: HTTPS/TLS to SUNAT and email servers (rustls), the local
database (SQLite3MultipleCiphers, ChaCha20-Poly1305), the backup file (Argon2id +
AES-256-GCM) and XML digital signatures (RSA-SHA256). All of it protects the user's
own data or authenticates documents; none of it is a user-facing encryption tool.

This is usually treated as exempt (US EAR category 5 part 2, mass-market / data
protection), which in App Store Connect means answering that the app uses only exempt
encryption, and adding `ITSAppUsesNonExemptEncryption = NO` to `ios/Runner/Info.plist`.
Distribution in France may also need an ANSSI declaration. This is a legal call, so the
key isn't set in the project yet: a `vX.Y.Z` release stops before the App Store submission until it
is (Release CI).

## Release CI

Releases are made from release-tools: Actions → **Release xhandler-mobile** with the version
(`vX.Y.0-alpha.N` from `main`, `vX.Y.Z` from `release-X.Y`, see release-tools' VERSIONING.md). It
checks CI on the branch, tags it, publishes the GitHub release and waits for
`.github/workflows/release.yml` here, which builds the signed app and uploads it:

| Version | Google Play | App Store |
|---|---|---|
| `-alpha.N`, `-beta.N`, `-rc.N` | Internal testing | TestFlight |
| `vX.Y.Z` | Production, staged rollout to 10% (`PLAY_ROLLOUT`) | TestFlight, then submitted for review |

Making a stable release public stays a decision in the stores: raise the rollout in Play Console,
and release the version in App Store Connect once Apple approves it. The signed APK and AAB and their
`SHA256SUMS` are attached to the GitHub release, for people who install from there. Create a
`release-X.Y` branch by hand (`git push origin main:release-X.Y`): release-tools'
`_cut-release-branches` is for xhandler's versions, not the app's.

**Before the stores.** Only the Android signing secrets are required. A store whose secrets are all
unset is skipped with a notice, so until the store accounts exist a release is the GitHub release
with the signed APK and AAB, and no iOS build (it can't be signed without the Apple account). Setting
only some of a store's secrets is an error. The upload key signs the GitHub APK and, once on Google
Play, Play App Signing re-signs the store's builds with Google's key: an APK installed from GitHub has
to be uninstalled before installing from Google Play.

**Version and build number.** Both come from the tag (`tool/release_version.sh <tag>` prints them).
The version is the tag without the `v` on Android and `X.Y.Z` on iOS (Apple takes nothing else). The
build number (Android `versionCode`, iOS `CFBundleVersion`) is
`((X*100 + Y)*100 + Z)*100 + S`, with `S` = `N` for `alpha.N`, `30+N` for `beta.N`, `60+N` for
`rc.N` and `99` for the release: `v1.2.0-alpha.3` is 1020003, `v1.2.0` 1020099. It follows the
version order, so up to `.29` pre-releases of each kind and minor and patch versions up to 99.
A tag always gives the same number, and a store never takes a number twice, so a tag is never moved.

**Reruns.** `fastlane/Fastfile` uploads and skips what the stores already have (the version code on
its Play track, the build in App Store Connect, a version already in review or on sale), and
attached files stay. To retry a failed release, run release-mobile again with the same version, or
dispatch Release here from `main` with the tag (a re-run would use the workflow file of the tagged
commit).

**What's new.** The text the stores show for the release, in Spanish:
`fastlane/metadata/android/es-419/changelogs/<build number>.txt`, or `default.txt` when it doesn't
exist (Google Play: up to 500 characters). The App Store gets the same text for `es-MX`. Add the
file in the pull requests before the release. Both listings must have those languages.

**First uploads.** Play requires the first upload of a new app to be made by hand in Play Console:
upload a release build with build number 1 (the `+1` of `pubspec.yaml`), so every tagged release
is above it. While the app is still a draft, Play's API only takes draft releases: set the
repository variable `PLAY_RELEASE_STATUS=draft` until the first release is out, then delete it.
An App Store submission needs `ITSAppUsesNonExemptEncryption` in `ios/Runner/Info.plist`
([Export compliance](#export-compliance-owner)): until it is set, a `vX.Y.Z` release stops after the
TestFlight upload.

The iOS job uses manual signing with an App Store provisioning profile downloaded with the API
key: `tool/ios_release_signing.rb` switches only the Runner target's Release build to manual
signing with the team and profile. It hasn't run yet (no Apple account here), so expect to adjust
it on the first run. On the first TestFlight build, check that the Rust bridge loads: if it fails
with "Failed to lookup symbol", set the Runner's Strip Style to Non-Global Symbols.

Repository secrets **(owner)**; fastlane uses the same Play and App Store Connect keys:

| Secret | What |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 release.jks` |
| `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | Upload key |
| `PLAY_SERVICE_ACCOUNT_JSON` | Play Console service account with release permission |
| `IOS_DISTRIBUTION_P12_BASE64`, `IOS_DISTRIBUTION_P12_PASSWORD` | Apple distribution certificate |
| `APPLE_TEAM_ID` | Apple team |
| `IOS_PROVISIONING_PROFILE_NAME` | Name of the App Store provisioning profile for `io.github.projectopenubl.xhandler` |
| `APPSTORE_API_KEY_ID`, `APPSTORE_API_ISSUER_ID`, `APPSTORE_API_PRIVATE_KEY` | App Store Connect API key (`.p8` contents), with the App Manager role |

Optional repository variables: `PLAY_ROLLOUT` (fraction of users of a stable release's first rollout,
default `0.1`) and `PLAY_RELEASE_STATUS` (above).

## App icon

The icon is Project OpenUBL's logo (`tool/openubl-logo.png`, the ghost of the website and
the GitHub organization) on OpenUBL blue. `tool/app_icon.py` writes every Android (legacy,
adaptive and the white notification glyph) and iOS size and Play's 512×512 icon from it:
`python3 tool/app_icon.py .` (needs Pillow).
