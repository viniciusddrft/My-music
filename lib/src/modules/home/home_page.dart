import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_music/src/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final homeController = HomeController();
  final themeApp = ThemeApp();

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
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: homeController.playFile,
                child: const Text(
                  'Selecionar arquivo',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Text('Tema'),
                  ),
                  const Icon(
                    Icons.light_mode,
                    color: Colors.yellow,
                  ),
                  Switch(
                      value: themeApp.isDarkThemeApp,
                      onChanged: (bool value) async {
                        setState(() {
                          if (!value) {
                            themeApp.changeTheme(Brightness.light);
                            SharedPreferences.getInstance().then(
                              (value) => value.setString('theme', 'light'),
                            );
                          } else {
                            themeApp.changeTheme(Brightness.dark);
                            SharedPreferences.getInstance().then(
                              (value) => value.setString('theme', 'dark'),
                            );
                          }
                        });
                      }),
                  const Icon(
                    Icons.dark_mode,
                    color: Colors.blue,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: themeApp.isDarkThemeApp ? Colors.white : Colors.black),
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

  @override
  void dispose() {
    homeController.dispose();
    super.dispose();
  }
}
