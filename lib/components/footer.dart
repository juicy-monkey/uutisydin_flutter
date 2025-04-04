import 'package:flutter/material.dart';
import 'package:uutisydin_flutter/components/juicy_monkey_link.dart';
import 'package:uutisydin_flutter/pages/info.dart';
import 'package:uutisydin_flutter/utils/functions.dart';

class Footer extends StatelessWidget {
  final bool showInfoButton;
  const Footer({super.key, required this.showInfoButton});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.all(4.0),
      minimumSize: Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return Column(
      children: [
        if (showInfoButton)
          TextButton(
            style: buttonStyle,
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
          style: buttonStyle,
          onPressed:
              () => {launchEmail('Uutisydin | Palaute- ja kehitysehdotuksia')},
          child: Text(
            'Lähetä palautetta',
            style: TextStyle(color: Colors.grey),
          ),
        ),

        TextButton(
          style: buttonStyle,
          onPressed: () => {launchEmail('Uutisydin | Yhteydentotto')},
          child: Text('Ota yhteyttä', style: TextStyle(color: Colors.grey)),
        ),

        JuicyMonkeyLink(),
        SizedBox(height: 16),
      ],
    );
  }
}
