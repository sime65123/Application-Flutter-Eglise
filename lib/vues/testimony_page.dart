import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupe_des_vainqueurs/modeles/testimony_model.dart';
import 'package:groupe_des_vainqueurs/vues/post_testimony_page.dart';
import 'package:url_launcher/url_launcher.dart';

// class TestimonyPage extends StatelessWidget {
//   TestimonyPage({super.key});
//   // Une liste de modèles vidéo à afficher
//   final List<TestimonyModel> videos = [
//     TestimonyModel(
//       urlBanniere: 'images/banniere1.jpg',
//       titre: 'Comment utiliser Flutter',
//       nombreDeLikes: 120,
//       nombreDeVues: 500,
//       urlYoutube: "https://youtu.be/Pn3FxnlMDww",
//     ),
//     TestimonyModel(
//       urlBanniere: 'images/banniere2.png',
//       titre: 'Les bases de Dart',
//       nombreDeLikes: 80,
//       nombreDeVues: 300,
//       urlYoutube: "https://youtu.be/Pn3FxnlMDww",
//     ),
//     TestimonyModel(
//       urlBanniere: 'images/banniere3.jpg',
//       titre: 'Créer une application de chat avec Firebase',
//       nombreDeLikes: 150,
//       nombreDeVues: 700,
//       urlYoutube: "https://youtu.be/Pn3FxnlMDww",
//     ),
//     TestimonyModel(
//       urlBanniere: 'images/banniere3.jpg',
//       titre: 'Créer une application de chat avec Firebase',
//       nombreDeLikes: 150,
//       nombreDeVues: 700,
//       urlYoutube: "https://youtu.be/Pn3FxnlMDww",
//     ),
//     TestimonyModel(
//       urlBanniere: 'images/banniere2.png',
//       titre: 'Les bases de Dart',
//       nombreDeLikes: 80,
//       nombreDeVues: 300,
//       urlYoutube: "https://youtu.be/Pn3FxnlMDww",
//     ),
//   ];
//   //'https://wa.me/1234567890'

//   void launchURLVideo(String url) async {
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           // Le modèle vidéo à afficher
//           final video = videos[index];
//           // Le widget Card qui affiche les informations de la vidéo
//           return Card(
//             child: InkWell(
//               onTap: () async {
//                 await launch((videos[index].urlYoutube).toString());
//                 // TODO: implémenter la redirection vers la vidéo YouTube
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     (video.titre).toString(),
//                     style: TextStyle(
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Image.asset(
//                     (video.urlBanniere).toString(),
//                     height: 100.0,
//                     width: MediaQuery.sizeOf(context).width,
//                     fit: BoxFit.cover,
//                   ),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Icon(Icons.thumb_up),
//                             Text(video.nombreDeLikes.toString()),
//                             Icon(Icons.remove_red_eye),
//                             Text(video.nombreDeVues.toString()),
//                           ],
//                         ),
//                         // Text(video.heureDePublication.toDate().day.toString() +
//                         //     "-" +
//                         //     video.heureDePublication.month.toString() +
//                         //     "-" +
//                         //     video.heureDePublication.year.toString()),
//                       ]),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class TestimonyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TestimonyModel>>(
      // Donner le flux comme argument stream
      stream: TestimonyModel().testimony,
      // Donner la fonction qui construit le widget comme argument builder
      builder: (context, snapshot) {
        // Vérifier l'état du flux
        if (snapshot.hasData) {
          // Si le flux a des données, afficher la liste d'actualités dans un widget ListView
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // Créer un widget PostContainer pour chaque actualité
              return PostContainer2(testimonyModel: snapshot.data![index]);
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
