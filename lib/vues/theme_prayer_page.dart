import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/show_notification.dart';
import 'package:groupe_des_vainqueurs/modeles/prayer_model.dart';
import 'package:groupe_des_vainqueurs/vues/comments_page.dart';
import 'package:provider/provider.dart';

class PrayerThemePage extends StatefulWidget {
  @override
  _PrayerThemePageState createState() => _PrayerThemePageState();
}

class _PrayerThemePageState extends State<PrayerThemePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamProvider<List<PrayerModel>>.value(
          value: PrayerModel().prayer,
          initialData: [],
          child: Consumer<List<PrayerModel>>(
            builder: (context, themes, child) {
              return ListView.builder(
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  return ListTile(
                    title: Text((theme.title).toString()),
                    subtitle: Text(
                        '${theme.likes} likes, ${(theme.nbr_comments).toString()} commentaires'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder<bool>(
                          // Appeler la méthode checkIfLiked dans le paramètre future
                          future: PrayerModel().checkIfLiked(
                            (theme.idPrayerModel).toString(),
                            Provider.of<User>(context, listen: false)
                                .displayName
                                .toString(),
                          ),
                          // Construire le widget en fonction de l'état du futur
                          builder: (context, snapshot) {
                            // Si le futur n'a pas encore de données, afficher un indicateur de chargement
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            // Si le futur a des données, récupérer la valeur booléenne
                            bool liked = snapshot.data!;
                            // Retourner le widget IconButton avec la couleur et l'action appropriées
                            return IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                // Si liked est vrai, mettre la couleur rouge, sinon gris
                                color: liked ? Colors.orange[900] : Colors.grey,
                              ),
                              onPressed: () {
                                // Si liked est vrai, appeler la méthode dislike, sinon like
                                final wait = liked
                                    ? PrayerModel().dislike(
                                        (theme.idPrayerModel).toString(),
                                        Provider.of<User>(context,
                                                listen: false)
                                            .displayName
                                            .toString(),
                                      )
                                    : PrayerModel().likePrayer(
                                        (theme.idPrayerModel).toString(),
                                        Provider.of<User>(context,
                                                listen: false)
                                            .displayName
                                            .toString(),
                                      );
                                // Mettre à jour l'état du widget pour changer la couleur du bouton
                                wait.then((value) => setState(() {
                                      // Inverser la valeur de liked
                                      liked = !liked;
                                    }));
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.comment),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Modifier le type du paramètre pour qu'il soit BuildContext
                                builder: (BuildContext context) =>
                                    PrayerCommentsScreen(
                                  prayerID: (theme.idPrayerModel).toString(),
                                  label: (theme.title).toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange[900],
            child: Icon(
              Icons.add,
              color: primaryColor,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Center(
                          child: Text('Ajouter un thème de prière',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey)),
                        ),
                        content: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Veuillez entrer un titre';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Titre',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Annuler'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('Valider',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.orange[900]), // couleur du fond
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // rayon des coins
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // appel de la méthode validate() du formulaire
                                // code à exécuter si le formulaire est valide
                                showNotification(context, "En cours ....");

                                PrayerModel prayerModel = PrayerModel(
                                    title: _titleController.text,
                                    likes: 0,
                                    nbr_comments: 0,
                                    idUserPost: Provider.of<User?>(context,
                                                listen: false)
                                            ?.uid ??
                                        '',
                                    date_publication: Timestamp.now());
                                PrayerModel().addPrayer(prayerModel);
                                showNotification(context, "Succes");
                                Navigator.pop(context);
                              } else {
                                // code à exécuter si le formulaire n'est pas valide
                                print('Le formulaire n\'est pas valide');
                                showNotification(context, "Echec");
                              }
                            },
                          )
                        ]);
                  });
            }));
  }
}
