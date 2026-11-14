import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';
import '../../src/rust/api/sunat.dart';

class DocumentRepository {
  DocumentRepository(this._db);

  final AppDatabase _db;

  /// Documents of the company in [environment], newest first
  Stream<List<Document>> watch(
    String companyId,
    SunatEnvironment environment, {
    Set<DocumentStatus> statuses = const {},
  }) {
    final query = _db.select(_db.documents)
      ..where(
        (d) =>
            d.companyId.equals(companyId) &
            d.environment.equalsValue(environment) &
            d.deletedAt.isNull() &
            (statuses.isEmpty
                ? const Constant(true)
                : d.status.isInValues(statuses)),
      )
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]);
    return query.watch();
  }

  Stream<Document> watchOne(String id) =>
      (_db.select(_db.documents)..where((d) => d.id.equals(id))).watchSingle();

  /// Documents of the company in [environment] with these types and
  /// statuses, issued from [from] to [to] ("YYYY-MM-DD", both included), in
  /// issue order
  Future<List<Document>> issued(
    String companyId,
    SunatEnvironment environment, {
    required String from,
    required String to,
    required Set<String> tipos,
    required Set<DocumentStatus> statuses,
  }) {
    final query = _db.select(_db.documents)
      ..where(
        (d) =>
            d.companyId.equals(companyId) &
            d.environment.equalsValue(environment) &
            d.deletedAt.isNull() &
            d.fechaEmision.isBetweenValues(from, to) &
            d.tipoComprobante.isIn(tipos) &
            d.status.isInValues(statuses),
      )
      ..orderBy([
        (d) => OrderingTerm(expression: d.fechaEmision),
        (d) => OrderingTerm(expression: d.tipoComprobante),
        (d) => OrderingTerm(expression: d.serie),
        (d) => OrderingTerm(expression: d.numero),
      ]);
    return query.get();
  }

  /// Notas, comunicaciones de baja and resúmenes of a document
  Stream<List<Document>> watchRelated(String documentId) =>
      _related(documentId).watch();

  Future<List<Document>> related(String documentId) =>
      _related(documentId).get();

  SimpleSelectStatement<$DocumentsTable, Document> _related(String id) =>
      _db.select(_db.documents)
        ..where((d) => d.affectedDocumentId.equals(id) & d.deletedAt.isNull())
        ..orderBy([(d) => OrderingTerm(expression: d.createdAt)]);

  Future<Document> find(String id) =>
      (_db.select(_db.documents)..where((d) => d.id.equals(id))).getSingle();

  Stream<List<DocumentEvent>> watchEvents(String documentId) {
    final query = _db.select(_db.documentEvents)
      ..where((e) => e.documentId.equals(documentId))
      ..orderBy([(e) => OrderingTerm(expression: e.createdAt)]);
    return query.watch();
  }

  Future<Uint8List?> file(String documentId, DocumentFileKind kind) async {
    final query = _db.select(
      _db.documentFiles,
    )..where((f) => f.documentId.equals(documentId) & f.kind.equalsValue(kind));
    return (await query.getSingleOrNull())?.bytes;
  }

  /// Documents waiting for SUNAT whose next attempt is due (the outbox)
  Future<List<Document>> due(DateTime now) {
    final query = _db.select(_db.documents)
      ..where(
        (d) =>
            d.deletedAt.isNull() &
            d.status.isInValues(const [
              DocumentStatus.pendingSend,
              DocumentStatus.inProgress,
            ]) &
            (d.nextAttemptAt.isNull() |
                d.nextAttemptAt.isSmallerOrEqualValue(now)),
      )
      ..orderBy([(d) => OrderingTerm(expression: d.createdAt)]);
    return query.get();
  }

  /// Highest number issued in the serie, 0 when none
  Future<int> lastNumero(
    String companyId,
    SunatEnvironment environment,
    String tipoComprobante,
    String serie,
  ) async {
    final last = _db.documents.numero.max();
    final query = _db.selectOnly(_db.documents)
      ..addColumns([last])
      ..where(
        _db.documents.companyId.equals(companyId) &
            _db.documents.environment.equalsValue(environment) &
            _db.documents.tipoComprobante.equals(tipoComprobante) &
            _db.documents.serie.equals(serie),
      );
    return (await query.map((row) => row.read(last)).getSingle()) ?? 0;
  }
}

final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(ref.watch(databaseProvider)),
);

/// Filters of the document list
enum DocumentFilter {
  all({}),
  pending({
    DocumentStatus.pendingSend,
    DocumentStatus.inProgress,
    DocumentStatus.voiding,
  }),
  accepted({DocumentStatus.accepted, DocumentStatus.acceptedWithObservations}),
  problems({
    DocumentStatus.rejected,
    DocumentStatus.exception,
    DocumentStatus.unknown,
  });

  const DocumentFilter(this.statuses);

  final Set<DocumentStatus> statuses;
}

final documentsProvider = StreamProvider.autoDispose
    .family<
      List<Document>,
      ({String companyId, SunatEnvironment environment, DocumentFilter filter})
    >(
      (ref, query) => ref
          .watch(documentRepositoryProvider)
          .watch(
            query.companyId,
            query.environment,
            statuses: query.filter.statuses,
          ),
    );

final documentProvider = StreamProvider.autoDispose.family<Document, String>(
  (ref, id) => ref.watch(documentRepositoryProvider).watchOne(id),
);

final documentEventsProvider = StreamProvider.autoDispose
    .family<List<DocumentEvent>, String>(
      (ref, id) => ref.watch(documentRepositoryProvider).watchEvents(id),
    );

final relatedDocumentsProvider = StreamProvider.autoDispose
    .family<List<Document>, String>(
      (ref, id) => ref.watch(documentRepositoryProvider).watchRelated(id),
    );
