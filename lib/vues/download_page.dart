// Importation des packages nécessaires
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

// Création d'un widget stateful pour gérer l'état du lecteur audio
class AudioList extends StatefulWidget {
  // Création du constructeur du widget
  const AudioList({Key? key}) : super(key: key);

  // Création de l'état du widget
  @override
  _AudioListState createState() => _AudioListState();
}

// Création de la classe de l'état du widget
class _AudioListState extends State<AudioList> {
  // Création d'une liste vide de fichiers audio
  List<File> _audioFiles = [];

  // Création d'un lecteur audio
  AudioPlayer _audioPlayer = AudioPlayer();

  // Création d'une variable pour stocker l'index du fichier audio en cours de lecture
  int? _playingIndex;

  // Méthode pour initialiser l'état du widget
  @override
  void initState() {
    super.initState();
    // Appel de la méthode pour récupérer les fichiers audio du répertoire GDV
    getAudioFiles();
  }

  // Méthode pour récupérer les fichiers audio du répertoire GDV
  Future<void> getAudioFiles() async {
    // Récupérer le répertoire de stockage externe du téléphone
    Directory? storageDir = await getExternalStorageDirectory();
    // Récupérer le répertoire GDV
    Directory gdvDir = Directory(storageDir!.path + '/GDV');
    // Vérifier si le répertoire GDV existe
    bool exists = await gdvDir.exists();
    // Si le répertoire GDV existe
    if (exists) {
      // Récupérer la liste des fichiers du répertoire GDV
      List<FileSystemEntity> files = gdvDir.listSync();
      // Filtrer les fichiers qui ont l'extension .mp3
      List<File> audioFiles = files
          .where((file) => file.path.endsWith('.mp3'))
          .map((file) => File(file.path))
          .toList();
      // Mettre à jour l'état du widget avec la liste des fichiers audio
      setState(() {
        _audioFiles = audioFiles;
      });
    }
  }

  // Méthode pour construire le widget
  @override
  Widget build(BuildContext context) {
    // Retourner un widget Scaffold
    return Scaffold(
      // Définir l'appbar du Scaffold
      appBar: AppBar(
        // Définir le titre de l'appbar
        title: Text('Liste des fichiers audio'),
      ),
      // Définir le corps du Scaffold
      body: _audioFiles.isEmpty
          // Si la liste des fichiers audio est vide, afficher un widget Center avec un texte
          ? Center(
              child: Text('Aucun fichier audio trouvé'),
            )
          // Sinon, afficher un widget ListView.builder pour afficher la liste des fichiers audio
          : ListView.builder(
              // Définir le nombre d'éléments de la liste
              itemCount: _audioFiles.length,
              // Définir le constructeur d'éléments de la liste
              itemBuilder: (context, index) {
                // Récupérer le fichier audio à l'index courant
                File audioFile = _audioFiles[index];
                // Récupérer le nom du fichier audio sans l'extension
                String audioName =
                    audioFile.path.split('/').last.split('.').first;
                // Retourner un widget Card pour afficher le nom et les boutons de lecture et d'arrêt du fichier audio
                return Card(
                    // Définir la marge du Card
                    margin: EdgeInsets.all(8.0),
                    // Définir le widget enfant du Card
                    child: ListTile(
                      // Définir le titre du ListTile
                      title: Text(audioName),
                      // Définir le widget de début du ListTile
                      leading: CircleAvatar(
                        // Définir l'icône du CircleAvatar
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                        // Définir la couleur de fond du CircleAvatar
                        backgroundColor: Colors.blueGrey,
                      ),
                      // Définir le widget de fin du ListTile
                      trailing: IconButton(
                        // Définir l'icône du bouton
                        icon: Icon(Icons.play_arrow),
                        // Définir l'action du bouton
                        onPressed: () async {
                          // Arrêter le lecteur audio s'il est en cours de lecture
                          await _audioPlayer.stop();
                          // Charger le fichier audio dans le lecteur audio
                          await _audioPlayer.setFilePath(audioFile.path);
                          // Lancer la lecture du fichier audio
                          await _audioPlayer.play();
                        },
                      ),
                    ));
              },
            ),
    );
  }
}
