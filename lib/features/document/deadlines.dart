import '../../data/database.dart';

/// Calendar days after its issue date SUNAT still takes [document],
/// counted from the next day (so the last day is the issue date plus
/// these): facturas and their notas 3 (RS 000003-2023), boletas and their
/// notas 7 (SUNAT's orientation on resumen diario; to confirm, DESIGN §14).
/// `null` where the app has no deadline yet: guías, percepciones,
/// retenciones and voiding documents.
int? sendingDays(Document document) => switch (document.tipoComprobante) {
  '01' => 3,
  '03' => 7,
  '07' || '08' => document.serie.startsWith('F') ? 3 : 7,
  _ => null,
};

/// The last day ("YYYY-MM-DD") to send [document] to SUNAT, if it has one
String? sendingDeadline(Document document) {
  final days = sendingDays(document);
  if (days == null) return null;
  final last = DateTime.parse('${document.fechaEmision}T00:00Z')
      .add(Duration(days: days));
  return last.toIso8601String().substring(0, 10);
}

/// Whether [today] ("YYYY-MM-DD", Peru's date) is after [document]'s
/// sending deadline
bool pastSendingDeadline(Document document, String today) {
  final deadline = sendingDeadline(document);
  return deadline != null && today.compareTo(deadline) > 0;
}
