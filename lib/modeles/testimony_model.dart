import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestimonyModel {
  CollectionReference _testimony =
      FirebaseFirestore.instance.collection('testimony');
  FirebaseStorage _storage = FirebaseStorage.instance;
  final String? urlBanniere;
  final String? titre;
  final Timestamp? heureDePublication;
  int? nombreDeLikes;
  final int? nombreDeVues;
  final String? urlYoutube;

  TestimonyModel({
    this.urlBanniere,
    this.titre,
    this.heureDePublication,
    this.nombreDeLikes = 0,
    this.nombreDeVues = 0,
    this.urlYoutube,
  });
  // ajout de l'actualité dans la BDD
  void addTestimony(TestimonyModel testimonyModel) {
    _testimony.add({
      "urlBanniere": testimonyModel.urlBanniere,
      "titre": testimonyModel.titre,
      "nombreDeLikes": testimonyModel.nombreDeLikes,
      "nombreDeVues": testimonyModel.nombreDeVues,
      "heureDePublication": FieldValue.serverTimestamp(),
      "urlYoutube": testimonyModel.urlYoutube,
    });
  }

  // suppression de l'actualité
  Future<void> deletetestimonyModel(String testimonyID) =>
      _testimony.doc(testimonyID).delete();
  // Récuperation de toutes les actualités en temps réel
  Stream<List<TestimonyModel>> get testimony {
    Query queryTopicality =
        _testimony.orderBy('heureDePublication', descending: true);
    return queryTopicality.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TestimonyModel(
          titre: doc.get('titre'),
          urlBanniere: doc.get('urlBanniere'),
          nombreDeLikes: doc.get('nombreDeLikes'),
          nombreDeVues: doc.get('nombreDeVues'),
          heureDePublication: doc.get('heureDePublication'),
          urlYoutube: doc.get('urlYoutube'),
        );
      }).toList();
    });
  }
}
