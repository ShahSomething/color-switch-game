import 'package:color_switch_game/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks {
  MyGame()
      : super(
          camera: CameraComponent.withFixedResolution(width: 600, height: 1200),
        );

  late Player player;
  @override
  Color backgroundColor() {
    return const Color(0xFF222222);
  }

  @override
  void onMount() {
    player = Player();
    world.add(player);

    super.onMount();
  }

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = player.position.y;

    if (playerY < cameraY) {
      camera.viewport.position = Vector2(0, playerY) * dt;
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    super.onTapDown(event);
  }
}
