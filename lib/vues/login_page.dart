import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/show_notification.dart';
import 'package:groupe_des_vainqueurs/controlleurs/repository/google_auth.dart';
import 'package:groupe_des_vainqueurs/modeles/audios.dart';
import 'package:groupe_des_vainqueurs/modeles/prayer_model.dart';
import 'package:groupe_des_vainqueurs/modeles/testimony_model.dart';
import 'package:groupe_des_vainqueurs/modeles/topicality_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool inLoginProcess = false;

  List<PrayerModel> prayerList = [
    PrayerModel(
      title: 'Seigneur, donne-moi la force',
      likes: 12,
      nbr_comments: 3,
      idUserPost: 'u456',
    ),
    PrayerModel(
      title: 'Merci pour ta grâce et ta bonté',
      likes: 8,
      nbr_comments: 2,
      idUserPost: 'u789',
    ),
    PrayerModel(
      title: 'Priez pour la paix dans le monde',
      likes: 15,
      nbr_comments: 5,
      idUserPost: 'u123',
    ),
    PrayerModel(
      title: 'Guéris-moi de ma maladie',
      likes: 10,
      nbr_comments: 4,
      idUserPost: 'u234',
    ),
    PrayerModel(
      title: 'Protège ma famille et mes amis',
      likes: 9,
      nbr_comments: 3,
      idUserPost: 'u567',
    ),
  ];

  List<PrayerModel> prayers = [
    PrayerModel(
        title: 'La grâce de Dieu',
        likes: 7,
        nbr_comments: 3,
        idUserPost: 'user1',
        date_publication: Timestamp.now()),
    PrayerModel(
        title: 'La protection divine',
        likes: 9,
        nbr_comments: 4,
        idUserPost: 'user2',
        date_publication: Timestamp.now()),
    PrayerModel(
        title: 'La foi en Jésus',
        likes: 11,
        nbr_comments: 5,
        idUserPost: 'user3',
        date_publication: Timestamp.now()),
    PrayerModel(
        title: 'La joie du salut',
        likes: 13,
        nbr_comments: 6,
        idUserPost: 'user4',
        date_publication: Timestamp.now()),
    PrayerModel(
        title: 'La charité chrétienne',
        likes: 15,
        nbr_comments: 7,
        idUserPost: 'user5',
        date_publication: Timestamp.now()),
  ];

  List<Map<String, dynamic>> commentList = [
    {
      'comment': 'Que Dieu vous bénisse',
      'userID': 'u123',
      'date_publication': Timestamp(1641601000, 0),
    },
    {
      'comment': 'Je suis avec vous dans la prière',
      'userID': 'u456',
      'date_publication': Timestamp(1641601600, 0),
    },
    {
      'comment': 'Amen',
      'userID': 'u789',
      'date_publication': Timestamp(1641602200, 0),
    },
  ];

  List<AudioModel> audios = [
    AudioModel(
        nom: 'Alice',
        url:
            'https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/audio%2Faudio1.mp3?alt=media&token=12345678',
        titre: 'Chant de louange'),
    AudioModel(
        nom: 'Bob',
        url:
            'https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/audio%2Faudio2.mp3?alt=media&token=23456789',
        titre: 'Témoignage de foi'),
    AudioModel(
        nom: 'Charles',
        url:
            'https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/audio%2Faudio3.mp3?alt=media&token=34567890',
        titre: 'Méditation biblique'),
    AudioModel(
        nom: 'Diane',
        url:
            'https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/audio%2Faudio4.mp3?alt=media&token=45678901',
        titre: 'Prière du matin'),
    AudioModel(
        nom: 'Eric',
        url:
            'https://firebasestorage.googleapis.com/v0/b/your-app.appspot.com/o/audio%2Faudio5.mp3?alt=media&token=56789012',
        titre: 'Message d\'encouragement'),
  ];

  //--------------------------------------------
  // Créer une liste de titres d'actualités
  List<String> titres = [
    'Nouvelle version de Flutter',
    'Lancement de SpaceX',
    'Réouverture des cinémas',
    'Finale de la Coupe du monde',
    'Découverte d\'une nouvelle planète',
  ];

  // // Créer une liste d'urls d'images d'actualités
  List<String> urls = [
    'Topicality/OIP.jpg',
    'Topicality/ok1.png',
    'Topicality/OIP.jpg',
    'Topicality/ok1.png',
    'Topicality/OIP.jpg',
  ];

  // Créer une liste de noms d'auteurs d'actualités
  List<String> auteurs = [
    'Flutter Team',
    'Elon Musk',
    'AlloCiné',
    'FIFA',
    'NASA',
  ];
  // @override
  // void initState() {
  //   for (int i = 0; i < commentList.length; i++) {
  //     PrayerModel()
  //         .addComment("v6uyqCrQkJhmWnQ4xwuf", "La Gloire du pere", "edwin");
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // Exécuter du code au démarrage de l'application
  //   // Créer une boucle for qui va générer 20 instances de la classe Topicality
  //   for (int i = 0; i < 20; i++) {
  //     // Créer une instance de la classe Topicality avec des données aléatoires ou prédéfinies
  //     Topicality actualite = Topicality(
  //       titre: titres[i %
  //           titres
  //               .length], // Choisir un titre aléatoire dans la liste des titres
  //       topicalityUrlImg: urls[i %
  //           urls.length], // Choisir une url aléatoire dans la liste des urls
  //       userIDAuthor: 'Edwin', // Générer un identifiant d'utilisateur
  //       userNameAuthor: auteurs[i %
  //           auteurs
  //               .length], // Choisir un nom d'auteur aléatoire dans la liste des auteurs
  //       likes: 0, // Initialiser le nombre de likes à 0
  //     );
  //     // Ajouter l'instance à la base de données en utilisant la méthode addTopicaly
  //     actualite.addTopicaly(actualite);
  //   }
  // } // Choisir une url aléatoire dans la liste des urls

  //---------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Bienvenue à toi, Cher Fidèle',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Image.asset(
                  'images/app_logo.png',
                  height: 200.0,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              inLoginProcess
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Connectez-vous avec Google",
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  'images/Google_logo.png'), // Remplacer par le chemin du logo dans votre dossier Images
                              // Donner un rayon au CircularAvatar
                              // radius: 20.0,
                            )
                          ],
                        ),
                      ),

                      // icon: Icon(Icons.login),
                      // //label: Text(
                      //   "Connectez-vous avec Google",
                      //   style: TextStyle(
                      //       color: Colors.blueGrey,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      onPressed: () => signIn(context),
                      //onPressed: () => Navigator.of(context).pushNamed("home"),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Découvrez et partagez les meilleures moment de prière',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signIn(BuildContext context) {
    if (kIsWeb) {
      setState(() {
        inLoginProcess = true;
        AuthService().signInWithGoogle();
      });
    } else {
      try {
        final fut = InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            setState(() {
              inLoginProcess = true;
              AuthService().signInWithGoogle().catchError((_) {
                showNotification(context, _.toString());
                print(_.toString());
                return null;
              });
            });
          }
        })
          ..catchError((error, stackTrace) {
            showNotification(context, 'Aucune connexion internet');
            return Future.value(null);
          });
      } on SocketException catch (_) {
        showNotification(context, 'Aucune connexion internet');
      }
    }
  }
}
