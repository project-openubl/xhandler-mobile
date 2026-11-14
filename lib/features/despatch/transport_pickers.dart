import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../strings.dart';
import '../../widgets/form_widgets.dart';
import 'despatch_advice_draft.dart';
import 'transport_repository.dart';

/// A saved vehicle, or a new one
Future<Vehicle?> pickVehicle(BuildContext context, Company company) =>
    _pick<Vehicle, Vehicle>(
      context,
      items: vehiclesProvider(company.id),
      title: (vehicle) => vehicle.placa,
      subtitle: (vehicle) => vehicle.numeroCirculacion,
      delete: (ref, vehicle) =>
          ref.read(transportRepositoryProvider).deleteVehicle(vehicle.id),
      newLabel: Strings.newVehicle,
      create: (context) => showDialog<Vehicle>(
        context: context,
        builder: (_) => _VehicleDialog(company),
      ),
    );

/// A saved driver, or a new one
Future<Driver?> pickDriver(BuildContext context, Company company) =>
    _pick<Driver, Driver>(
      context,
      items: driversProvider(company.id),
      title: (driver) => '${driver.nombres} ${driver.apellidos}',
      subtitle: (driver) =>
          '${driver.numeroDocumentoIdentidad} · ${Strings.licencia} '
          '${driver.licencia}',
      delete: (ref, driver) =>
          ref.read(transportRepositoryProvider).deleteDriver(driver.id),
      newLabel: Strings.newDriver,
      create: (context) => showDialog<Driver>(
        context: context,
        builder: (_) => _DriverDialog(company),
      ),
    );

/// A saved address, one of [suggested] (e.g. the company's), or a new one
Future<GuiaPoint?> pickAddress(
  BuildContext context,
  Company company, {
  List<(String, GuiaPoint)> suggested = const [],
}) => _pick<GuiaPoint, Address>(
  context,
  items: addressesProvider(company.id),
  title: (address) => address.nombre ?? address.direccion,
  subtitle: (address) => [
    ?address.nombre == null ? null : address.direccion,
    address.ubigeo,
  ].join(' · '),
  delete: (ref, address) =>
      ref.read(transportRepositoryProvider).deleteAddress(address.id),
  newLabel: Strings.newAddress,
  create: (context) async {
    final address = await showDialog<Address>(
      context: context,
      builder: (_) => _AddressDialog(company),
    );
    return address == null ? null : _point(address);
  },
  toResult: _point,
  leading: [
    for (final (label, point) in suggested)
      (label: label, subtitle: point.direccion, result: point),
  ],
);

GuiaPoint _point(Address address) => (
  ubigeo: address.ubigeo,
  direccion: address.direccion,
  codigoLocal: address.codigoLocal,
);

/// Bottom sheet with [leading] choices, the saved [items] and a button to
/// create a new one
Future<R?> _pick<R, T>(
  BuildContext context, {
  required ProviderListenable<AsyncValue<List<T>>> items,
  required String Function(T item) title,
  required String? Function(T item) subtitle,
  required Future<void> Function(WidgetRef ref, T item) delete,
  required String newLabel,
  required Future<R?> Function(BuildContext context) create,
  R Function(T item)? toResult,
  List<({String label, String subtitle, R result})> leading = const [],
}) => showModalBottomSheet<R>(
  context: context,
  isScrollControlled: true,
  builder: (sheetContext) => SafeArea(
    child: Consumer(
      builder: (context, ref, _) {
        final saved = ref.watch(items).value ?? const [];
        return ListView(
          shrinkWrap: true,
          children: [
            for (final choice in leading)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: Text(choice.label),
                subtitle: Text(choice.subtitle),
                onTap: () => Navigator.pop(sheetContext, choice.result),
              ),
            for (final item in saved)
              ListTile(
                title: Text(title(item)),
                subtitle: switch (subtitle(item)) {
                  final text? => Text(text),
                  null => null,
                },
                onTap: () => Navigator.pop(
                  sheetContext,
                  toResult == null ? item as R : toResult(item),
                ),
                trailing: IconButton(
                  tooltip: Strings.delete,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => delete(ref, item),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(newLabel),
              onTap: () async {
                final created = await create(sheetContext);
                if (created != null && sheetContext.mounted) {
                  Navigator.pop(sheetContext, created);
                }
              },
            ),
          ],
        );
      },
    ),
  ),
);

/// A small form that saves a new catalog row and pops it
class _SaveDialog<T> extends ConsumerStatefulWidget {
  const _SaveDialog({
    required this.title,
    required this.fields,
    required this.save,
  });

  final String title;
  final List<Widget> fields;
  final Future<T> Function(TransportRepository repository) save;

  @override
  ConsumerState<_SaveDialog<T>> createState() => _SaveDialogState<T>();
}

class _SaveDialogState<T> extends ConsumerState<_SaveDialog<T>> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.fields,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () async {
            if (!_form.currentState!.validate()) return;
            final saved = await widget.save(
              ref.read(transportRepositoryProvider),
            );
            if (context.mounted) Navigator.pop(context, saved);
          },
          child: const Text(Strings.save),
        ),
      ],
    );
  }
}

String? _required(String text) => text.trim().isEmpty ? Strings.required : null;

/// Uppercase letters and digits only: "abc-123" → "ABC123"
String _clean(String text) =>
    text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

class _VehicleDialog extends StatefulWidget {
  const _VehicleDialog(this.company);

  final Company company;

  @override
  State<_VehicleDialog> createState() => _VehicleDialogState();
}

class _VehicleDialogState extends State<_VehicleDialog> {
  final _placa = TextEditingController();
  final _circulacion = TextEditingController();

  @override
  void dispose() {
    _placa.dispose();
    _circulacion.dispose();
    super.dispose();
  }

  /// "abc-123" → "ABC123"
  String get _cleanPlaca => _clean(_placa.text);

  @override
  Widget build(BuildContext context) {
    return _SaveDialog<Vehicle>(
      title: Strings.newVehicle,
      fields: [
        FormTextField(
          _placa,
          Strings.placa,
          validator: (_) => RegExp(r'^[A-Z0-9]{6,8}$').hasMatch(_cleanPlaca)
              ? null
              : Strings.invalidPlaca,
        ),
        FormTextField(
          _circulacion,
          Strings.numeroCirculacion,
          helperText: Strings.optional,
          validator: (text) =>
              text.isEmpty ||
                  RegExp(r'^[A-Z0-9]{10,15}$').hasMatch(_clean(text))
              ? null
              : Strings.invalidCirculacion,
        ),
      ],
      save: (repository) => repository.createVehicle(
        VehiclesCompanion.insert(
          companyId: widget.company.id,
          placa: _cleanPlaca,
          numeroCirculacion: Value(
            _clean(_circulacion.text).isEmpty
                ? null
                : _clean(_circulacion.text),
          ),
        ),
      ),
    );
  }
}

class _DriverDialog extends StatefulWidget {
  const _DriverDialog(this.company);

  final Company company;

  @override
  State<_DriverDialog> createState() => _DriverDialogState();
}

class _DriverDialogState extends State<_DriverDialog> {
  final _dni = TextEditingController();
  final _nombres = TextEditingController();
  final _apellidos = TextEditingController();
  final _licencia = TextEditingController();

  @override
  void dispose() {
    _dni.dispose();
    _nombres.dispose();
    _apellidos.dispose();
    _licencia.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SaveDialog<Driver>(
      title: Strings.newDriver,
      fields: [
        FormTextField(
          _dni,
          Strings.dni,
          digitsOnly: true,
          maxLength: 8,
          validator: (text) =>
              text.length == 8 ? null : Strings.invalidNumeroDocumento(8),
        ),
        FormTextField(_nombres, Strings.nombres, validator: _required),
        FormTextField(_apellidos, Strings.apellidos, validator: _required),
        FormTextField(
          _licencia,
          Strings.licencia,
          // SUNAT: 9 to 10 letters and digits
          validator: (text) => RegExp(r'^[A-Za-z0-9]{9,10}$').hasMatch(text)
              ? null
              : Strings.invalidLicencia,
        ),
      ],
      save: (repository) => repository.createDriver(
        DriversCompanion.insert(
          companyId: widget.company.id,
          tipoDocumentoIdentidad: '1',
          numeroDocumentoIdentidad: _dni.text.trim(),
          nombres: _nombres.text.trim().toUpperCase(),
          apellidos: _apellidos.text.trim().toUpperCase(),
          licencia: _licencia.text.trim().toUpperCase(),
        ),
      ),
    );
  }
}

class _AddressDialog extends StatefulWidget {
  const _AddressDialog(this.company);

  final Company company;

  @override
  State<_AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<_AddressDialog> {
  final _nombre = TextEditingController();
  final _ubigeo = TextEditingController();
  final _direccion = TextEditingController();
  final _codigoLocal = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    _ubigeo.dispose();
    _direccion.dispose();
    _codigoLocal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SaveDialog<Address>(
      title: Strings.newAddress,
      fields: [
        FormTextField(
          _nombre,
          Strings.addressName,
          helperText: Strings.optional,
        ),
        FormTextField(_direccion, Strings.direccion, validator: _required),
        FormTextField(
          _ubigeo,
          Strings.ubigeo,
          digitsOnly: true,
          maxLength: 6,
          validator: (text) => text.length == 6 ? null : Strings.invalidUbigeo,
        ),
        FormTextField(
          _codigoLocal,
          Strings.codigoLocal,
          digitsOnly: true,
          maxLength: 4,
          helperText: Strings.codigoLocalHelp,
          validator: (text) => text.isEmpty || text.length == 4
              ? null
              : Strings.invalidCodigoLocal,
        ),
      ],
      save: (repository) => repository.createAddress(
        AddressesCompanion.insert(
          companyId: widget.company.id,
          nombre: Value(optionalText(_nombre)),
          ubigeo: _ubigeo.text.trim(),
          direccion: _direccion.text.trim().toUpperCase(),
          codigoLocal: Value(optionalText(_codigoLocal)),
        ),
      ),
    );
  }
}
