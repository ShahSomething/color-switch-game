import 'package:color_switch_game/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MyGame game;
  @override
  void initState() {
    game = MyGame();
    super.initState();
  }

  toggleGameState() {
    if (game.isGamePaused) {
      game.resumeGame();
    } else {
      game.pauseGame();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: toggleGameState,
              icon: Icon(
                game.isGamePaused ? Icons.play_arrow_rounded : Icons.pause,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
