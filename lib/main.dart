import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);

    animation = ColorTween(
      begin: Colors.amber,
      end: Colors.blueAccent,
    ).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  AudioPlayer player = AudioPlayer();

  Map<String, String> mapAudios = {
    'aiaiai': 'assets/audios/aiaiai-rodrigo-faro.mp3',
    'cavalo': 'assets/audios/cavalo-rodrigo-faro.mp3',
    'ela gosta': 'assets/audios/ele-g0sta.mp3',
    'ui': 'assets/audios/ui-rodrigo-faro.mp3',
    'uepaaa': 'assets/audios/uuuuueeeeeeepppaaaaaa.mp3',
    'esqueca tudo': 'assets/audios/esqueca-tudo-rodrigo-faro.mp3',
    'macaco': 'assets/audios/despertador_macaco_audiosparazap.com.mp3',
  };

  void play(String pathAudio) {
    player.setAsset(pathAudio);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Master plus sound effects"),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 4,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.amber,
            child: ElevatedButton(
              child: const Text("Aleatório"),
              onPressed: () {
                final random = Random();
                int index = random.nextInt(mapAudios.entries.length * 1000);

                final entry = mapAudios.entries
                    .elementAt(index % 1000 % mapAudios.entries.length);
                play(entry.value);
              },
            ),
          ),
          for (var entry in mapAudios.entries)
            StreamBuilder(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  return AnimatedBuilder(
                      animation: animation,
                      builder: (context, snapshot) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          color: animation.value,
                          child: ElevatedButton(
                            child: Text(entry.key),
                            onPressed: () {
                              play(entry.value);
                            },
                          ),
                        );
                      });
                }),
        ],
      ),
    );
  }
}
