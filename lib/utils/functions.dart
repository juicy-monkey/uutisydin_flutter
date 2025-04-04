import 'package:url_launcher/url_launcher.dart';

void launchEmail(String subject) async {
  final String email = 'jusamankki@gmail.com';
  final String encodedSubject = Uri.encodeComponent(subject);
  final Uri emailUri = Uri.parse('mailto:$email?subject=$encodedSubject');

  await launchUrl(emailUri);
}
