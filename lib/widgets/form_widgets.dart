import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../strings.dart';

/// Labeled text field of the app's forms; [validator] receives trimmed text.
/// [obscureText] fields get a show/hide button.
class FormTextField extends StatefulWidget {
  const FormTextField(
    this.controller,
    this.label, {
    super.key,
    this.enabled = true,
    this.obscureText = false,
    this.digitsOnly = false,
    this.maxLength,
    this.helperText,
    this.prefixText,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool obscureText;
  final bool digitsOnly;
  final int? maxLength;
  final String? helperText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final String? Function(String text)? validator;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    final validator = widget.validator;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        obscureText: _obscured,
        maxLength: widget.maxLength,
        keyboardType: widget.digitsOnly
            ? TextInputType.number
            : widget.keyboardType,
        inputFormatters: widget.digitsOnly
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: widget.helperText,
          prefixText: widget.prefixText,
          counterText: '',
          suffixIcon: widget.obscureText
              ? IconButton(
                  tooltip: _obscured ? Strings.show : Strings.hide,
                  icon: Icon(
                    _obscured ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscured = !_obscured),
                )
              : null,
        ),
        validator: validator == null ? null : (text) => validator(text!.trim()),
      ),
    );
  }
}

/// Dropdown of a SUNAT catalog (code → name). With [noneLabel], the first
/// option is `null`.
class CatalogDropdown extends StatelessWidget {
  const CatalogDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.noneLabel,
  });

  final String label;
  final String? value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;
  final String? noneLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String?>(
        // Long catalog names are cut instead of overflowing narrow phones
        isExpanded: true,
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          if (noneLabel != null) DropdownMenuItem(child: Text(noneLabel!)),
          for (final MapEntry(:key, :value) in options.entries)
            DropdownMenuItem(value: key, child: Text(value)),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

/// App bar button that deletes after asking, then closes the page
class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.message,
    required this.onDelete,
  });

  final String message;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: Strings.delete,
      icon: const Icon(Icons.delete),
      onPressed: () async {
        if (!await confirm(context, message: message, accept: Strings.delete)) {
          return;
        }
        await onDelete();
        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}

class FormSection extends StatelessWidget {
  const FormSection(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

/// Runs [onPressed] showing progress; disabled meanwhile, so a double tap
/// doesn't save twice
class SaveButton extends StatefulWidget {
  const SaveButton({
    super.key,
    required this.onPressed,
    this.label = Strings.save,
    this.filled = false,
  });

  /// `null` disables the button
  final Future<void> Function()? onPressed;
  final String label;
  final bool filled;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _busy = false;

  Future<void> _run() async {
    setState(() => _busy = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onPressed = _busy || widget.onPressed == null ? null : _run;
    final child = _busy
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(widget.label);
    return widget.filled
        ? FilledButton(onPressed: onPressed, child: child)
        : TextButton(onPressed: onPressed, child: child);
  }
}

/// Asks before doing something; `true` when the user accepts
Future<bool> confirm(
  BuildContext context, {
  String? title,
  required String message,
  required String accept,
}) async {
  final accepted = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: title == null ? null : Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(accept),
        ),
      ],
    ),
  );
  return accepted ?? false;
}

void showMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

/// Trimmed text, or `null` when empty
/// A plausible email address, without spaces (so no header injection)
bool isEmail(String text) => RegExp(r'^\S+@\S+\.\S+$').hasMatch(text);

String? optionalText(TextEditingController controller) {
  final text = controller.text.trim();
  return text.isEmpty ? null : text;
}
