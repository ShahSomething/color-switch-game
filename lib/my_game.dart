import 'package:color_switch_game/color_switcher.dart';
import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:color_switch_game/rotating_circle.dart';
import 'package:color_switch_game/star_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
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
  bool get isGamePaused => timeScale == 0;
  @override
  Color backgroundColor() {
    return const Color(0xFF222222);
  }

  @override
  void onMount() {
    // debugMode = true;
    decorator = PaintDecorator.blur(0);
    _initializeGame();
    super.onMount();
  }

  _initializeGame() {
    player = Player(position: Vector2(0, 250));
    ground = Ground(position: Vector2(0, 400));
    world.add(ground);
    world.add(player);
    camera.moveTo(Vector2.zero());
    _generateCircleComponent();
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

  void _generateCircleComponent() {
    world.add(
      RotatingCircle(
        position: Vector2(0, 0),
        radius: 100,
      ),
    );
    world.add(StarComponent(position: Vector2(0, 0)));
    final colorSwitcher = ColorSwitcher(position: Vector2(0, 200));
    world.add(colorSwitcher);
  }

  void gameOver() {
    for (var component in world.children) {
      component.removeFromParent();
    }
    _initializeGame();
  }

  void pauseGame() {
    (decorator as PaintDecorator).addBlur(4);
    timeScale = 0;
  }

  void resumeGame() {
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1;
  }

  void incrementScore() {
    debugPrint("Scored");
  }
}
