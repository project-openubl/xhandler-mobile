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
String? optionalText(TextEditingController controller) {
  final text = controller.text.trim();
  return text.isEmpty ? null : text;
}
