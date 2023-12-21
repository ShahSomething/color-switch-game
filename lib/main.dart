import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = MyGame();
  runApp(
    GameWidget(game: game),
  );
}

class MyGame extends FlameGame with TapCallbacks {
  late Player player;
  @override
  Color backgroundColor() {
    return const Color(0xFF222222);
  }

  @override
  void onMount() {
    player = Player();
    add(player);
    super.onMount();
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    super.onTapDown(event);
  }
}

class Player extends PositionComponent {
  final Vector2 _speed = Vector2(0, 3);
  final double _gravity = 980.0;

  @override
  FutureOr<void> onLoad() {
    position = Vector2(100, 100);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += _speed * dt;
    _speed.y += _gravity * dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      position.toOffset(),
      15,
      Paint()..color = const Color(0xFF00FF00),
    );
    super.render(canvas);
  }

  jump() {
    _speed.y = -300;
  }
}
