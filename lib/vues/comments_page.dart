import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groupe_des_vainqueurs/Constant_Tools/colors.dart';
import 'package:groupe_des_vainqueurs/modeles/audios.dart';
import 'package:groupe_des_vainqueurs/modeles/prayer_model.dart';
import 'package:provider/provider.dart';

class PrayerCommentsScreen extends StatefulWidget {
  // Passer l'id du thème de prière en paramètre du constructeur
  final String prayerID, label;
  PrayerCommentsScreen({required this.prayerID, required this.label});

  @override
  _PrayerCommentsScreenState createState() => _PrayerCommentsScreenState();
}

class _PrayerCommentsScreenState extends State<PrayerCommentsScreen> {
  // Créer une référence à la collection prayer
  CollectionReference _prayer = FirebaseFirestore.instance.collection('prayer');
  // Créer un contrôleur pour le champ de saisie du commentaire
  TextEditingController _commentController = TextEditingController();

  // Méthode pour ajouter un commentaire à un thème de prière
  Future<void> addComment2(String comment, String userID) async {
    // Créer une référence à la sous-collection comments du document correspondant au prayerID
    CollectionReference commentsRef =
        _prayer.doc(widget.prayerID).collection('comments');
    // Ajouter le commentaire avec le userID et la date de publication
    await commentsRef.add({
      'comment': comment,
      'userID': userID,
      'date_publication': FieldValue.serverTimestamp(),
    });
    // Vider le champ de saisie du commentaire
    _commentController.clear();
  }

  // Méthode pour construire un widget qui affiche un commentaire
  Widget buildComment(Map<String, dynamic> comment) {
    // Récupérer les données du commentaire
    String commentText = comment['comment'];
    String userID = comment['userID'];
    Timestamp date_publication = comment['date_publication'];
    // Formater la date de publication
    String date = date_publication.toDate().toString().substring(0, 16);
    // Retourner un widget qui contient le texte du commentaire, le userID et la date de publication
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            commentText,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userID,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                date,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Créer un stream qui écoute les changements de la sous-collection comments du document correspondant au prayerID
        stream: _prayer
            .doc(widget.prayerID)
            .collection('comments')
            .orderBy('date_publication', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Si le stream n'a pas encore de données, afficher un indicateur de chargement
          if (!snapshot.hasData) {
            return Center(
              child: Text("Aucun commentaire Pour L'instant!"),
            );
          }

          // Si le stream a des données, construire une liste de widgets qui affichent les commentaires
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Récupérer le document à l'index donné
              DocumentSnapshot doc = snapshot.data!.docs[index];
              // Récupérer les données du document sous forme de dictionnaire
              Map<String, dynamic> comment = doc.data() as Map<String, dynamic>;
              // Construire le widget qui affiche le commentaire
              return buildComment(comment);
            },
          );
        },
      ),
      // Ajouter un widget flottant qui contient le bouton + pour ajouter un commentaire
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[900],
        onPressed: () {
          // Afficher un dialogue qui demande le commentaire à l'utilisateur
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Ajouter un commentaire'),
                content: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      hintText: 'Écrivez votre commentaire ici'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Fermer le dialogue
                      Navigator.pop(context);
                    },
                    child: Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Ajouter le commentaire à la base de données
                      PrayerModel().addComment(
                        widget.prayerID,
                        _commentController.text,
                        Provider.of<User?>(context, listen: false)
                                ?.displayName ??
                            '',
                      );
                      //addComment2(_commentController.text, 'u123');
                      // Fermer le dialogue
                      Navigator.pop(context);
                    },
                    child: Text('Envoyer'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
