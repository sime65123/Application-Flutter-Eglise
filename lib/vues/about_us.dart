import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'À propos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo et nom de l'application
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blueGrey,
              child: Row(
                children: [
                  // Vous pouvez remplacer le logo par une image de votre choix
                  // CircleAvatar(
                  //   // Donner le logo comme image
                  //   backgroundImage: AssetImage(
                  //       'images/app_logo.png'), // Remplacer par le chemin du logo dans votre dossier Images
                  //   // Donner un rayon au CircularAvatar
                  //   radius: 20.0,
                  // ),
                  SizedBox(width: 20),
                  Center(
                    child: Text(
                      'Eglise Messianique-Groupe Des Vainqueurs',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Description de l'application
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'L’application vise à enrichir la vie spirituelle des utilisateurs, à les aider à grandir dans la foi, et à les connecter avec d’autres chrétiens.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            // Séparateur
            Divider(),
            // Informations sur le développeur
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Développeur'),
              subtitle: Text('Edwin Tchakounte'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Localisation'),
              subtitle: Text('Yaoundé, Cameroun'),
            ),
            ListTile(
              leading:
                  //----------------------------------------------------

                  Icon(Icons.phone),
              title: Text('Téléphone'),
              subtitle: Text(
                  '+237 673 398 046'), // Vous pouvez compléter votre numéro
            ),
            // Séparateur
            Divider(),
            // Informations sur la version
            ListTile(
              leading: Icon(Icons.update),
              title: Text('Version'),
              subtitle: Text('1.0.0'),
            ),
            // Informations sur la licence
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Licence'),
              subtitle: Text('GNU GPL v3'),
            ),
            // Informations sur les sources

            Center(
              child: InkWell(
                onTap: () {
                  // Vous pouvez remplacer le numéro et le message par ceux que vous voulez
                  launch('https://wa.me/237673398046?text=Bonjour');
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.green,
                  child: Row(
                    children: [
                      // Vous pouvez remplacer l'icône par une image de votre choix
                      Icon(
                        Icons.chat,
                        size: 25,
                        color: Colors.white,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Discuter sur WhatsApp',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
