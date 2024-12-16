import 'package:flutter/material.dart';
import 'package:transit_flutter_app/MyHomePage.dart';
import 'package:transit_flutter_app/Theme%20Provider/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
      home: const Myhomepage(),
    );
  }
}
