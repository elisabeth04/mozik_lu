import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';


class luplayer extends StatefulWidget {
  @override
  _luplayerState createState() => _luplayerState();
}

class _luplayerState extends State<luplayer> {


  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  AudioCache audioCache;
  String path = 'Bach Airona G String.mp3';

  final slider = SleekCircularSlider(
    value: (timeProgress/1000).floorToDouble(),
    max: (audioDuration/1000).floorToDouble(),
    onChanged: (value){
      seekToSec(value.toInt());
    }
  );


  @override
  void initState(){
    super.initState();

    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });
  }

  @override
  void dispose(){
    super.dispose;
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearCache();
  }

  playMusic() async {
    await audioCache.play(path);
  }
  pauseMusic() async {
    await audioPlayer.pause();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
        child: ElevatedButton(
        onPressed: () {
      Navigator.pop(context);
    },
    child: Text('Go back!'),
    ),
    )
    );
  }
}
