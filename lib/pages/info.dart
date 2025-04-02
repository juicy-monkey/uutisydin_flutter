import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class Info extends StatelessWidget {
  const Info({super.key});
  final String version = '1.0.0';

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail(String subject) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'jusamankki@gmail.com',
      queryParameters: {'subject': subject, 'body': ''},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/uutisydin/uutisydin_text.png', height: 25),
              SizedBox(height: 8),
              Text('Versio $version'),
              SizedBox(height: 8),
              GestureDetector(
                onTap:
                    () => {
                      _launchURL('https://juicy-monkey.github.io/homepage/'),
                    },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.copyright, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Juicy Monkey',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              /////////////////////////////
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tietoa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  const Text(
                    'Uutisydin on sovellus, joka hakee suomalaisista uutislähteistä uutiset ja kokoaa ne aiheen mukaan. '
                    'Sovelluksen avulla voit seurata tärkeimpiä aiheita mistä on kirjoitettu viimeisen 48 tunnin ajalta. ',
                  ),
                  SizedBox(height: 8),

                  const Text(
                    'Voit hakea hakutoiminnolla sisältöä, ja järjestää sisällön uusimpien julkaisujen mukaan, tai aiheiden mukaan joista on eniten kirjoitettu. '
                    'Uutiskoosteita päivitetään 15 minuutin välein. ',
                  ),
                  SizedBox(height: 8),

                  const Text(
                    'Sovellus ei kerää mitään käyttäjäkohtaista tietoa. ',
                  ),
                  SizedBox(height: 8),

                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              'Kuulemme mielellämme palautetta ja kehitysehdotuksia. Voit lähettää palautetta ',
                        ),
                        TextSpan(
                          text: 'sähköpostitse. ',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  _launchEmail(
                                    'Uutisydin - Palaute ja kehitysehdotuksia',
                                  );
                                },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  //////////////////////////////
                  const Text(
                    'Toteutus',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  const Text(
                    'Uutiset on kerätty uutistoimitusten RSS-syötteistä. '
                    'Uutisydin sovellus ei ole tehnyt yhteistyötä uutistoimitusten kanssa. '
                    'On katsottu, että se on sovellus noudattaa RSS-syötteiden käyttöehtoja ja kunnioittaa uutistoimitusten tekijänoikeussuojaa. ',
                  ),
                  SizedBox(height: 8),

                  const Text(
                    'Kaikki sovelluksessa käytetyt kuvat ovat CC-BY lisenssillä. ',
                  ),
                  SizedBox(height: 8),
                ],
              ),

              //////////////////////////////
              GestureDetector(
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Uutisydin',
                    applicationVersion: version,
                  );
                },
                child: const Text(
                  'Lisenssit',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
