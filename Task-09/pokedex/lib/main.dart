import 'package:flutter/material.dart';
import 'package:pokedex/MiniGameMenu.dart';
import 'home.dart';
import 'browse.dart';
import 'shop.dart';
import 'silhouette.dart';
import 'LoginPage.dart';
import 'Settings.dart';
// import 'second_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/shop': (context) => const Shop(),
        '/browse': (context) => const Browse(),
        '/minigames': (context) => const MiniGameMenu(),
        '/silhouette': (context) => const SilhouetteGame(),
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const Settings()
      },
    );
  }
}