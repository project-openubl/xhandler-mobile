import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../router.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import '../company/company_repository.dart';
import '../document/document_repository.dart';
import '../pdf/pdf_templates.dart';
import '../pdf/share_document.dart';
import 'delivery_service.dart';
import 'email_sender.dart';
import 'email_settings_page.dart';
import 'whatsapp.dart';

/// A delivery being prepared; a second tap meanwhile does nothing
bool _delivering = false;

/// Sends [document] to its customer: by email, WhatsApp or any other app
/// (docs/DESIGN.md §8). [anchor] places the share sheet on iPads.
Future<void> deliverDocument(
  BuildContext anchor,
  WidgetRef ref,
  Document document,
) async {
  final choice = await showModalBottomSheet<(DeliveryChannel, PdfTemplate)>(
    context: anchor,
    builder: (_) => const _DeliverySheet(),
  );
  if (choice == null || !anchor.mounted || _delivering) return;
  final (channel, template) = choice;
  final service = ref.read(deliveryServiceProvider);
  _delivering = true;
  try {
    final company = await ref
        .read(companyRepositoryProvider)
        .find(document.companyId);
    final contact = await service.contactOf(document);
    if (!anchor.mounted) return;
    switch (channel) {
      case DeliveryChannel.email:
        if (!await service.canEmail(company)) {
          if (anchor.mounted) {
            showMessage(anchor, Strings.emailNotConfigured);
            anchor.push(Routes.emailSettings);
          }
          return;
        }
        if (!anchor.mounted) return;
        final to = await _ask(
          anchor,
          title: Strings.sendByEmail,
          label: Strings.email,
          initial: contact.email,
          keyboardType: TextInputType.emailAddress,
          valid: (text) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text),
        );
        if (to == null || !anchor.mounted) return;
        showMessage(anchor, Strings.sending);
        await service.email(
          company: company,
          document: document,
          to: to,
          template: template,
        );
        if (anchor.mounted) showMessage(anchor, Strings.emailSent(to));
      case DeliveryChannel.whatsapp:
        final phone =
            whatsappNumber(contact.phone) ??
            whatsappNumber(
              await _ask(
                anchor,
                title: Strings.sendByWhatsapp,
                label: Strings.telefono,
                initial: contact.phone,
                keyboardType: TextInputType.phone,
                valid: (text) => whatsappNumber(text) != null,
              ),
            );
        if (phone == null || !anchor.mounted) return;
        final files = await deliveryFiles(
          company: company,
          document: document,
          documents: ref.read(documentRepositoryProvider),
          template: template,
        );
        final sent = await sendToWhatsApp(
          phone: phone,
          files: files,
          text: DeliveryService.subject(company, document),
        );
        if (!sent) {
          if (anchor.mounted) showMessage(anchor, Strings.whatsappMissing);
          return;
        }
        await service.record(document, DeliveryChannel.whatsapp, phone);
      case DeliveryChannel.share:
        final files = await deliveryFiles(
          company: company,
          document: document,
          documents: ref.read(documentRepositoryProvider),
          template: template,
        );
        if (!anchor.mounted) return;
        await shareFiles(
          files,
          subject: DeliveryService.subject(company, document),
          anchor: anchor,
        );
        await service.record(document, DeliveryChannel.share, null);
    }
  } on EmailException catch (error) {
    if (anchor.mounted) showMessage(anchor, emailErrorMessage(error.error));
  } on Object catch (error) {
    debugPrint('Delivery: $error');
    if (anchor.mounted) showMessage(anchor, Strings.unexpectedError);
  } finally {
    _delivering = false;
  }
}

/// A text the user confirms or types, e.g. the customer's email
Future<String?> _ask(
  BuildContext context, {
  required String title,
  required String label,
  required String? initial,
  required TextInputType keyboardType,
  required bool Function(String text) valid,
}) => showDialog<String>(
  context: context,
  builder: (_) => _AskDialog(
    title: title,
    label: label,
    initial: initial,
    keyboardType: keyboardType,
    valid: valid,
  ),
);

class _AskDialog extends StatefulWidget {
  const _AskDialog({
    required this.title,
    required this.label,
    required this.initial,
    required this.keyboardType,
    required this.valid,
  });

  final String title;
  final String label;
  final String? initial;
  final TextInputType keyboardType;
  final bool Function(String text) valid;

  @override
  State<_AskDialog> createState() => _AskDialogState();
}

class _AskDialogState extends State<_AskDialog> {
  final _form = GlobalKey<FormState>();
  late final _text = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _form,
        child: FormTextField(
          _text,
          widget.label,
          keyboardType: widget.keyboardType,
          validator: (text) => widget.valid(text) ? null : Strings.invalidValue,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            if (_form.currentState!.validate()) {
              Navigator.pop(context, _text.text.trim());
            }
          },
          child: const Text(Strings.send),
        ),
      ],
    );
  }
}

/// The format and the channel
class _DeliverySheet extends StatefulWidget {
  const _DeliverySheet();

  @override
  State<_DeliverySheet> createState() => _DeliverySheetState();
}

class _DeliverySheetState extends State<_DeliverySheet> {
  PdfTemplate _template = pdfTemplates.first;

  @override
  Widget build(BuildContext context) {
    void choose(DeliveryChannel channel) =>
        Navigator.pop(context, (channel, _template));
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(title: Text(Strings.pdfFormat)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<PdfTemplate>(
              segments: [
                for (final template in pdfTemplates)
                  ButtonSegment(value: template, label: Text(template.name)),
              ],
              selected: {_template},
              onSelectionChanged: (selected) =>
                  setState(() => _template = selected.single),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text(Strings.sendByEmail),
            onTap: () => choose(DeliveryChannel.email),
          ),
          if (canSendToWhatsApp)
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text(Strings.sendByWhatsapp),
              onTap: () => choose(DeliveryChannel.whatsapp),
            ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text(Strings.otherApps),
            onTap: () => choose(DeliveryChannel.share),
          ),
        ],
      ),
    );
  }
}
