import 'package:color_switch_game/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = MyGame();
  runApp(
    GameWidget(game: game),
  );
}
