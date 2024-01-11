// Importer les packages nécessaires
import 'package:flutter/material.dart';
import 'package:groupe_des_vainqueurs/modeles/topicality_model.dart';
import 'package:groupe_des_vainqueurs/vues/post_topicaly_page.dart';

class TopicalityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Topicality>>(
      // Donner le flux comme argument stream
      stream: Topicality().topicality,
      // Donner la fonction qui construit le widget comme argument builder
      builder: (context, snapshot) {
        // Vérifier l'état du flux
        if (snapshot.hasData) {
          // Si le flux a des données, afficher la liste d'actualités dans un widget ListView
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // Créer un widget PostContainer pour chaque actualité
              return PostContainer(topicality: snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          // Si le flux a une erreur, afficher un widget Text avec le message d'erreur
          return Text('Erreur: ${snapshot.error}');
        } else {
          // Si le flux est en attente, afficher un widget CircularProgressIndicator pour indiquer le chargement
          return Center(
              child: Container(
                  width: 50, height: 50, child: CircularProgressIndicator()));
        }
      },
    );
  }
}
