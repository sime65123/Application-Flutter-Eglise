// Importer les packages nécessaires
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class TopicalyImage extends StatelessWidget {
  final String? url;
  const TopicalyImage({required this.url});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 200,
      child: FutureBuilder<String>(
        // Utiliser la méthode getDownloadURL pour obtenir l'URL de l'image
        future: FirebaseStorage.instance
            .ref(url) // Remplacer par le chemin du fichier dans votre Storage
            .getDownloadURL(),
        // Utiliser la fonction qui construit le widget en fonction de l'état du futur
        builder: (context, snapshot) {
          // Vérifier l'état du futur
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()))
              : snapshot.hasData
                  ? Image.network(snapshot.data!)
                  : Image.asset("images/default.jfif");

          // if (snapshot.hasData) {
          //   // Si le futur a des données, afficher l'image dans un widget Image.network
          //   return Image.network(snapshot.data!);
          // } else if (snapshot.hasError) {
          //   // Si le futur a une erreur, afficher un widget Text avec le message d'erreur
          //   return Text('Erreur: ${snapshot.error}');
          // } else {
          //   // Si le futur est en attente, afficher un widget CircularProgressIndicator pour indiquer le chargement
          //   return CircularProgressIndicator();
          // }
        },
      ),
    );
  }
}
