import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioModel {
  CollectionReference _audio = FirebaseFirestore.instance.collection('audio');
  FirebaseStorage _storage = FirebaseStorage.instance;

  String? nom;
  String? url;
  String? titre;
  Timestamp? date_publication = Timestamp.now();

  AudioModel({this.titre, this.url, nom, this.date_publication});

  void addAudio(AudioModel audioModel) {
    _audio.add({
      "nom": audioModel.nom,
      "url": audioModel.url,
      "titre": audioModel.titre,
      "date_publication": audioModel.date_publication,
    });
  }

  // suppression de l'actualité
  Future<void> deleteaudioModel(String audioID) => _audio.doc(audioID).delete();
  // Récuperation de toutes les actualités en temps réel
  Stream<List<AudioModel>> get audio {
    Query queryTopicality =
        _audio.orderBy('date_publication', descending: true);
    return queryTopicality.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AudioModel(
          nom: doc.get('nom'),
          url: doc.get('url'),
          titre: doc.get('titre'),
          date_publication: doc.get('date_publication'),
        );
      }).toList();
    });
  }

  // Télécharge un fichier audio local vers le stockage Firebase et renvoie son URL
  Future<String> uploadAudio(File file, String name) async {
    final ref = _storage.ref().child('audio').child(name);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Télécharge un fichier audio du stockage Firebase vers le stockage local et renvoie son chemin
  Future<String> downloadAudio(String url, String name) async {
    final ref = _storage.refFromURL(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await ref.writeToFile(file);
    return file.path;
  }

  // Supprime un fichier audio du stockage Firebase
  Future<void> deleteAudio(String url) async {
    final ref = _storage.refFromURL(url);
    await ref.delete();
  }

  // Méthode pour télécharger le fichier audio à partir de l'url
  Future<void> downloadAudio2(
      String url, AudioModel audio, BuildContext context) async {
    // Récupérer le répertoire de stockage externe du téléphone
    Directory? storageDir = await getExternalStorageDirectory();
    // Vérifier si le répertoire GDV existe
    Directory gdvDir = Directory(storageDir!.path + '/GDV');
    print(gdvDir.absolute.path +
        "--------------------------------------------------");
    bool exists = await gdvDir.exists();
    // Si le répertoire GDV n'existe pas, le créer
    if (!exists) {
      await gdvDir.create();
    }

    // Créer le chemin du fichier audio avec le titre comme nom dans le répertoire GDV
    var filePath = gdvDir.path + '/' + audio.titre.toString() + '.mp3';
    // Créer une requête HTTP pour télécharger le fichier audio
    http.Response response = await http.get(Uri.parse(url));
    // Vérifier le code de statut de la réponse
    if (response.statusCode == 200) {
      // Si le code est 200, cela signifie que le lien est valide et que le fichier audio existe
      // Écrire les données de la réponse dans le fichier audio
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      // Vérifier que le fichier audio existe dans le téléphone
      if (await file.exists()) {
        // Si le fichier existe, afficher un message pour indiquer que le téléchargement est terminé
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Téléchargement terminé'),
          ),
        );
      } else {
        // Si le fichier n'existe pas, afficher un message pour indiquer que le téléchargement a échoué
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Téléchargement échoué'),
          ),
        );
      }
    } else {
      // Si le code n'est pas 200, cela signifie que le lien est invalide ou que le fichier audio n'existe pas
      // Afficher un message pour indiquer que le téléchargement a échoué
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Téléchargement échoué'),
        ),
      );
    }
  }
}
