import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupe_des_vainqueurs/modeles/audios.dart';
import 'package:groupe_des_vainqueurs/vues/audio_player_screen.dart';
import 'package:provider/provider.dart';

class AudioListScreen extends StatefulWidget {
  @override
  _AudioListScreenState createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  int? currentAudio;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          Provider<AudioModel>(create: (_) => AudioModel()),
          //Provider<StorageService>(create: (_) => StorageService()),
          StreamProvider<List<AudioModel>>.value(
            value: AudioModel().audio,
            initialData: [],
          ),
        ],
        child: Consumer<List<AudioModel>>(
          builder: (context, audios, child) {
            return ListView.builder(
              itemCount: audios.length,
              itemBuilder: (context, index) {
                final audio = audios[index];
                return Column(
                  children: [
                    Divider(
                      color: Colors.grey[300],
                      indent: 30.0,
                      endIndent: 30.0,
                      height: 0.5,
                    ),
                    ListTile(
                      selected: currentAudio == index,
                      selectedColor: Colors.orange[200],
                      leading: Icon(
                        Icons.church,
                        size: 35,
                        color: Colors.orange[900],
                      ),
                      title: Text((audio.titre).toString()),
                      subtitle: (audio.date_publication).toString() == null
                          ? Text((audio.date_publication).toString())
                          : Text(Timestamp.now().toDate().day.toString() +
                              '-' +
                              Timestamp.now().toDate().month.toString() +
                              '-' +
                              Timestamp.now().toDate().year.toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                size: 30,
                              ),
                              onPressed: () {
                                currentAudio = index;
                                showBottomSheet(
                                    context: context,
                                    builder: (_) => AudioPlayerScreen(
                                        link: (audio.url).toString(),
                                        onStop: () {
                                          currentAudio = null;
                                          setState(() {});
                                        }));
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.download,
                                size: 30,
                              ),
                              onPressed: () {
                                AudioModel().downloadAudio2(
                                    audio.url.toString(), audio, context);
                                // showBottomSheet(
                                //     context: context,
                                //     builder: (_) => AudioPlayerScreen(
                                //         link: (audio.url).toString()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
