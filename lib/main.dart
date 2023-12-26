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
      debugShowCheckedModeBanner: false,
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
          if (!game.isGamePaused)
            Positioned(
              top: 40,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    onPressed: toggleGameState,
                    icon: const Icon(Icons.pause),
                  ),
                  ValueListenableBuilder(
                      valueListenable: game.currentScore,
                      builder: (context, value, _) {
                        return Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      })
                ],
              ),
            )
          else
            Center(
              child: Container(
                color: Colors.black54,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "PAUSED",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: toggleGameState,
                      iconSize: 140,
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    game.detach();
    super.dispose();
  }
}
