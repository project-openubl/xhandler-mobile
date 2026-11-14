import 'package:material_ui/material_ui.dart';

/// Labeled text field of the app's forms; [validator] receives trimmed text
class FormTextField extends StatelessWidget {
  const FormTextField(
    this.controller,
    this.label, {
    super.key,
    this.enabled = true,
    this.obscureText = false,
    this.helperText,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool enabled;
  final bool obscureText;
  final String? helperText;
  final TextInputType? keyboardType;
  final String? Function(String text)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, helperText: helperText),
        validator: validator == null
            ? null
            : (text) => validator!(text!.trim()),
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

/// Trimmed text, or `null` when empty
String? optionalText(TextEditingController controller) {
  final text = controller.text.trim();
  return text.isEmpty ? null : text;
}
