import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../data/providers.dart';

/// Vehicles, drivers and addresses of guías de remisión, saved as they are
/// first used
class TransportRepository {
  TransportRepository(this._db);

  final AppDatabase _db;

  Stream<List<Vehicle>> watchVehicles(String companyId) =>
      (_db.select(_db.vehicles)
            ..where((v) => v.companyId.equals(companyId) & v.deletedAt.isNull())
            ..orderBy([(v) => OrderingTerm(expression: v.placa)]))
          .watch();

  Stream<List<Driver>> watchDrivers(String companyId) =>
      (_db.select(_db.drivers)
            ..where((d) => d.companyId.equals(companyId) & d.deletedAt.isNull())
            ..orderBy([(d) => OrderingTerm(expression: d.apellidos)]))
          .watch();

  Stream<List<Address>> watchAddresses(String companyId) =>
      (_db.select(_db.addresses)
            ..where((a) => a.companyId.equals(companyId) & a.deletedAt.isNull())
            ..orderBy([(a) => OrderingTerm(expression: a.createdAt)]))
          .watch();

  Future<Vehicle> createVehicle(VehiclesCompanion vehicle) =>
      _db.into(_db.vehicles).insertReturning(vehicle);

  Future<Driver> createDriver(DriversCompanion driver) =>
      _db.into(_db.drivers).insertReturning(driver);

  Future<Address> createAddress(AddressesCompanion address) =>
      _db.into(_db.addresses).insertReturning(address);

  Future<void> deleteVehicle(String id) => _db.softDelete(_db.vehicles, id);

  Future<void> deleteDriver(String id) => _db.softDelete(_db.drivers, id);

  Future<void> deleteAddress(String id) => _db.softDelete(_db.addresses, id);
}

final transportRepositoryProvider = Provider(
  (ref) => TransportRepository(ref.watch(databaseProvider)),
);

final vehiclesProvider = StreamProvider.autoDispose
    .family<List<Vehicle>, String>(
      (ref, companyId) =>
          ref.watch(transportRepositoryProvider).watchVehicles(companyId),
    );

final driversProvider = StreamProvider.autoDispose.family<List<Driver>, String>(
  (ref, companyId) =>
      ref.watch(transportRepositoryProvider).watchDrivers(companyId),
);

final addressesProvider = StreamProvider.autoDispose
    .family<List<Address>, String>(
      (ref, companyId) =>
          ref.watch(transportRepositoryProvider).watchAddresses(companyId),
    );
