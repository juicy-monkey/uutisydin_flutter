import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class JuicyMonkeyLink extends StatelessWidget {
  const JuicyMonkeyLink({super.key});


  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.all(4.0),
      minimumSize: Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return TextButton(
      style: buttonStyle,
      onPressed: () => {
        launchUrl(Uri.parse('https://juicy-monkey.github.io/homepage/'))
        },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.copyright, size: 12, color: Colors.grey),
          SizedBox(width: 4),
          Text('2026 Juicy Monkey', style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
