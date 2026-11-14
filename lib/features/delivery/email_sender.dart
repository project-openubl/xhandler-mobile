import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/mailer.dart' as mailer show send;
import 'package:mailer/smtp_server.dart';

import '../../data/secure_store.dart';
import '../pdf/share_document.dart';

/// The company's email account
typedef SmtpSettings = ({
  String host,
  int port,
  String username,
  String password,
});

/// The account in [secrets], or `null` while it isn't configured
SmtpSettings? smtpSettings(CompanySecrets secrets) {
  final (host, port, username, password) = (
    secrets.smtpHost,
    secrets.smtpPort,
    secrets.smtpUsername,
    secrets.smtpPassword,
  );
  if (host == null || port == null || username == null || password == null) {
    return null;
  }
  return (host: host, port: port, username: username, password: password);
}

/// Why an email couldn't be sent
enum EmailError {
  /// Wrong user or password (Gmail and Outlook need an app password)
  authentication,

  /// The server couldn't be reached
  connection,

  /// The server refused the message
  rejected,
}

class EmailException implements Exception {
  const EmailException(this.error, [this.detail]);

  final EmailError error;
  final String? detail;

  @override
  String toString() => 'EmailException($error, $detail)';
}

/// Sends emails from the company's account
abstract interface class EmailSender {
  /// Throws [EmailException]
  Future<void> send({
    required SmtpSettings settings,
    required String fromName,
    required String to,
    required String subject,
    required String body,
    List<DeliveryFile> files = const [],
  });
}

/// Over SMTP: SSL on port 465, STARTTLS (required) on the others
class SmtpEmailSender implements EmailSender {
  const SmtpEmailSender();

  @override
  Future<void> send({
    required SmtpSettings settings,
    required String fromName,
    required String to,
    required String subject,
    required String body,
    List<DeliveryFile> files = const [],
  }) async {
    final server = SmtpServer(
      settings.host,
      port: settings.port,
      ssl: settings.port == 465,
      username: settings.username,
      password: settings.password,
    );
    final message = Message()
      ..from = Address(settings.username, fromName)
      ..recipients = [to]
      ..subject = subject
      ..text = body
      ..attachments = [
        for (final file in files)
          StreamAttachment(
            Stream.value(file.bytes),
            file.mimeType,
            fileName: file.name,
          ),
      ];
    try {
      await mailer.send(message, server, timeout: const Duration(seconds: 60));
    } on SmtpClientAuthenticationException catch (error) {
      throw EmailException(EmailError.authentication, error.message);
    } on SocketException catch (error) {
      throw EmailException(EmailError.connection, error.message);
    } on SmtpClientCommunicationException catch (error) {
      throw EmailException(EmailError.connection, error.message);
    } on MailerException catch (error) {
      throw EmailException(EmailError.rejected, error.message);
    }
  }
}

final emailSenderProvider = Provider<EmailSender>(
  (ref) => const SmtpEmailSender(),
);
