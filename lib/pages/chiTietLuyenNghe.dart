import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class chiTietLuyenNghe extends StatefulWidget {
  const chiTietLuyenNghe({super.key});

  @override
  State<chiTietLuyenNghe> createState() => _chiTietLuyenNgheState();
}

class _chiTietLuyenNgheState extends State<chiTietLuyenNghe> {

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double sliderMax = 0;


  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
        print("đây này" + duration.toString());
        sliderMax  = newDuration.inSeconds.toDouble();
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position=newPosition;

      });
    });

    setAudio();
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    String url = 'https://www.kozco.com/tech/WAV-MP3.wav';
    audioPlayer.setSourceUrl(url);
    await audioPlayer.pause();
  }


  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hour = twoDigits(duration.inHours);
    final minute = twoDigits(duration.inMinutes.remainder(60));
    final second = twoDigits(duration.inSeconds.remainder(60));
    
    return [
      if( duration.inHours > 0) hour, minute, second,
      
    ].join(':');
  }
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    // return Placeholder();

    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Test 1"),
            backgroundColor: Color(0xFF007C1B),
            toolbarHeight: 70,
          ),
          body: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 26),
                  height: size.height * 0.40,
                  width: size.width*0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey[200]
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          IconButton(
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow
                            ),
                            iconSize: 40,
                            onPressed: () async {
                              if(isPlaying) {
                                await audioPlayer.pause();
                              } else {
                                String url = 'https://www.kozco.com/tech/WAV-MP3.wav';
                                // Source source = Source.fromString(url);
                                // await audioPlayer.setSourceUrl(url);
                                await audioPlayer.play(UrlSource(url));
                              }
                            },
                          ),

                          Slider(
                            min: 0,
                            max: sliderMax,
                            value: position.inSeconds.toDouble(),
                            thumbColor: Colors.green,

                            onChanged: (value) async {
                              final positions = Duration(seconds: value.toInt());
                              await audioPlayer.seek(positions);
                              await audioPlayer.resume();
                            },
                          ),

                          Text(
                            formatTime(duration - position),
                          ),

                        ],
                      ),


                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(16.0),
                          children: [
                            RadioListTile<String>(
                              title: Text('Answer A'),
                              value: 'A',
                              groupValue: selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswer = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Answer B'),
                              value: 'B',
                              groupValue: selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswer = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Answer C'),
                              value: 'C',
                              groupValue: selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswer = value;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Answer D'),
                              value: 'D',
                              groupValue: selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  selectedAnswer = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
