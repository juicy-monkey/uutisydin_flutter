import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uutisydin_flutter/components/footer.dart';
import 'package:uutisydin_flutter/components/juicy_monkey_link.dart';
import 'package:uutisydin_flutter/utils/functions.dart';

class Info extends StatelessWidget {
  const Info({super.key});
  final String version = '1.0.0';

  Widget _buildUrlLinkButton(String label, String url) {
    return TextButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      child: Text(label, style: const TextStyle(color: Colors.blue)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/uutisydin/uutisydin_text.png',
                    height: 30,
                  ),
                  SizedBox(height: 8),
                  Text('Versio $version'),
                  Text('Kaikki oikeudet pidätetään'),
                  Text('All rights reserved'),
                  JuicyMonkeyLink(),
                  SizedBox(height: 20),

                  /////////////////////////////
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tietoa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      const Text(
                        'Uutisydin on sovellus, joka kokoaa suomalaisista uutislähteistä ajankohtaisimmat uutiset ja ryhmittelee ne aiheittain. '
                        'Sovelluksen avulla pysyt helposti ajan tasalla tärkeimmistä tapahtumista viimeisen 48 tunnin ajalta. ',
                      ),
                      SizedBox(height: 8),

                      const Text(
                        'Voit hakea uutisia hakutoiminnolla sekä järjestää ne joko julkaisuajan mukaan tai aiheiden mukaan, joista on kirjoitettu eniten. '
                        'Uutiskoosteet päivittyvät automaattisesti noin 15 minuutin välein. ',
                      ),
                      SizedBox(height: 8),

                      const Text(
                        'Sovellus ei kerää käyttäjäkohtaista tietoa. ',
                      ),
                      SizedBox(height: 8),

                      const Text(
                        'Kuulemme mielellämme palautetta ja kehitysehdotuksia! ',
                      ),

                      Center(
                        child: TextButton(
                          onPressed:
                              () => {
                                launchEmail(
                                  'Uutisydin | Palaute- ja kehitysehdotuksia',
                                ),
                              },
                          child: Text(
                            'Lähetä palautetta',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      //////////////////////////////
                      const Text(
                        'Toteutus',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      const Text(
                        'Uutiset, joita sovellus näyttää, on haettu suoraan uutistoimitusten julkisista RSS-syötteistä. '
                        'Uutisydin-sovellus toimii itsenäisesti, eikä sillä ole virallista yhteistyötä uutistoimitusten kanssa. '
                        'Sovellus noudattaa RSS-syötteiden käyttöehtoja ja kunnioittaa sisällöntuottajien tekijänoikeuksia. '
                        'Kaikki linkit ohjaavat suoraan alkuperäisiin uutisartikkeleihin, jotta käyttäjät voivat lukea uutiset luotettavasta lähteestä. ',
                      ),
                      SizedBox(height: 8),

                      const Text(
                        'Sovellus hyödyntää seuraavien uutistoimitusten RSS-syötteitä: ',
                      ),
                      Wrap(
                        children: [
                          _buildUrlLinkButton(
                            'Helsingin Sanomat',
                            'https://www.hs.fi',
                          ),
                          _buildUrlLinkButton(
                            'Iltalehti',
                            'https://www.iltalehti.fi',
                          ),
                          _buildUrlLinkButton(
                            'Ilta-Sanomat',
                            'https://www.is.fi',
                          ),
                          _buildUrlLinkButton(
                            'Kaleva',
                            'https://www.kaleva.fi',
                          ),
                          _buildUrlLinkButton(
                            'Kauppalehti',
                            'https://www.kauppalehti.fi',
                          ),
                          _buildUrlLinkButton(
                            'Turun Sanomat',
                            'https://www.ts.fi',
                          ),
                          _buildUrlLinkButton('Yle', 'https://www.yle.fi'),
                        ],
                      ),
                      SizedBox(height: 20),

                      //////////////////////////////
                      const Text(
                        'Lisenssit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),

                      Text(
                        'Tämä sovellus ja sen sisältämä lähdekoodi, grafiikka, nimet ja logot ovat tekijänoikeuden suojaamia ja kuuluvat tekijälle. '
                        'Tätä sovellusta tai sen osia ei saa kopioida, muokata, levittää, julkaista tai käyttää ilman tekijän etukäteen antamaa lupaa. '
                        'Kaikki oikeudet pidätetään. '),
                      SizedBox(height: 8),

                      Text(
                        'Sovellus sisältää kolmansien osapuolien tuottamia kuvia, jotka on lisensoitu Creative Commons -lisenssien alla. '
                        'Näiden kuvien oikeudet säilyvät alkuperäisillä tekijöillä, ja kuvia käytetään lisenssiehtojen mukaisesti. '
                      ),

                      TextButton(
                        onPressed: () {
                          launchUrl(
                            Uri.parse(
                              'https://juicy-monkey.github.io/uutisydin_node/image-licences.html',
                            ),
                          );
                        },
                        child: const Text(
                          'Kuvien lisenssit',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          showLicensePage(
                            context: context,
                            applicationName: 'Uutisydin',
                            applicationVersion: version,
                          );
                        },
                        child: const Text(
                          'Flutter lisenssit',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50),
                  Footer(showInfoButton: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
