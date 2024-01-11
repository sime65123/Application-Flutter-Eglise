import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum AudioSourceOption { Network, Asset }

class AudioPlayerScreen extends StatefulWidget {
  final String link;
  VoidCallback? onStop;
  AudioPlayerScreen({required this.link, this.onStop});
//AudioPlayerScreen(audio: audio),
  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer(AudioSourceOption.Network);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //_sourceSelect(),
              _progessBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _controlButtons(),
                  _playbackControlButton(),
                ],
              )
            ]),
      ),
    );
  }

  Future<void> _setupAudioPlayer(AudioSourceOption option) async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stacktrace) {
      print("A stream error occurred: $e");
    });
    try {
      if (option == AudioSourceOption.Network) {
        await _player.setAudioSource(
            AudioSource.uri(Uri.parse((widget.link).toString())));
      } else if (option == AudioSourceOption.Asset) {
        await _player.setAudioSource(
            AudioSource.asset("assets/audio/pixabay_audio.mp3"));
      }
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Widget _progessBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        StreamBuilder<Duration?>(
          stream: _player.positionStream,
          builder: (context, snapshot) {
            return SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ProgressBar(
                  progress: snapshot.data ?? Duration.zero,
                  buffered: _player.bufferedPosition,
                  total: _player.duration ?? Duration.zero,
                  onSeek: (duration) {
                    _player.seek(duration);
                  },
                ));
          },
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            _player.stop();
            widget.onStop!();
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget _playbackControlButton() {
    return StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final processingState = snapshot.data?.processingState;
          final playing = snapshot.data?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 40,
              height: 40,
              child: const CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 40,
              onPressed: _player.play,
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              icon: const Icon(
                Icons.pause,
                color: Colors.orange,
              ),
              iconSize: 40,
              onPressed: _player.pause,
            );
          } else {
            return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 40,
                onPressed: () => _player.seek(Duration.zero));
          }
        });
  }

  Widget _controlButtons() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      StreamBuilder(
          stream: _player.speedStream,
          builder: (context, snapshot) {
            return Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(
                Icons.speed,
              ),
              Slider(
                  min: 1,
                  max: 3,
                  value: snapshot.data ?? 1,
                  divisions: 3,
                  onChanged: (value) async {
                    await _player.setSpeed(value);
                  })
            ]);
          }),
      StreamBuilder(
          stream: _player.volumeStream,
          builder: (context, snapshot) {
            return Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(
                Icons.volume_up,
              ),
              Slider(
                  min: 0,
                  max: 3,
                  value: snapshot.data ?? 1,
                  divisions: 4,
                  onChanged: (value) async {
                    await _player.setVolume(value);
                  })
            ]);
          }),
    ]);
  }
}
