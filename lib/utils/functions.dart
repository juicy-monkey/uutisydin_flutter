import 'package:url_launcher/url_launcher.dart';

void launchEmail(String subject) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'jusamankki@gmail.com',
    queryParameters: {'subject': subject, 'body': ''},
  );

  await launchUrl(emailUri);
}
