import 'package:material_ui/material_ui.dart';

import '../../catalogs.dart';
import '../../data/database.dart';
import '../../strings.dart';
import '../../theme/status_colors.dart';
import 'draft_problem.dart';
import 'sunat_answer.dart';
import 'voiding.dart';

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
    DocumentStatus.voiding => 'Anulación en proceso',
    DocumentStatus.voided => 'Anulado',
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
    DocumentStatus.voiding =>
      'Se pidió a SUNAT anularlo. Se consultará automáticamente.',
    DocumentStatus.voided => 'SUNAT lo anuló; ya no tiene validez.',
  };

  IconData get icon => switch (this) {
    DocumentStatus.pendingSend => Icons.schedule,
    DocumentStatus.inProgress => Icons.hourglass_top,
    DocumentStatus.accepted => Icons.check_circle,
    DocumentStatus.acceptedWithObservations => Icons.check_circle_outline,
    DocumentStatus.rejected => Icons.cancel,
    DocumentStatus.exception => Icons.error,
    DocumentStatus.unknown => Icons.help,
    DocumentStatus.voiding => Icons.hourglass_top,
    DocumentStatus.voided => Icons.block,
  };

  Color color(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final status = StatusColors.of(context);
    return switch (this) {
      DocumentStatus.pendingSend => colors.primary,
      DocumentStatus.inProgress || DocumentStatus.voiding => status.warning,
      DocumentStatus.accepted ||
      DocumentStatus.acceptedWithObservations => status.success,
      DocumentStatus.rejected || DocumentStatus.exception => colors.error,
      DocumentStatus.unknown || DocumentStatus.voided => colors.outline,
    };
  }
}

/// What the user can do about each status: the detail page's button
extension DocumentStatusAction on DocumentStatus {
  /// `null` when there is nothing to do
  String? get actionLabel => switch (this) {
    DocumentStatus.pendingSend => 'Enviar ahora',
    DocumentStatus.inProgress => 'Consultar ticket',
    DocumentStatus.exception => 'Reintentar envío',
    DocumentStatus.unknown => 'Consultar en SUNAT',
    _ => null,
  };
}

/// "F001-00000042"; voiding documents "RA-20261113-1"
String serieNumero(String serie, int numero) => serie.contains('-')
    ? '$serie-$numero'
    : '$serie-${numero.toString().padLeft(8, '0')}';

/// Name of a document type: Catalog 1, or a voiding document
String tipoComprobanteLabel(String tipo) => switch (tipo) {
  comunicacionBaja => Strings.comunicacionBaja,
  resumenDiario => Strings.resumenDiario,
  reversion => Strings.reversion,
  _ => Catalogs.tiposComprobante[tipo] ?? tipo,
};

/// An xbuilder error in Spanish, e.g. "detalles[0].igv_tipo: 99 is not a
/// valid Catalog7" → "Un código no es válido: tipo de IGV (línea 1)"
String documentErrorMessage(String error) {
  const fields = {
    'igv_tipo': 'tipo de IGV',
    'isc_tipo': 'tipo de ISC',
    'tipo_documento_identidad': 'documento del cliente',
    'unidad_medida': 'unidad de medida',
    'moneda': 'moneda',
  };
  if (!error.contains('is not a valid')) {
    return 'Revisa los datos del comprobante.';
  }
  final field = fields.entries
      .where((field) => error.contains(field.key))
      .map((field) => field.value)
      .firstOrNull;
  final line = RegExp(r'detalles\[(\d+)\]').firstMatch(error)?.group(1);
  return [
    'Un código no es válido',
    if (field != null) ': $field',
    if (line != null) ' (línea ${int.parse(line) + 1})',
    '.',
  ].join();
}

/// Message of a SUNAT answer code that the app itself records
String? localCodeMessage(String? code) => switch (code) {
  LocalCodes.noCredentials =>
    'Faltan las credenciales SOL de la empresa (Empresa → Credenciales).',
  LocalCodes.error => 'Error de la aplicación al enviar.',
  LocalCodes.noGreCredentials =>
    'Faltan las credenciales de la API de guías (Empresa → Credenciales).',
  LocalCodes.betaGuia =>
    'Modo prueba: SUNAT no tiene ambiente de pruebas para guías; se firmó '
        'pero no se envió.',
  LocalCodes.betaTicket =>
    'SUNAT recibió la anulación. En modo prueba se da por aceptada: '
        'SUNAT beta no permite consultar su respuesta.',
  LocalCodes.pastDeadline =>
    'Venció el plazo para enviarlo a SUNAT y la app dejó de enviarlo. '
        'Puedes intentar enviarlo ahora; si SUNAT lo rechaza, emite el '
        'comprobante de nuevo.',
  'HTTP 401' =>
    'SUNAT no aceptó el usuario o la clave SOL (Empresa → Credenciales).',
  _ => null,
};

String draftProblemMessage(DraftProblem problem) => switch (problem) {
  DraftProblem.noLines => 'Agrega al menos un producto.',
  DraftProblem.facturaWithoutRuc => 'Las facturas son para clientes con RUC.',
  DraftProblem.customerWithoutRuc =>
    'Las percepciones y retenciones son para empresas con RUC.',
  DraftProblem.missingAddresses => 'Indica el punto de partida y de llegada.',
  DraftProblem.missingTransport =>
    'Indica el vehículo y el conductor, o el transportista con RUC.',
  DraftProblem.missingMotivo => 'Describe el motivo del traslado.',
  DraftProblem.anonymousDestinatario =>
    'Elige un destinatario con documento de identidad.',
  DraftProblem.missingCodigoLocal =>
    'Indica el código de establecimiento de ambos puntos.',
  DraftProblem.operacionOverTotal =>
    'El importe debe ser mayor que cero y no superar el total de la factura.',
  DraftProblem.anonymousOver700 =>
    'Las boletas de más de S/ 700 necesitan el DNI del cliente.',
  DraftProblem.cuotasMismatch =>
    'Las cuotas deben sumar el total (menos la detracción, si la hay) y '
        'vencer después de hoy.',
  DraftProblem.cuotasNotDue => 'Las cuotas deben vencer después de hoy.',
  DraftProblem.missingTipoCambio =>
    'Escribe el tipo de cambio (venta SBS del día) para emitir en otra '
        'moneda.',
  DraftProblem.missingDetraccionAccount =>
    'La factura tiene detracción: registra la cuenta de detracciones del '
        'Banco de la Nación en Empresa → Datos de la empresa.',
  DraftProblem.noteSerieMismatch =>
    'Las notas de facturas usan series F y las de boletas, series B.',
  DraftProblem.invalidAffectedDocument =>
    'Las notas modifican facturas y boletas aceptadas por SUNAT.',
  DraftProblem.invalidAjuste =>
    'El ajuste de montos y fechas de pago corrige las cuotas de una factura '
        'al crédito.',
  DraftProblem.noteExceedsInvoice =>
    'Las notas de crédito no pueden sumar más que el comprobante.',
  DraftProblem.voidNotesFirst => 'Anula primero sus notas de crédito y débito.',
  DraftProblem.notVoidable =>
    'Solo se anulan comprobantes aceptados por SUNAT.',
  DraftProblem.voidingTooLate =>
    'El plazo para anularlo venció ($voidingDays días); '
        'emite una nota de crédito.',
};

/// Small status chip for lists
class DocumentStatusChip extends StatelessWidget {
  const DocumentStatusChip(this.status, {super.key});

  final DocumentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(status.icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          status.label,
          style: Theme.of(context).textTheme.labelMedium
              ?.copyWith(color: color),
        ),
      ],
    );
  }
}
