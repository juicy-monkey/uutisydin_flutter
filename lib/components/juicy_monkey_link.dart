import 'package:flutter/material.dart';
import 'package:uutisydin_flutter/utils/functions.dart';


class JuicyMonkeyLink extends StatelessWidget {
  const JuicyMonkeyLink({super.key});


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {
        launchURL('https://juicy-monkey.github.io/homepage/')
        },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.copyright, size: 12, color: Colors.grey),
          SizedBox(width: 4),
          Text('Juicy Monkey', style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
