import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PrayerModel {
  CollectionReference _prayer = FirebaseFirestore.instance.collection('prayer');
  FirebaseStorage _storage = FirebaseStorage.instance;

  final String? title;
  int? likes = 0;
  int? nbr_comments = 0;
  String? idUserPost;
  Timestamp? date_publication;
  String? idPrayerModel;
  List<Map<String, dynamic>>? comments;
  PrayerModel(
      {this.title,
      this.likes,
      this.nbr_comments,
      this.idUserPost,
      this.date_publication,
      this.idPrayerModel,
      this.comments});
  void addPrayer(PrayerModel prayerModel) {
    // Créer une référence au document qui va être ajouté
    DocumentReference docRef = _prayer.doc();
    // Récupérer l'id du document
    String id = docRef.id;
    // Ajouter le document avec les données du prayerModel et l'id
    docRef.set({
      "title": prayerModel.title,
      "likes": prayerModel.likes,
      "nbr_comments": prayerModel.nbr_comments,
      "idUserPost": prayerModel.idUserPost,
      "date_publication": FieldValue.serverTimestamp(),
      // Ajouter le champ idPrayerModel avec l'id
      "idPrayerModel": id,
    });
  }

  // suppression de l'actualité
  Future<void> deletetestimonyModel(String prayerID) =>
      _prayer.doc(prayerID).delete();
  // Récuperation de toutes les actualités en temps réel
  Stream<List<PrayerModel>> get prayer {
    Query queryTopicality =
        _prayer.orderBy('date_publication', descending: true);
    return queryTopicality.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PrayerModel(
          title: doc.get('title'),
          likes: doc.get('likes'),
          nbr_comments: doc.get('nbr_comments'),
          idUserPost: doc.get('idUserPost'),
          date_publication: doc.get('date_publication'),
          idPrayerModel: doc.get('idPrayerModel'),
        );
      }).toList();
    });
  }

//-------------------------------------------------------------------------------------------------
  // Ajouter un commentaire à un thème de prière
  Future<void> addComment(
      String prayerID, String comment, String userID) async {
    // Créer une référence à la sous-collection comments du document correspondant au prayerID
    CollectionReference commentsRef =
        _prayer.doc(prayerID).collection('comments');
    // Ajouter le commentaire avec le userID et la date de publication
    await commentsRef.add({
      'comment': comment,
      'userID': userID,
      'date_publication': Timestamp.now(),
    });
    // Appeler la méthode pour actualiser le nombre de l'attribut nbr_comments
    await updateNbrComments(prayerID);
  }

// Supprimer un thème de prière et ses commentaires
  Future<void> deletePrayer(String prayerID) async {
    // Créer une référence à la sous-collection comments du document correspondant au prayerID
    CollectionReference commentsRef =
        _prayer.doc(prayerID).collection('comments');
    // Supprimer tous les documents de la sous-collection comments
    await commentsRef.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
    // Supprimer le document correspondant au prayerID
    await _prayer.doc(prayerID).delete();
  }

// Écouter en permanence un thème de prière et ses commentaires
  Stream<PrayerModel> getPrayer(String prayerID) {
    // Créer une référence au document correspondant au prayerID
    DocumentReference prayerRef = _prayer.doc(prayerID);
    // Retourner un stream qui émet un objet PrayerModel à chaque changement du document
    return prayerRef.snapshots().map((snapshot) {
      // Créer un objet PrayerModel à partir des données du document
      PrayerModel prayer = PrayerModel(
          title: snapshot.get('title'),
          likes: snapshot.get('likes'),
          nbr_comments: snapshot.get('nbr_comments'),
          idUserPost: snapshot.get('idUserPost'),
          date_publication: snapshot.get('date_publication'),
          idPrayerModel: snapshot.get('idPrayerModel'));
      // Ajouter une propriété comments à l'objet PrayerModel qui contient la liste des commentaires
      prayer.comments = [];
      // Créer une référence à la sous-collection comments du document
      CollectionReference commentsRef = prayerRef.collection('comments');
      // Récupérer les documents de la sous-collection comments et les ajouter à la liste des commentaires
      commentsRef.get().then((snapshot) {
        snapshot.docs.forEach((doc) {
          prayer.comments?.add({
            'comment': doc.get('comment'),
            'userID': doc.get('userID'),
            'date_publication': doc.get('date_publication'),
          });
        });
      });

      // Retourner l'objet PrayerModel
      return prayer;
    });
  }

  // Méthode pour actualiser le nombre de l'attribut nbr_comments
  Future<void> updateNbrComments(String prayerID) async {
    // Créer une référence au document correspondant au prayerID
    DocumentReference prayerRef = _prayer.doc(prayerID);
    // Récupérer le document
    DocumentSnapshot doc = await prayerRef.get();
    // Récupérer le nombre actuel de l'attribut nbr_comments
    int nbr_comments = doc.get('nbr_comments');
    // Incrémenter le nombre de l'attribut nbr_comments
    nbr_comments++;
    // Mettre à jour le document avec le nouveau nombre de l'attribut nbr_comments
    await prayerRef.update({'nbr_comments': nbr_comments});
  }

  // Méthode pour actualiser le nombre de l'attribut like
  Future<void> updateNbrLikes(String prayerID) async {
    // Créer une référence au document correspondant au prayerID
    DocumentReference prayerRef = _prayer.doc(prayerID);
    // Récupérer le document
    DocumentSnapshot doc = await prayerRef.get();
    // Récupérer le nombre actuel de l'attribut nbr_comments
    int nbr_likes = doc.get('likes');
    // Incrémenter le nombre de l'attribut nbr_comments
    nbr_likes++;
    // Mettre à jour le document avec le nouveau nombre de l'attribut nbr_comments
    await prayerRef.update({'likes': nbr_likes});
  }

  // Méthode pour liker un prayer
  Future<void> likePrayer(String prayerID, String userID) async {
    // Créer une référence à la sous-collection likes du document correspondant au prayerID
    CollectionReference likesRef = _prayer.doc(prayerID).collection('likesC');
    // Ajouter le document avec le userID comme nom
    await likesRef.doc(userID).set({
      'ok': "ok",
    });
    // Incrémenter le nombre de likes du prayer
    await updateNbrLikes(prayerID);
  }

  // Méthode pour vérifier si l'utilisateur a liké un prayer
  Future<bool> checkIfLiked(String prayerID, String userID) async {
    // Créer une référence à la sous-collection likes du document correspondant au prayerID
    CollectionReference likesRef = _prayer.doc(prayerID).collection('likesC');
    // Essayer de récupérer le document avec le userID comme nom
    DocumentSnapshot doc = await likesRef.doc(userID).get();
    // Retourner vrai si le document existe, faux sinon
    return doc.exists;
  }

  // Méthode pour disliker un prayer
  Future<void> dislike(String prayerID, String userID) async {
    // Créer une référence à la sous-collection likes du document correspondant au prayerID
    CollectionReference likesRef = _prayer.doc(prayerID).collection('likesC');

    // Supprimer le document avec le userID comme nom
    await likesRef.doc(userID).delete();
    // Décrémenter le nombre de likes du prayer
    await updateNbrLikes2(prayerID);
  }

// Méthode pour actualiser le nombre de likes du prayer
  Future<void> updateNbrLikes2(String prayerID) async {
    // Créer une référence au document correspondant au prayerID
    DocumentReference prayerRef = _prayer.doc(prayerID);
    // Récupérer le document
    DocumentSnapshot doc = await prayerRef.get();
    // Récupérer le nombre actuel de likes du prayer
    int likes = doc.get('likes');
    // Décrémenter le nombre de likes du prayer
    likes--;
    // Mettre à jour le document avec le nouveau nombre de likes du prayer
    await prayerRef.update({'likes': likes});
  }
}
