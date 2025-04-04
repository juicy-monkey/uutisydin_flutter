import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

void launchEmail(String subject) async {
  final String email = 'jusamankki@gmail.com';
  final String encodedSubject = Uri.encodeComponent(subject);
  final Uri emailUri = Uri.parse('mailto:$email?subject=$encodedSubject');

  bool success = await launchUrl(emailUri);
  if (!success) {
    Fluttertoast.showToast(
      msg: 'Sähköpostin avaaminen epäonnistui. Voit lähettää viestisi osoitteeseen $email',
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 5,
      gravity: ToastGravity.BOTTOM,
      webShowClose: true,
      webPosition: 'center',
    );
  }
}
