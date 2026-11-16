import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../strings.dart';

/// Labeled text field of the app's forms; [validator] receives trimmed text,
/// and runs when the field is left, so mistakes show before saving.
/// [obscureText] fields get a show/hide button. [required] fields show an
/// asterisk after the label (pair them with a [RequiredFieldsLegend]) and
/// reject empty text before running [validator].
class FormTextField extends StatefulWidget {
  const FormTextField(
    this.controller,
    this.label, {
    super.key,
    this.enabled = true,
    this.required = false,
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
  final bool required;
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
        autovalidateMode: AutovalidateMode.onUnfocus,
        decoration: InputDecoration(
          labelText: widget.required ? null : widget.label,
          label: widget.required ? RequiredLabel(widget.label) : null,
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
        validator: validator == null && !widget.required
            ? null
            : (text) {
                final trimmed = text!.trim();
                if (widget.required && trimmed.isEmpty) return Strings.required;
                return validator?.call(trimmed);
              },
      ),
    );
  }
}

/// A message about something wrong, in the theme's error color
class ErrorText extends StatelessWidget {
  const ErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Text(
    message,
    style: TextStyle(color: Theme.of(context).colorScheme.error),
  );
}

/// Label followed by a red asterisk, for what must be filled in before
/// saving: text fields, and the pickers and lists that start empty. Fields
/// that always have a value (dropdowns, dates, switches) aren't marked.
/// Screen readers announce "obligatorio" instead of "asterisk".
class RequiredLabel extends StatelessWidget {
  const RequiredLabel(this.label, {super.key, this.style});

  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: style,
      TextSpan(
        text: label,
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
      semanticsLabel: '$label, ${Strings.required.toLowerCase()}',
    );
  }
}

/// Explains the asterisk of [RequiredLabel]; goes at the top of the form
class RequiredFieldsLegend extends StatelessWidget {
  const RequiredFieldsLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '* ',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            const TextSpan(text: Strings.requiredFieldsLegend),
          ],
        ),
        semanticsLabel: Strings.requiredFieldsLegendSemantics,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
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

/// Title of a group of fields; [required] for a list that needs an entry
class FormSection extends StatelessWidget {
  const FormSection(this.title, {super.key, this.required = false});

  final String title;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: required
          ? RequiredLabel(title, style: style)
          : Text(title, style: style),
    );
  }
}

/// What's still missing before the button under it works; nothing when
/// [missing] is empty
class MissingFieldsHint extends StatelessWidget {
  const MissingFieldsHint(this.missing, {super.key});

  /// Labels of the required fields still empty
  final List<String> missing;

  @override
  Widget build(BuildContext context) {
    if (missing.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        Strings.completeToEmit(missing),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
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
      scrollable: true,
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

/// Asks before leaving a form whose changes would be lost; [dirty] once
/// the user changed something. Forms that pop themselves after saving
/// aren't asked.
class UnsavedChangesGuard extends StatelessWidget {
  const UnsavedChangesGuard({
    super.key,
    required this.dirty,
    required this.child,
  });

  final bool dirty;
  final Widget child;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !dirty,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;
      final discard = await confirm(
        context,
        message: Strings.discardChanges,
        accept: Strings.discard,
      );
      if (discard && context.mounted) Navigator.of(context).pop();
    },
    child: child,
  );
}

/// Something couldn't be loaded, and a way to try again
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(Strings.unexpectedError),
        const SizedBox(height: 8),
        TextButton(onPressed: onRetry, child: const Text(Strings.retry)),
      ],
    ),
  );
}
