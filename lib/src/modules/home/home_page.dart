import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'home_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeController homeController = HomeController();

  @override
  void initState() {
    homeController.soundService.durationState.listen((Duration newDuration) {
      homeController.durationMusic.value = newDuration;
    });

    homeController.soundService.positionState.listen((Duration newDuration) {
      homeController.positionMusic.value = newDuration;
    });

    homeController.soundService.playerState.listen((PlayerState playerState) {
      homeController.playerState.value = playerState;
    });
    super.initState();
  }

  @override
  void dispose() {
    homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              TextButton(
                onPressed: homeController.playFile,
                child: const Text(
                  'Selecionar arquivo',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
            )
          ],
        ),
      ),
      body: FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ValueListenableBuilder(
                valueListenable: homeController.nameMusic,
                builder: (BuildContext context, String value, Widget? child) =>
                    Text(
                  homeController.nameMusic.value,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              AnimatedBuilder(
                animation: Listenable.merge([
                  homeController.durationMusic,
                  homeController.positionMusic
                ]),
                builder: (BuildContext context, Widget? child) => homeController
                            .durationMusic.value.inSeconds
                            .toDouble() >=
                        homeController.positionMusic.value.inSeconds.toDouble()
                    ? Slider(
                        min: 0,
                        max: homeController.durationMusic.value.inSeconds
                            .toDouble(),
                        value: homeController.positionMusic.value.inSeconds
                            .toDouble(),
                        onChangeEnd: homeController.changePositionMusic,
                        onChanged: (double value) {
                          homeController.positionMusic.value =
                              Duration(seconds: value.toInt());
                        },
                      )
                    : const CircularProgressIndicator(),
              ),
              Stack(
                children: [
                  Center(
                    child: ValueListenableBuilder(
                      valueListenable: homeController.playerState,
                      builder: (BuildContext context, PlayerState value,
                              Widget? child) =>
                          value == PlayerState.paused ||
                                  value == PlayerState.stopped
                              ? CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    splashRadius: 21,
                                    onPressed: homeController.resume,
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : value == PlayerState.playing
                                  ? CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: IconButton(
                                        splashRadius: 21,
                                        onPressed: homeController.pause,
                                        icon: const Icon(
                                          Icons.pause,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: IconButton(
                                        splashRadius: 21,
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: homeController.volumeMusic,
                          builder:
                              (BuildContext context, value, Widget? child) =>
                                  SizedBox(
                            width: size.width * 0.25,
                            child: Row(
                              children: [
                                Flexible(
                                  child: homeController.volumeMusic.value == 0
                                      ? const Icon(Icons.volume_off)
                                      : homeController.volumeMusic.value < 0.5
                                          ? const Icon(Icons.volume_down)
                                          : const Icon(Icons.volume_up),
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Slider(
                                      value: homeController.volumeMusic.value,
                                      onChanged: homeController.setVolume),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            homeController.durationMusic,
                            homeController.positionMusic
                          ]),
                          builder: (BuildContext context, Widget? child) => Text(
                              '${homeController.positionMusic.value.inMinutes}:${homeController.positionMusic.value.inSeconds.remainder(60)} / ${homeController.durationMusic.value.inMinutes}:${homeController.durationMusic.value.inSeconds.remainder(60)}'),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
