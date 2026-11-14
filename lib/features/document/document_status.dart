import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import 'document_service.dart';

/// How each document status looks (docs/DESIGN.md §5)
extension DocumentStatusView on DocumentStatus {
  String get label => switch (this) {
    DocumentStatus.pendingSend => 'Por enviar',
    DocumentStatus.inProgress => 'En proceso',
    DocumentStatus.accepted => 'Aceptado',
    DocumentStatus.acceptedWithObservations => 'Aceptado con observaciones',
    DocumentStatus.rejected => 'Rechazado',
    DocumentStatus.exception => 'Excepción',
    DocumentStatus.unknown => 'Desconocido',
  };

  /// What it means for the user
  String get help => switch (this) {
    DocumentStatus.pendingSend =>
      'Guardado en el teléfono. Se enviará a SUNAT automáticamente.',
    DocumentStatus.inProgress =>
      'SUNAT lo está procesando. Se consultará automáticamente.',
    DocumentStatus.accepted => 'SUNAT aceptó el comprobante.',
    DocumentStatus.acceptedWithObservations =>
      'SUNAT lo aceptó con observaciones; corrígelas en los próximos.',
    DocumentStatus.rejected =>
      'SUNAT lo rechazó. Emite uno nuevo con los datos corregidos.',
    DocumentStatus.exception =>
      'SUNAT no lo procesó. Corrige el problema y vuelve a enviarlo.',
    DocumentStatus.unknown => 'No se sabe si SUNAT lo tiene. Consúltalo.',
  };

  IconData get icon => switch (this) {
    DocumentStatus.pendingSend => Icons.schedule,
    DocumentStatus.inProgress => Icons.hourglass_top,
    DocumentStatus.accepted => Icons.check_circle,
    DocumentStatus.acceptedWithObservations => Icons.check_circle_outline,
    DocumentStatus.rejected => Icons.cancel,
    DocumentStatus.exception => Icons.error,
    DocumentStatus.unknown => Icons.help,
  };

  Color color(ColorScheme colors) => switch (this) {
    DocumentStatus.pendingSend => colors.primary,
    DocumentStatus.inProgress => Colors.amber.shade800,
    DocumentStatus.accepted ||
    DocumentStatus.acceptedWithObservations => Colors.green.shade700,
    DocumentStatus.rejected || DocumentStatus.exception => colors.error,
    DocumentStatus.unknown => colors.outline,
  };
}

/// Message of a SUNAT answer code that the app itself records
String? localCodeMessage(String? code) => switch (code) {
  LocalCodes.noCredentials =>
    'Faltan las credenciales SOL de la empresa (Empresa → Credenciales).',
  LocalCodes.error => 'Error de la aplicación al enviar.',
  _ => null,
};

String draftProblemMessage(DraftProblem problem) => switch (problem) {
  DraftProblem.noLines => 'Agrega al menos un producto.',
  DraftProblem.facturaWithoutRuc => 'Las facturas son para clientes con RUC.',
  DraftProblem.anonymousOver700 =>
    'Las boletas de más de S/ 700 necesitan el DNI del cliente.',
  DraftProblem.cuotasMismatch =>
    'Las cuotas deben sumar el total y vencer después de hoy.',
};

/// Small status chip for lists
class DocumentStatusChip extends StatelessWidget {
  const DocumentStatusChip(this.status, {super.key});

  final DocumentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(Theme.of(context).colorScheme);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status.icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(status.label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
