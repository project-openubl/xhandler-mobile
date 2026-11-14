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
   storeFile=release.jks        # relative to android/app
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
7. **(owner)** Screenshots (phone and tablet) from a device or emulator in test mode.
8. **(owner)** Optional integrations that need accounts (DESIGN §14): Google Drive /
   iCloud backups, Gmail API / Microsoft Graph email, SIRE.
9. Add the secrets in "Release CI" and run the Release workflow.

## Store listing (Spanish)

- **Name:** XHandler — Facturación electrónica SUNAT
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
- **Category:** Business (Play) / Business (App Store)
- **Contact:** the OpenUBL project's email and website **(owner)**

## Privacy policy (Spanish draft)

> **Política de privacidad de XHandler**
>
> XHandler es una aplicación de código abierto del proyecto OpenUBL para emitir
> comprobantes electrónicos de SUNAT. No tiene cuentas de usuario ni servidores propios:
> los desarrolladores no reciben ninguno de tus datos.
>
> **Qué datos maneja y dónde quedan.** Los datos de tus empresas, clientes, productos
> y comprobantes, tu certificado digital y tus credenciales (clave SOL, credenciales de
> guías, contraseña de correo) se guardan solo en tu teléfono, en una base de datos
> cifrada y en el almacenamiento seguro del sistema (Keystore / Keychain).
>
> **A quién se envían, solo cuando tú lo pides o lo exige la ley:**
> - **SUNAT**, para enviar tus comprobantes y consultar su estado, con tus credenciales.
> - **El servicio de consulta de RUC/DNI** que configures (opcional), que recibe el
>   número consultado.
> - **Tu servidor de correo**, cuando envías un comprobante por correo desde tu cuenta.
> - **WhatsApp u otra aplicación** que elijas al compartir un comprobante.
> - **El lugar donde guardes tus copias de seguridad** (por ejemplo, Google Drive o tu
>   correo). Las copias están cifradas con una contraseña que solo tú conoces.
>
> **Qué no hacemos.** No usamos publicidad, analítica ni rastreo, y no vendemos ni
> compartimos datos.
>
> **Conservación y eliminación.** Los datos permanecen en tu teléfono hasta que elimines
> una empresa o desinstales la aplicación. La ley tributaria puede obligarte a conservar
> tus comprobantes por un tiempo; haz copias de seguridad.
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
| Data types | Personal info: name, email address, phone number, other info (RUC/DNI). Financial info: purchase history (invoices). |
| Shared with third parties? | No (sending to SUNAT and the user's email/WhatsApp is user-initiated) |
| Processed ephemerally? | No |
| Required or optional? | Required (SUNAT); lookup and email are optional |
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
- **Privacy manifest:** the app's own native code (AppDelegate) uses no
  required-reason APIs; the Flutter engine and plugins ship their own manifests. Check
  the App Store Connect warnings after the first upload.

## Permissions

| Permission | Why (shown/declared) |
|---|---|
| Internet (Android) | Send documents to SUNAT, look up customers, send emails |
| Notifications (Android 13+, iOS) | Tell when SUNAT answers documents sent in the background; asked the first time a document stays pending |
| Background fetch / BGTaskScheduler (iOS), WorkManager (Android) | Send pending documents when the app is closed |

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
key isn't set in the project yet.

## Release CI

`.github/workflows/release.yml` (manual: Actions → Release → Run workflow) builds a
signed AAB and uploads it to the Play internal track, and builds an IPA and uploads it
to TestFlight. The build number is the workflow run number. It needs these repository
secrets **(owner)**:

| Secret | What |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | `base64 -w0 release.jks` |
| `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | Upload key |
| `PLAY_SERVICE_ACCOUNT_JSON` | Play Console service account with release permission |
| `IOS_DISTRIBUTION_P12_BASE64`, `IOS_DISTRIBUTION_P12_PASSWORD` | Apple distribution certificate |
| `APPLE_TEAM_ID` | Apple team |
| `APPSTORE_API_KEY_ID`, `APPSTORE_API_ISSUER_ID`, `APPSTORE_API_PRIVATE_KEY` | App Store Connect API key (`.p8` contents) |

Play requires the first upload of a new app to be made by hand in Play Console; the
workflow handles the following ones. The iOS job uses manual signing with an App Store
provisioning profile downloaded with the API key; it hasn't run yet (no Apple account
here), so expect to adjust it on the first run.

## App icon

`tool/app_icon.py` draws the icon (a document with a check on OpenUBL blue) and writes
every Android and iOS size: `python3 tool/app_icon.py .` (needs Pillow).
