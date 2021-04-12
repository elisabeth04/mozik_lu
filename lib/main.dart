
import 'dart:io';
import 'dart:ui';
import 'player.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:sleek_circular_slider/sleek_circular_slider.dart';


void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  AudioCache audioCache;
  String path = 'happy birthday.mp3';
  int timeProgress = 0;
  int audioDuration = 0;

  Widget slider() {
    return Container(
      width: 200,
      child: Slider.adaptive(
          value: (timeProgress/1000).floorToDouble(),
          max: (audioDuration/1000).floorToDouble(),
          onChanged: (value){
            seekToSec(value.toInt());
          }),
    );
  }


  @override
  void initState(){
    super.initState();

    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      setState(() {
        audioPlayerState = s;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        timeProgress = p.inMilliseconds;
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
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/blue.jpg"),
            fit: BoxFit.cover,)
          ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(

            children: [
              Center(
                 child:Column(
                    children: <Widget> [
                      Spacer(),

                      Text("Keep Calm",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Livvic',
                              color: Colors.white
                          ) ,
                              ),
                      Text("and",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontFamily: 'Livvic',
                            color: Colors.white
                        ) ,
                      ),
                      Text("HAPPY BIRTHDAY",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Livvic',
                            color: Colors.white
                        ) ,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(getTimeString(timeProgress)),
                        SizedBox(width: 20,),
                        slider(),
                        SizedBox(width: 20,),
                        audioDuration == 0
                            ? getFileAudioDuration()
                            : Text(getTimeString(audioDuration)),
                      ]
                    )
                    ],
                  ),

              ),



              Wrap(
                direction: Axis.vertical,
                verticalDirection: VerticalDirection.down,
                spacing: 18.0,
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.end,
                children: <Widget>[
                  IconButton(
                    iconSize: 50.0,
                    color: Colors.white,
                    onPressed: () {
                      audioPlayerState == AudioPlayerState.PLAYING
                          ? pauseMusic()
                          : playMusic();

                    },
                    icon: Icon(Icons.sentiment_neutral
                    ),
                  ),
                  Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.white,
                      size: 50.0
                  ),
                  Icon(
                      Icons.sentiment_dissatisfied_sharp,
                      color: Colors.white,
                      size: 50.0
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 50,
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 50,
                  ),
                  IconButton(
                      icon: Icon(Icons.amp_stories_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                      MaterialPageRoute(builder: (context) => luplayer()),
                        );
                        },
                  )

                ],
              ),

            ],
          ),
        )
      );
  }

  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor() }';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }

  Widget getFileAudioDuration() {
    return FutureBuilder(
        future: _getAudioDuration(),
        builder: (BuildContext context, AsyncSnapshot <int> snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            return Text(getTimeString(snapshot.data));
          }
          return Text('');
        }
    );
  }

  void seekToSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    audioPlayer.seek(newPosition);
  }

  Future<int> _getAudioDuration() async {
    File audioFile = await audioCache.load(path);
    await audioPlayer.setUrl(audioFile.path);
    audioDuration = await Future.delayed(
      Duration(seconds: 2), () => audioPlayer.getDuration());
    return audioDuration;
  }
}



