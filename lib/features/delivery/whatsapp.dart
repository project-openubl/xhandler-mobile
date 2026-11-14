import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../pdf/share_document.dart';

const _channel = MethodChannel('xhandler/whatsapp');

/// Only Android lets apps attach files to a given WhatsApp chat; iOS uses
/// the share sheet
bool get canSendToWhatsApp => Platform.isAndroid;

/// [phone] as WhatsApp numbers it: digits with the country code. Peruvian
/// mobiles (9 digits starting with 9) get Peru's 51.
String? whatsappNumber(String? phone) {
  final digits = (phone ?? '').replaceAll(RegExp(r'\D'), '');
  if (RegExp(r'^9\d{8}$').hasMatch(digits)) return '51$digits';
  return digits.length >= 10 ? digits : null;
}

/// Opens the chat with [phone] (see [whatsappNumber]) with [files]
/// attached. `false` when WhatsApp isn't installed.
Future<bool> sendToWhatsApp({
  required String phone,
  required List<DeliveryFile> files,
  String? text,
}) async {
  // The folder MainActivity's FileProvider shares
  final folder = Directory('${(await getTemporaryDirectory()).path}/delivery');
  if (folder.existsSync()) folder.deleteSync(recursive: true);
  folder.createSync(recursive: true);
  final paths = <String>[];
  for (final file in files) {
    final path = '${folder.path}/${file.name}';
    File(path).writeAsBytesSync(file.bytes);
    paths.add(path);
  }
  return await _channel.invokeMethod<bool>('share', {
        'phone': phone,
        'paths': paths,
        'text': text,
      }) ??
      false;
}
