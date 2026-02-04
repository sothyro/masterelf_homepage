import 'package:url_launcher/url_launcher.dart';

import '../config/app_content.dart';

/// Launches WhatsApp chat with [AppContent.whatsAppNumber].
Future<void> launchWhatsApp() async {
  final uri = Uri.parse('https://wa.me/${AppContent.whatsAppNumber}');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Opens default email client with [AppContent.email].
Future<void> launchEmail() async {
  final uri = Uri.parse('mailto:${AppContent.email}');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

/// Opens [url] in browser (e.g. social links).
Future<void> launchUrlExternal(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
