import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';
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
  final pdf = await template.render(
    documentView(document, company),
    await loadPdfTheme(),
  );
  final xml = await documents.file(document.id, DocumentFileKind.signedXml);
  final cdr = await documents.file(document.id, DocumentFileKind.cdrZip);
  return [
    (name: '$name.pdf', mimeType: 'application/pdf', bytes: pdf),
    if (xml != null)
      (name: '$name.xml', mimeType: 'application/xml', bytes: xml),
    if (cdr != null)
      (name: 'R-$name.zip', mimeType: 'application/zip', bytes: cdr),
  ];
}

/// A share in progress; a second tap meanwhile does nothing
bool _sharing = false;

/// Asks the format and shares the document's files with any app
Future<void> shareDocument(
  BuildContext context,
  WidgetRef ref,
  Document document,
) async {
  final template = await showModalBottomSheet<PdfTemplate>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(title: Text(Strings.pdfFormat)),
          for (final template in pdfTemplates)
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: Text(template.name),
              onTap: () => Navigator.pop(sheetContext, template),
            ),
        ],
      ),
    ),
  );
  if (template == null || !context.mounted || _sharing) return;
  final box = context.findRenderObject() as RenderBox?;
  _sharing = true;
  showMessage(context, Strings.preparingFiles);
  try {
    final company = await ref
        .read(companyRepositoryProvider)
        .find(document.companyId);
    final files = await deliveryFiles(
      company: company,
      document: document,
      documents: ref.read(documentRepositoryProvider),
      template: template,
    );
    await SharePlus.instance.share(
      ShareParams(
        files: [
          for (final file in files)
            XFile.fromData(
              file.bytes,
              name: file.name,
              mimeType: file.mimeType,
            ),
        ],
        fileNameOverrides: [for (final file in files) file.name],
        subject: '${company.razonSocial}: ${sunatFileName(company, document)}',
        // iPads anchor the share sheet to the button
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  } on Object catch (error) {
    debugPrint('Share: $error');
    if (context.mounted) showMessage(context, Strings.unexpectedError);
  } finally {
    _sharing = false;
  }
}
