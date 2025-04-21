import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class DonPage extends StatefulWidget {
  @override
  _DonPageState createState() => _DonPageState();
}

class _DonPageState extends State<DonPage> {
  // Le numéro de téléphone par défaut
  String _montant = '';

  // La fonction qui lance l'application téléphone avec le numéro saisi
  void _launchPhoneApp() async {
    String url = 'tel:*126*14*671817484*$_montant';
    // On vérifie si l'URL peut être lancée
    if (await canLaunch(url)) {
      // On lance l'URL
      await launch(url);
    } else {
      // On affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('impossible'.tr),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('make'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Un champ de texte pour saisir le numéro de téléphone
            TextField(
              decoration: InputDecoration(
                hintText: 'price'.tr,
                border: OutlineInputBorder(),
              ),
              // On met à jour le numéro de téléphone à chaque changement de texte
              onChanged: (value) {
                setState(() {
                  _montant = value;
                });
              },
            ),
            // Un espace
            SizedBox(height: 16),
            // Un bouton pour lancer l'application téléphone
            ElevatedButton(
              onPressed: _launchPhoneApp,
              child: Text('open'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
