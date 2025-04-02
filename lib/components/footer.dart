import 'package:flutter/material.dart';
import 'package:uutisydin_flutter/components/juicy_monkey_link.dart';
import 'package:uutisydin_flutter/pages/info.dart';
import 'package:uutisydin_flutter/utils/functions.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed:
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Info()),
                ),
              },
          child: Text('Tietoa', style: TextStyle(color: Colors.grey)),
        ),

        TextButton(
          onPressed:
              () => {launchEmail('Uutisydin - Palaute ja kehitysehdotuksia')},
          child: Text(
            'Lähetä palautetta',
            style: TextStyle(color: Colors.grey),
          ),
        ),

        TextButton(
          onPressed: () => {launchEmail('Uutisydin - Yhteydentotto')},
          child: Text('Ota yhteyttä', style: TextStyle(color: Colors.grey)),
        ),
        SizedBox(height: 8),

        JuicyMonkeyLink(),
        SizedBox(height: 8),
      ],
    );
  }
}
