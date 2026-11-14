import 'package:xhandler_mobile/features/delivery/email_sender.dart';
import 'package:xhandler_mobile/features/pdf/share_document.dart';

/// Records what would be sent
class FakeEmailSender implements EmailSender {
  final sent = <({String to, String subject, List<String> files})>[];
  EmailException? error;

  @override
  Future<void> send({
    required SmtpSettings settings,
    required String fromName,
    required String to,
    required String subject,
    required String body,
    List<DeliveryFile> files = const [],
  }) async {
    if (error case final error?) throw error;
    sent.add((
      to: to,
      subject: subject,
      files: [for (final file in files) file.name],
    ));
  }
}
