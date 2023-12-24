import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:color_switch_game/rotating_circle.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame with TapCallbacks {
  MyGame(
      {this.gameColors = const [
        Colors.redAccent,
        Colors.blueAccent,
        Colors.greenAccent,
        Colors.yellowAccent
      ]})
      : super(
          camera: CameraComponent.withFixedResolution(width: 600, height: 1200),
        );

  late Player player;
  late Ground ground;
  final List<Color> gameColors;
  @override
  Color backgroundColor() {
    return const Color(0xFF222222);
  }

  @override
  void onMount() {
    player = Player(position: Vector2(0, 250));
    //camera.follow(player);
    ground = Ground(position: Vector2(0, 400));
    world.add(ground);
    world.add(player);
    generateCircleComponent();

    super.onMount();
  }

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = player.position.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = player.position;
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    super.onTapDown(event);
  }

  generateCircleComponent() {
    world.add(
      RotatingCircle(
        position: Vector2(0, 0),
        radius: 100,
      ),
    );
  }
}
