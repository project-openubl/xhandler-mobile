import '../../data/database.dart';
import '../../src/rust/api/sunat.dart';

/// Codes of local problems recorded as SUNAT answers
abstract final class LocalCodes {
  /// The app couldn't send or read the answer (a bug or corrupt data)
  static const error = 'LOCAL';

  /// Production without SOL credentials
  static const noCredentials = 'NO_CREDENTIALS';

  /// Production guías without the GRE API credentials
  static const noGreCredentials = 'NO_GRE_CREDENTIALS';

  /// A guía in test mode: SUNAT has no beta for guías, so it's signed but
  /// not sent
  static const betaGuia = 'BETA_GUIA';

  /// A ticket from SUNAT beta, which can't check tickets: test mode takes
  /// the comunicación de baja or resumen as accepted
  static const betaTicket = 'BETA_TICKET';

  /// Never answered and past SUNAT's deadline (deadlines.dart): the outbox
  /// stops sending it
  static const pastDeadline = 'PAST_DEADLINE';
}

/// Statuses of documents SUNAT accepted
const acceptedStatuses = {
  DocumentStatus.accepted,
  DocumentStatus.acceptedWithObservations,
};

/// The document status a SUNAT answer leads to (docs/DESIGN.md §5)
DocumentStatus statusOf(SunatResponse response) => switch (response.status) {
  SunatStatus.accepted
      when response.notes.isNotEmpty ||
          (int.tryParse(response.code ?? '') ?? 0) >= 4000 =>
    DocumentStatus.acceptedWithObservations,
  SunatStatus.accepted => DocumentStatus.accepted,
  SunatStatus.rejected => DocumentStatus.rejected,
  SunatStatus.exception => DocumentStatus.exception,
  SunatStatus.inProgress => DocumentStatus.inProgress,
  SunatStatus.unknown => DocumentStatus.unknown,
  SunatStatus.notDelivered => DocumentStatus.pendingSend,
};
