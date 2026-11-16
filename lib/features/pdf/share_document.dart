import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/database.dart';
import '../../src/rust/api/sunat.dart';
import '../document/document_repository.dart';
import 'document_view.dart';
import 'pdf_templates.dart';

/// A file to deliver with a document
typedef DeliveryFile = ({String name, String mimeType, Uint8List bytes});

/// SUNAT's file name of a document: "20123456789-01-F001-1"
String sunatFileName(Company company, Document document) =>
    '${company.ruc}-${document.tipoComprobante}-${document.serie}-'
    '${document.numero}';

/// The printed document with [template], its signed XML and SUNAT's CDR
/// (once SUNAT answered): what the customer gets (docs/DESIGN.md §8)
Future<List<DeliveryFile>> deliveryFiles({
  required Company company,
  required Document document,
  required DocumentRepository documents,
  required PdfTemplate template,
}) async {
  final name = sunatFileName(company, document);
  final xml = await documents.file(document.id, DocumentFileKind.signedXml);
  final cdr = await documents.file(document.id, DocumentFileKind.cdrZip);
  final pdf = await template.render(
    documentView(
      document,
      company,
      guiaQr: document.tipoComprobante == '09' ? _guiaQr(document, cdr) : null,
    ),
    await loadPdfTheme(),
  );
  return [
    (name: '$name.pdf', mimeType: 'application/pdf', bytes: pdf),
    if (xml != null)
      (name: '$name.xml', mimeType: 'application/xml', bytes: xml),
    if (cdr != null)
      (name: 'R-$name.zip', mimeType: 'application/zip', bytes: cdr),
  ];
}

/// An accepted guía whose CDR has no QR link (or that has no CDR): without
/// it, the guía has no valid printed representation
class MissingGuiaQrError implements Exception {
  const MissingGuiaQrError(this.documentId);

  final String documentId;

  @override
  String toString() => 'MissingGuiaQrError: no QR link for guía $documentId';
}

/// The QR link of an accepted guía, from its CDR
String _guiaQr(Document guia, Uint8List? cdr) {
  final link = cdr == null ? null : guiaQrLink(cdrZip: cdr);
  return link ?? (throw MissingGuiaQrError(guia.id));
}

/// Shares [files] with an app the user picks; [anchor] places the share
/// sheet on iPads. `false` when the user closed the sheet.
Future<bool> shareFiles(
  List<DeliveryFile> files, {
  required String subject,
  required BuildContext anchor,
}) async {
  final box = anchor.findRenderObject() as RenderBox?;
  final result = await SharePlus.instance.share(
    ShareParams(
      files: [
        for (final file in files)
          XFile.fromData(file.bytes, name: file.name, mimeType: file.mimeType),
      ],
      fileNameOverrides: [for (final file in files) file.name],
      subject: subject,
      sharePositionOrigin: box == null
          ? null
          : box.localToGlobal(Offset.zero) & box.size,
    ),
  );
  return result.status != ShareResultStatus.dismissed;
}
