// Fichier actualite.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Topicality {
  // Déclaraction et Initialisation
  CollectionReference _topicality =
      FirebaseFirestore.instance.collection('topicality');
  FirebaseStorage _storage = FirebaseStorage.instance;
  // Déclarer les attributs du modèle
  String? titre; // Le titre de l'actualité
  String? topicalityUrlImg; // L'url de l'image de l'actualité
  String? userIDAuthor; // Le nom de l'auteur de l'actualité
  String? userNameAuthor;
  Timestamp? date; // La date de publication de l'actualité
  int? likes; // Le nombre de likes de l'actualité
  String? idTopicality;

  // Créer le constructeur du modèle
  Topicality(
      {this.titre,
      this.topicalityUrlImg,
      this.userIDAuthor,
      this.userNameAuthor,
      this.idTopicality,
      this.date,
      this.likes});
  // ajout de l'actualité dans la BDD
  void addTopicaly(Topicality topicality) {
    DocumentReference docRef = _topicality.doc();
    // Récupérer l'id du document
    String id = docRef.id;
    _topicality.add({
      "titre": topicality.titre,
      "topicalityUrlImg": topicality.topicalityUrlImg,
      "userNameAuthor": topicality.userNameAuthor,
      "userIDAuthor": topicality.userIDAuthor,
      "date": FieldValue.serverTimestamp(),
      "like": 0,
      "idTopicality": id,
    });
  }

  // suppression de l'actualité
  Future<void> deleteTopicaly(String topicalyID) =>
      _topicality.doc(topicalyID).delete();
  // Récuperation de toutes les actualités en temps réel
  Stream<List<Topicality>> get topicality {
    Query queryTopicality = _topicality.orderBy('date', descending: true);
    return queryTopicality.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Topicality(
          titre: doc.get('titre'),
          topicalityUrlImg: doc.get('topicalityUrlImg'),
          userIDAuthor: doc.get('userIDAuthor'),
          userNameAuthor: doc.get('userNameAuthor'),
          date: doc.get('date'),
          likes: doc.get('like'),
          idTopicality: doc.get('idTopicality'),
        );
      }).toList();
    });
  }

// Méthode pour liker une actualité
  Future<void> likeTopicality(String topicalityID, String userID) async {
    // Créer une référence à la sous-collection likes du document correspondant au topicalityID
    CollectionReference likesRef =
        _topicality.doc(topicalityID).collection('likes');
    // Ajouter le document avec le userID comme nom
    await likesRef.doc(userID).set({});
    // Incrémenter le nombre de likes de l'actualité
    await updateNbrLikes2(topicalityID);
  }

// Méthode pour vérifier si l'utilisateur a liké une actualité
  Future<bool> checkIfLiked(String topicalityID, String userID) async {
    // Créer une référence à la sous-collection likes du document correspondant au topicalityID
    CollectionReference likesRef =
        _topicality.doc(topicalityID).collection('likes');
    // Essayer de récupérer le document avec le userID comme nom

    DocumentSnapshot doc = await likesRef.doc(userID).get();

    // Retourner vrai si le document existe, faux sinon
    return doc.exists;
  }

// Méthode pour disliker une actualité
  Future<void> dislikeTopicality(String topicalityID, String userID) async {
    // Créer une référence à la sous-collection likes du document correspondant au topicalityID
    CollectionReference likesRef =
        _topicality.doc(topicalityID).collection('likes');
    // Supprimer le document avec le userID comme nom
    await likesRef.doc(userID).delete();
    // Décrémenter le nombre de likes de l'actualité
    await updateNbrLikes(topicalityID);
  }

// Méthode pour actualiser le nombre de likes de l'actualité
  Future<void> updateNbrLikes(String topicalityID) async {
    // Créer une référence au document correspondant au topicalityID
    DocumentReference topicalityRef = _topicality.doc(topicalityID);
    // Récupérer le document
    DocumentSnapshot doc = await topicalityRef.get();
    // Récupérer le nombre actuel de likes de l'actualité
    int likes = doc.get('likes');
    // Décrémenter ou incrémenter le nombre de likes de l'actualité en fonction de l'action
    likes--;
    // Mettre à jour le document avec le nouveau nombre de likes de l'actualité
    await topicalityRef.update({'likes': likes});
  }

  // Méthode pour actualiser le nombre de likes de l'actualité
  Future<void> updateNbrLikes2(String topicalityID) async {
    // Créer une référence au document correspondant au topicalityID
    DocumentReference topicalityRef = _topicality.doc(topicalityID);
    // Récupérer le document
    DocumentSnapshot doc = await topicalityRef.get();
    // Récupérer le nombre actuel de likes de l'actualité
    int likes = doc.get('likes');
    // Décrémenter ou incrémenter le nombre de likes de l'actualité en fonction de l'action
    likes++;
    // Mettre à jour le document avec le nouveau nombre de likes de l'actualité
    await topicalityRef.update({'likes': likes});
  }
}
