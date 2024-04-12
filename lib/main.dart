import 'package:flutter/material.dart';
import 'package:my_music/src/theme.dart';
import 'src/modules/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeApp = ThemeApp();

  @override
  void initState() {
    themeApp.getThemePreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeApp.theme,
      builder: (BuildContext context, Brightness theme, _) => MaterialApp(
        theme: ThemeData(brightness: theme, primaryColor: Colors.deepPurple),
        title: 'My music',
        home: const MyHomePage(),
      ),
    );
  }

  @override
  void dispose() {
    themeApp.dispose();
    super.dispose();
  }
}
