# xhandler-mobile — Design

Personal mobile app (Android/iOS) for a company to create, sign and send SUNAT
electronic documents, deliver them to its customers, and keep them backed up.
Built with Flutter on top of the Rust libraries of
[xhandler-rust](https://github.com/project-openubl/xhandler-rust).

License: Apache-2.0. UI language: Spanish (Peru). Status: in development, see §13.

---

## 1. Decisions

| Topic | Decision |
|---|---|
| Stack | Flutter + flutter_rust_bridge v2; Rust facade crate wrapping xbuilder/xsigner/xsender |
| Rust role | Stateless functions (build, sign, send, verify, consult). JSON at the boundary |
| Dart role | Owns all data: companies, numbering, documents, delivery, backups |
| Database | SQLite via Drift, encrypted with SQLite3MultipleCiphers (MIT, no OpenSSL). XML/CDR as BLOBs |
| Multi-company | A company is a namespace: every business table has `company_id`; one active company |
| Users | One person per device. App lock with biometrics/PIN. No roles |
| Documents | Everything xbuilder supports: factura, boleta, nota de crédito/débito, guía de remisión, percepción, retención, resumen diario, comunicación de baja, reversión |
| Taxes | Everything in v1: IGV types, ISC, ICB, crédito/cuotas, detracción, percepción, descuentos/cargos, exportación, anticipos |
| Emit | Sends right away. Boletas sent individually (resumen diario used only for voiding boletas) |
| Environment | Per company. Beta shows a "MODO PRUEBA" banner. Switching to production archives beta documents read-only and resets series |
| Currency | PEN default; facturas and boletas also in USD or EUR with the exchange rate typed by the user (SBS selling rate of the issue date); notas inherit it |
| Prices | Per product/line: with or without IGV |
| Customers | Manual entry + optional RUC/DNI lookup through a free-tier commercial service (Decolecta, company-provided token) |
| Sync readiness | No sync in v1, but the schema is ready for a later sync backend (`xhandler-ui`): UUID ids, timestamps, soft deletes |
| Sales modes | Quick sale (boleta, "Clientes varios") + full form |
| Catalog | Products + free-text lines ("guardar en catálogo"). No inventory |
| PDF | Generated on demand. Templates are Dart code shipped with the app (default + registry for more). A4 and ticket (80/58 mm) |
| Delivery | Email from the company account (Gmail API, Microsoft Graph, SMTP), system share sheet (WhatsApp and everything else). Attachments only in v1 |
| Pending PDFs | Allowed, with a "Pendiente de envío a SUNAT" note |
| Backup | WhatsApp-style, end-to-end encrypted, Google Drive appDataFolder / iCloud. Includes certificate and credentials |
| Restore | Replace-all from cloud + per-company encrypted export/import file |
| Reports | Sales summary + CSV + Excel (SIRE builds the sales register from SUNAT's data) |
| Distribution | Google Play + App Store under the OpenUBL organization |
| Min OS | Android 8 (API 26), iOS 15 |
| Signer | xsigner rewritten in pure Rust (Phase 0), no OpenSSL/libxml2 |

---

## 2. Architecture

```
┌──────────────────── Flutter (Dart) ────────────────────┐
│ UI (screens, Spanish) → Riverpod state → repositories   │
│                                     │                   │
│      Drift/sqlite3mc        flutter_secure_storage      │
│      outbox worker (workmanager)    PDF templates        │
│      delivery (Gmail/Graph/SMTP/share)  backup           │
└──────────────── flutter_rust_bridge ────────────────────┘
┌──────────────── Rust: xhandler_bridge ──────────────────┐
│ build_document · sign_document · inspect_certificate ·   │
│ send_document · verify_ticket                            │
│          → xbuilder · xsigner (pure Rust) · xsender      │
└──────────────────────────────────────────────────────────┘
```

### 2.1 Rust bridge API (`rust/src/api/`, crate `xhandler_bridge`)

```rust
// document.rs
fn build_document(document_json: String, defaults: DocumentDefaults) -> Result<BuiltDocument>
    // DocumentDefaults { igv_tasa, icb_tasa, ivap_tasa, fecha_emision }  (strings)
    // BuiltDocument { xml, enriched_json }
// signer.rs
fn sign_document(xml: String, certificate: Vec<u8>, password: String) -> Result<SignedDocument>
    // SignedDocument { xml, digest_value }
fn inspect_certificate(certificate: Vec<u8>, password: String) -> Result<CertificateInfo>
    // CertificateInfo { subject, issuer, ruc, valid_from, valid_until }
// sunat.rs
async fn send_document(xml, environment: SunatEnvironment, credentials) -> Result<SunatResponse>
async fn verify_ticket(xml, ticket, environment, credentials) -> Result<SunatResponse>

enum SunatStatus { Accepted, Rejected, Exception, InProgress, Unknown, NotDelivered }
struct SunatResponse { status, code, description, notes, cdr_zip, ticket }
```

- The document JSON is `xbuilder::document::Document`:
  `{"kind": "Invoice", "spec": {...}}` (the same input the `openubl` CLI reads).
- `enriched_json` is the document after the enrichment pipeline (totals,
  legends); the PDF is rendered from it so tax math is never re-implemented
  in Dart.
- `SunatStatus` is xsender's `Status` plus `NotDelivered`: no answer (no
  connection, timeout, HTTP 5xx/408/429, unexpected body); retry later. SUNAT
  may still have received the document (timeout after sending): the retry
  then answers 1033 and the CDR is recovered (§5). Permanent HTTP errors
  (e.g. "HTTP 401", wrong credentials) are `Exception` with `code` set.
- Errors are `BridgeError { kind, message }`: `kind` (`WrongPassword`,
  `InvalidCertificate`, `InvalidDocument`, `Other`) drives the UI, `message`
  is for support.
- The FFI types are flat structs and field-less enums, so the Dart side needs
  no code generation besides flutter_rust_bridge's.
- `get_status_cdr` (recovering a CDR after code 1033) will be added with the
  outbox in Phase 3.
- Dependency: `xhandler` as a git dependency pinned by `rev`.
- SUNAT's public demo certificate ships in `assets/demo/`: MODO PRUEBA
  companies without their own certificate sign with it, and the diagnostics
  screen uses it.

---

## 3. Data model (SQLite / Drift, encrypted with SQLite3MultipleCiphers)

Defined in `lib/data/tables.dart`; schema version 1 (snapshots in `drift_schemas/app/`; it changes in place until a store build publishes it).
Decimals are stored as text to keep them exact; timestamps as ISO-8601 UTC text.

```
-- every table except device_settings also has: id (UUIDv7), created_at, updated_at,
-- deleted_at (see §3.1)
companies         ruc, razon_social, nombre_comercial, domicilio fiscal (ubigeo, departamento,
                  provincia, distrito, direccion, urbanizacion, codigo_local), telefono, email,
                  sunat_environment (beta | production), moneda (of new documents),
                  igv_tipo (of new products), es_agente_percepcion, es_agente_retencion,
                  lookup_provider (none | decolecta), cuenta_detracciones (v2)
                  UNIQUE(ruc) among the not deleted
series            company_id, tipo_comprobante, serie, next_number, is_default, active
                  UNIQUE(company_id, tipo_comprobante, serie)
customers         company_id, tipo_documento_identidad, numero_documento_identidad, nombre,
                  direccion, distrito, provincia, departamento, ubigeo, email, telefono
                  UNIQUE(company_id, tipo_documento_identidad, numero_documento_identidad)
                  among the not deleted
products          company_id, codigo, codigo_sunat, descripcion, unidad_medida, precio,
                  precio_incluye_igv, igv_tipo, isc_tipo, isc_tasa, es_bolsa,
                  detraccion_codigo, detraccion_porcentaje (v2), favorito
vehicles          company_id, placa, numero_circulacion                -- GRE transporte privado
drivers           company_id, tipo_documento_identidad, numero_documento_identidad, nombres,
                  apellidos, licencia                                  -- GRE transporte privado
addresses         company_id, nombre, ubigeo, direccion, codigo_local  -- GRE partida/llegada
documents         company_id, environment, tipo_comprobante, serie, numero, fecha_emision
                  (Peru's date), cliente_tipo_documento, cliente_numero_documento,
                  cliente_nombre, moneda, tipo_cambio (v3), total, status (§5), sunat_code, sunat_description,
                  sunat_notes (json), ticket, digest_value, attempts, next_attempt_at,
                  input_json (what the user entered), enriched_json (as built, for the PDF),
                  affected_document_id, voided_by_document_id, device_id
                  UNIQUE(company_id, environment, tipo_comprobante, serie, numero)
                  INDEX(company_id, environment, created_at), INDEX(status, next_attempt_at)
document_files    document_id, kind (signed_xml | cdr_zip), bytes, sha256
                  UNIQUE(document_id, kind)
document_events   document_id, status, code, message, device_id      -- timeline / audit
deliveries        document_id, channel (email | share), recipient, device_id
device_settings   key, value  -- this device only, not synced: device_id, active_company_id,
                              -- last_backup_at, notifications_asked,
                              -- app_lock_minutes, theme_mode
```

### 3.1 Sync readiness

No sync in v1, but every synced table follows these rules so a later sync backend
(candidate: `xhandler-ui`) needs no data migration:

- `id` is a UUIDv7 generated on the device (sortable by creation time; no auto-increment ids
  that would collide across devices). Foreign keys reference these UUIDs.
- `created_at`, `updated_at` (UTC) on every row; `updated_at` is set by the repository on
  every write.
- `deleted_at` soft delete instead of `DELETE`, so deletions can be propagated.
- `device_id` (a UUID generated at install) on rows that are created once and never edited
  afterwards (documents, events, deliveries), to know where they came from.
- Issued documents are immutable after emit (only status columns change), which keeps
  future conflict handling trivial; series stay device-owned ("one series per device").
- Binary files keep their `sha256`, so they can be uploaded once and deduplicated.

Secrets are **not** in the database. They live in `flutter_secure_storage`
(Android Keystore / iOS Keychain) under `company/{id}/…`: certificate `.pfx`, its password,
SOL user/password, GRE `client_id`/`client_secret`, SMTP host/port/user/password, lookup token.
The database key is generated once and also kept there.

---

## 4. Numbering (serie-número)

- Series per company and document type, created with defaults in the setup wizard:
  `F001` factura, `B001` boleta, `FC01`/`BC01` nota de crédito, `FD01`/`BD01` nota de débito,
  `T001` guía remitente, `P001` percepción, `R001` retención.
- Resumen diario `RC-YYYYMMDD-n`, comunicación de baja `RA-YYYYMMDD-n`,
  reversión `RR-YYYYMMDD-n`: sequential per day, generated automatically.
- The form suggests `serie-next_number`; the user may pick another series or override the
  number.
- Numbers are reserved at **emit**, never at draft, in one transaction:
  `numero = max(next_number, typed)`, insert document, `next_number = numero + 1`.
- A signed number is consumed even if rejected.
- One series per device if a company is used on several devices (no sync in v1).

---

## 5. Document status

Built on `xsender::models::Status` plus local states.

| Status | UI label | Origin | Actions |
|---|---|---|---|
| `draft` | Borrador | Being edited, no number | Edit, emit, delete |
| `pending_send` | Por enviar | Signed and stored, SUNAT has not answered (offline, transport error, "Emitir sin enviar") | Auto-retry, send now, deliver (with pending note) |
| `in_progress` | En proceso | `Ticket`, or ticket answer 98 (`Status::InProgress`) | Auto verify ticket, deliver (with pending note) |
| `accepted` | Aceptado | CDR, `Status::Accepted`, code 0, no notes | Deliver, notes, void |
| `accepted_with_observations` | Aceptado con observaciones | `Status::Accepted` code ≥ 4000 or CDR notes | Same as accepted, notes shown |
| `rejected` | Rechazado | `Status::Rejected` (2000–3999) | Final. "Duplicar como nuevo" |
| `exception` | Excepción | `Status::Exception` (99–1999) or local error (`LOCAL`) | Fix and resend with the same number |
| `unknown` | Desconocido | `Status::Unknown` | "Consultar en SUNAT" |
| `voiding` | Anulación en proceso | Baja / resumen / reversión sent, waiting for its ticket | Auto verify |
| `voided` | Anulado | Voiding document accepted | — |

```
draft ──emit──▶ pending_send ──send──▶ accepted | accepted_with_observations
                   ▲   │                 rejected | exception | unknown
     transport err ┘   └──▶ in_progress ──verify_ticket──▶ (any of the above)
accepted ──void──▶ voiding ──▶ voided
```

Rules:

- Emitting never needs internet (signing is local).
- `pending_send` retries with back-off (1m, 5m, 15m, 1h, hourly) while online;
  `in_progress`/`voiding` tickets are checked every few minutes.
- `exception` is never retried automatically.
- Code 1033 (registered previously, e.g. response lost on timeout) triggers
  `get_status_cdr` to recover the original CDR, where SUNAT supports it.
- Facturas and their notas are voided with a comunicación de baja (RA), boletas and
  their notas with a resumen diario (RC, estado 3), percepciones and retenciones with a
  reversión (RR), up to 7 days after issue. An invoice with live notas is voided after
  them. Rejections meaning SUNAT already has the voiding (2223, 2323, 2324, 2987) keep
  the document `voiding` instead of accepting it again.
- Guías de remisión remitente (09): transporte propio (vehicle + driver, or an M1/L
  car with SUNAT's indicator) or by a carrier; vehicles, drivers and addresses are
  saved as they are first used. A guía started from a factura/boleta carries its goods
  and references it (catalog 61). SUNAT has no beta for guías, so in test mode they
  are signed but not sent (local code `BETA_GUIA`); production needs the GRE API
  credentials (`NO_GRE_CREDENTIALS` otherwise).
- Percepciones (40) and retenciones (20) cover one collection or payment of one factura,
  in soles; the app computes the amounts (catalog 22: 2 %, 1 %, 0.5 %; catalog 23: 3 %),
  rounding half up to cents. SUNAT
  beta's `getStatus` doesn't work, so in test mode a ticket for a voiding document is
  taken as accepted (local code `BETA_TICKET`, explained to the user).
- HTTP 401 may be SUNAT throttling: every SUNAT request waits 3 s after the previous
  one, and a 401 is asked again twice before it's taken as wrong credentials.
- Sending deadlines live in one table (`deadlines.dart`): facturas and their notas 3
  calendar days after issue (RS 000003-2023), boletas and their notas 7 (SUNAT's
  orientation on resumen diario, to confirm). While SUNAT hasn't answered, the document page says until when SUNAT must
  receive it. Past the deadline the outbox stops sending a document it never sent (local
  code `PAST_DEADLINE`, explained to the user); one sent before keeps going, since SUNAT
  may have it and a resend recovers the CDR (1033). A manual "send now" still tries. Guías, percepciones,
  retenciones and voiding documents have no deadline in the app until confirmed.
- Voiding a document that was already delivered warns that SUNAT only voids documents
  the customer didn't receive (a nota de crédito is the way then).
- If a document that was already delivered becomes rejected, the app warns and lists the
  deliveries so the user can notify the customer.
- Every attempt is recorded in `document_event` and shown as a timeline.
- Status changes from background work raise a local notification.

---

## 6. Documents and flows

| Document | Entry point | Notes |
|---|---|---|
| Boleta (03) | Quick sale, full form | Sent individually |
| Factura (01) | Full form | |
| Nota de crédito (07) / débito (08) | Document detail → "Emitir nota" | Affected document and lines prefilled. Type 13 (facturas al crédito): the corrected cuotas, with one line at zero |
| Guía de remisión remitente (09) | Full form (GRE) | REST + OAuth (GRE credentials), asynchronous ticket. Vehicle/driver/address catalogs |
| Percepción (40) / Retención (20) | Full form | Only shown if the company is agente de percepción / retención |
| Comunicación de baja (RA) | Document detail → "Anular" (facturas, notas F) | Generated by the app |
| Resumen diario (RC) | Document detail → "Anular" (boletas, notas B) | Estado 3 (anulado). Generated by the app |
| Reversión (RR) | Document detail → "Anular" (percepción, retención) | Generated by the app |

Voiding documents are rows in `document` with their own status; the original points to
them via `voided_by_document_id`.

### 6.1 Quick sale ("Venta rápida")

Favorites grid + search, tap to add, quantity ±, total, `COBRAR`. Always a boleta in PEN to
"Clientes varios"; above the SUNAT threshold for unidentified customers the app asks for a
DNI. Optional change calculator (UI only). Result sheet has a big "Nueva venta" button.

### 6.2 Full form ("Nuevo comprobante")

Type, series-number (suggested), date, customer (search / lookup / new), currency (+ exchange
rate), lines (catalog or free text), forma de pago (contado / crédito with cuotas),
"Más opciones" (observaciones, orden de compra, guías, descuentos, cargos, anticipos,
tipo de operación). Live totals by calling `build_document` with a 300 ms debounce.

Currency: soles, dollars or euros. In dollars or euros the exchange rate (soles per unit,
the SBS selling rate of the issue date) is typed by the user and required; catalog prices
(in soles) are converted at it when a product is added, and stay editable; products
can't be added before the rate is typed. Lines already added aren't converted again
when the currency or rate changes (the form says so). The S/ 700 limit for unidentified
customers counts the total in soles.

Progressive disclosure for taxes:

| Feature | Configured on | Appears when |
|---|---|---|
| IGV type | Product (company default) | Per line chip if not default |
| ISC, ICB | Product | Automatic |
| Detracción | Company account + product code and rate | Automatic on facturas in soles over S/ 700 with a subject line (built: the highest rate applies, deposit in the Banco de la Nación; installments add up to the total less it) |
| Percepción | Company flag | Only for agentes de percepción |
| Exportación | Tipo de operación | Switches IGV to export, foreign customer fields |
| Anticipos | "Más opciones" | Pick an earlier advance invoice |

xbuilder enricher errors are shown inline, translated to Spanish by one mapping table.

### 6.3 Emit

```
[Emitir] → build_document → sign → save (pending_send, number reserved) → send (30 s)
         → result sheet: status + SUNAT message + [Enviar al cliente] / [Corregir] / [Duplicar]
```

Overflow option: "Emitir sin enviar".

---

## 7. PDF (printed representation)

- Generated on demand in Dart (`pdf` package) from `enriched_json`; not stored.
- Contents: logo, company, document title, customer, lines, totals, amount in words
  (legend from xbuilder), forma de pago, detracción/percepción info, SUNAT QR
  (`RUC|TIPO|SERIE|NUMERO|IGV|TOTAL|FECHA|TIPO_DOC_CLIENTE|NUM_DOC_CLIENTE|HASH|`,
  HASH = `digest_value`), "Representación impresa de …", consult URL.
- GRE uses the QR link SUNAT returns in the guía's CDR (`cbc:DocumentDescription`),
  read from the stored CDR when printing, so guías print once accepted.
- While `pending_send`/`in_progress`: banner "Pendiente de confirmación de SUNAT".
  Rejected, voided and voiding documents aren't printed.

### 7.1 Templates

```dart
abstract class PdfTemplate {
  String get id;            // "default-a4", "default-ticket-80", …
  String get name;          // shown in settings
  PdfFormat get format;     // a4 | ticket80 | ticket58
  Future<Uint8List> render(DocumentView doc, TemplateOptions options);
}
```

- `DocumentView`: a flat, ready-to-print model built from `enriched_json` + company + status.
  Templates never read the database or compute taxes.
- `TemplateOptions`: per-company customisation (primary color, logo on/off, footer text,
  show/hide optional fields).
- `TemplateRegistry`: list of available templates; the company picks one per format.
- Templates are Dart code shipped with the app: adding a template = adding a class and
  registering it. Users customise through `TemplateOptions`, they don't author templates.
- v1 ships `default-a4`, `default-ticket-80`, `default-ticket-58`; the user picks the
  format when sharing. Per-company `TemplateOptions` (color, logo, footer) aren't built
  yet. Text uses the bundled Open Sans (Apache-2.0): the PDF base fonts only cover
  Latin-1. The amount in words is written by the app (xbuilder leaves `leyendas` to
  the XML template).
- User-authored templates (e.g. HTML rendered to PDF) are out of scope; the interface does
  not prevent adding them later.

---

## 8. Delivery ("Enviar al cliente")

Attachments: PDF + XML (+ CDR optional).

| Channel | How |
|---|---|
| Email, Gmail/Workspace | Google Sign-In + Gmail API `gmail.send` (needs Google OAuth verification for public release) |
| Email, Outlook/M365 | Microsoft login + Graph `Mail.Send` |
| Email, other | SMTP + app password (`mailer`) |
| Anything else (WhatsApp, Telegram, Signal, Drive, Files…) | System share sheet (`share_plus`) |

Email subject/body templates per company (`{tipo} {serie}-{numero} de {razon_social}`).
Every delivery is logged in `delivery`.

Built so far: SMTP from the company's account (host, port, user and app password in
secure storage; a Gmail preset, since Outlook/Microsoft 365 no longer take app passwords
for SMTP; a test email), the share sheet, and the `deliveries` log shown on the document (a
dismissed share sheet isn't logged). A direct WhatsApp channel (an Android intent with
the unofficial `jid` extra to preselect the chat) was dropped: it was unreliable and
the share sheet already reaches WhatsApp on both platforms. Test-mode documents say "sin
validez tributaria" in the PDF and the email. The subject and body are fixed for now. Gmail
API and Graph wait for OAuth apps registered with Google and Microsoft (§14).

---

## 9. Backup and restore

- Snapshot: `VACUUM INTO` (consistent while running) + company secrets. The
  snapshot stays encrypted with this device's database key, so it is
  re-keyed (`PRAGMA rekey`) to a key derived from the backup password before
  uploading; a new device can't know the old device's key.
- Encryption: user backup password or generated 64-char key → Argon2id → AES-256-GCM
  (`cryptography`). Lost password = lost backup (stated in the UI).
- Destinations: Google Drive `appDataFolder` (Android), iCloud Drive container (iOS).
- Schedule: off / daily / weekly / monthly + "Copia de seguridad ahora", Wi-Fi only option.
  Android via `workmanager`; iOS best-effort background task + backup on launch when overdue.
- Restore: first launch "Restaurar copia" replaces everything.
- Per-company export/import: encrypted file with one company (data + secrets), shareable
  through the share sheet.

Built so far: "Copia de seguridad" saves an encrypted file of everything (database +
every company's secrets) through the share sheet (Drive, email, Files…), and "Restaurar
copia de seguridad" (welcome page and backup page) replaces everything from such a file.
File: `XHB1`, salt, nonce, secrets (JSON, AES-256-GCM), then the `VACUUM INTO` snapshot
re-keyed to the backup key, so the database is never on disk in clear. Argon2id with
RFC 9106's second recommendation (64 MiB, 3 iterations; fixed by the `XHB1` version),
password of at least 8 characters. Files are streamed, never held in memory. A backup
from a newer schema is refused; an older one migrates when the app opens it. Restoring
replaces the secrets, then swaps the database in one rename (an interrupted restore keeps
the old one), cancels the background outbox (a run already in progress is a residual
risk) and starts the app over with a new provider scope. The restored phone gets a new
`device_id`.

Per company: "Exportar solo …" writes the same file format with the active company
alone. In the snapshot, the other companies' rows and the device settings are deleted
and the file is vacuumed, so nothing of theirs is left in free pages. Only that
company's secrets go in the file, and it doesn't count as the last backup. "Importar
empresas de una copia" opens a company file or a full backup (an older schema is
upgraded first) and adds, in one transaction, every company whose RUC and id this phone
doesn't have, with its rows (copied by column name: migrated and fresh databases order
columns differently) and secrets. Nothing else changes and the app doesn't restart. A
company kept on two phones needs different series on each (§4).

---

## 10. Reports

- Sales summary by date range, document type, status, currency.
- Exports: CSV, Excel (`excel`). No PLE (replaced by SIRE, §14).
  One generator producing rows, several output formats.
- Exports are shared through the delivery module.

Built so far: "Reportes" shows a month's sales register (every issued factura, boleta and
nota of the current mode but the rejected ones, with its status; notas de crédito
subtract, voided ones have no amounts, unconfirmed ones are flagged) with totals per currency, exported as CSV (UTF-8 with BOM) or Excel. Files carry each document's
exchange rate and its total in soles (rate × total, half up). The `excel`
package conflicts with `pdf`'s `xml` version, so the app writes the one-sheet `.xlsx`
itself (inline strings, numeric amounts; checked with LibreOffice).

---

## 11. Security

- App lock (biometrics/PIN) on open and after N minutes in background (`local_auth`).
- Certificate check on import (`inspect_certificate`): password, RUC match, expiry; warning
  30 days before expiry.
- Encrypted database (SQLite3MultipleCiphers); secrets in Keystore/Keychain; no secrets in logs.

Built so far:
- **App lock ("Seguridad"):** off by default. When on, the app asks for the phone's own lock
  (`local_auth`: fingerprint, face, PIN or pattern) at start and after it was in the background
  for the chosen time (on leaving, or 1, 5 or 15 minutes). There is no app PIN to forget. A
  phone whose screen lock was removed opens without asking.
- **Hidden screens:** while the lock is on, the app's screens are hidden from recent apps and
  screenshots on Android (`FLAG_SECURE`) and covered in the iOS app switcher.
- **Expired certificates:** the app won't sign with an expired company certificate, so no
  number is lost to a rejection. The company home warns 30 days before expiry and links to
  the certificate page.
- **Error log:** errors the app couldn't show (uncaught errors and the background outbox
  included) go to a small file, without secrets. Diagnostics shares it with support. There is
  no crash-reporting service.

---

## 12. Project layout

```
xhandler-mobile/
├── rust/                    Cargo crate xhandler_bridge (the Rust API the app calls)
├── rust_builder/            cargokit glue (flutter_rust_bridge)
├── flutter_rust_bridge.yaml
├── lib/
│   ├── main.dart, app.dart, router.dart, strings.dart
│   ├── src/rust/            generated bindings (do not edit)
│   ├── data/                tables.dart, database.dart, secure_store.dart, providers.dart
│   └── features/
│       ├── company/  series/  customer/  product/  home/  diagnostics/
│       ├── document/ (list, quick_sale, form, detail, emit, voiding, outbox)
│       ├── despatch/ (guías de remisión; vehicles, drivers, addresses)
│       ├── pdf/ (registry, templates/)
│       ├── delivery/ (smtp, share)
│       ├── backup/  reports/
├── test/  integration_test/
├── android/  ios/
└── docs/DESIGN.md
```

Main packages: flutter_riverpod, go_router, drift, sqlite3 (hook `source: sqlite3mc`),
flutter_secure_storage, local_auth, workmanager, connectivity_plus,
flutter_local_notifications, google_sign_in, googleapis, msal (or equivalent), mailer,
cryptography, file_picker, share_plus, pdf, printing, excel.

---

## 13. Roadmap

| Phase | Repo | Deliverable |
|---|---|---|
| 0 | xhandler-rust | xsender on `rustls-tls`; xsigner rewritten in pure Rust (RustCrypto + exclusive C14N on quick-xml), byte-for-byte equal signatures vs current implementation, legacy PFX support; builds for Android and iOS targets |
| 1 | mobile | Scaffold (flutter_rust_bridge create), facade crate, CI (APK + iOS simulator), sign a sample invoice on a real phone |
| 2 | mobile | Drift schema + encryption (sqlite3mc), company wizard, secure storage, certificate import, series, customers (+ lookup), products |
| 3 | mobile | Emit & send: invoice/boleta full form + quick sale, numbering, status machine, outbox, 1033 recovery, notifications, timeline |
| 4 | mobile | Remaining documents: notes, GRE (with vehicle/driver/address catalogs), percepción, retención, voiding (RA/RC/RR) |
| 5 | mobile | PDF templates + delivery (Gmail, Graph, SMTP, share sheet), delivery log |
| 6 | mobile | Backup/restore (Drive, iCloud), per-company export/import |
| 7 | mobile | Reports: summary, CSV, Excel |
| 8 | mobile | Store readiness: privacy policy, data safety/privacy labels, Gmail OAuth verification, export compliance, release CI (Play internal track, TestFlight) |

One PR per phase, each followed by a senior-engineer review.

Phase 8 is prepared in [STORE.md](STORE.md): listing, privacy policy, Data safety and
privacy labels, export compliance notes, release signing (`android/key.properties`),
the app icon and a manual Release workflow; publishing needs the owner's accounts.

---

## 14. Open items

- Confirm the boletas' 7 days against a resolution, and the deadlines not in
  `deadlines.dart` yet (guías, percepciones, retenciones, reversiones) and whether the voiding window counts from the issue date or the CDR's.
- Boletas in other currencies aren't checked against the S/ 700 limit for unidentified
  customers (needs the exchange rate).
- Detracción: confirm the thresholds (the app uses S/ 400 for transporte de bienes, 027,
  and S/ 700 otherwise; Annex 1 goods may have none), whether the amount should be
  rounded to whole soles (deposits are; the app rounds half up to cents and gives that
  amount to xbuilder, so XML, installments and PDF agree), and the rule for facturas
  mixing goods with different rates (the app applies the highest). Facturas in other
  currencies get none (their amount must be in soles).
- Reduced IGV for small restaurants and hotels (Ley 31556: 10.5 % in 2026, 15 % in 2027):
  needs a company flag and confirming how SUNAT expects the rate in the XML.
- Pick the default free-tier RUC/DNI lookup provider in Phase 2 (check current quota and
  terms). Lookup sits behind one interface, `lookup(tipo, numero) → Cliente?`, implemented
  by Decolecta (company token). Results are cached in `customer`.
- Email through the Gmail API / Microsoft Graph instead of SMTP app passwords: needs
  OAuth clients registered (and, for Gmail's `gmail.send`, Google's verification) by
  the project owner.
- Automatic backups to Google Drive `appDataFolder` / iCloud Drive and their schedule:
  need a Google Cloud OAuth client and the iCloud entitlement for the app's Apple team.
- Detracción on facturas in dollars or euros: its amount must be in soles, and xbuilder
  prints it in the document's currency; until it supports that, only facturas in soles
  carry one. Likewise ICBPER (S/ 0.50 per bag) on documents in dollars or euros: confirm
  whether SUNAT expects it converted.
- PLE 14.1 isn't planned: SIRE replaced it (RS 000125-2026, from the October 2026
  period; new registrants from June 2026, RS 000075-2026) and builds the sales proposal
  from the electronic documents SUNAT already has. CSV/Excel stay for the user's own
  checks; a SIRE RVIE replacement file only if users ask for it.
- Multi-device sync through `xhandler-ui` (server + SQLite on xhandler-rust): later; the
  schema is ready (§3.1).
