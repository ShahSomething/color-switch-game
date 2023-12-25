import 'dart:async';
import 'dart:math';

import 'package:color_switch_game/color_switcher.dart';
import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/player.dart';
import 'package:color_switch_game/rotating_circle.dart';
import 'package:color_switch_game/star_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
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
  final ValueNotifier<int> currentScore = ValueNotifier(0);
  bool get isGamePaused => timeScale == 0;

  double lastObstaclePosition = -400;
  double obstacleSpacing = 400;

  @override
  Color backgroundColor() {
    return const Color(0xFF222222);
  }

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    Flame.images.loadAll([
      'star_icon.png',
      'finger_tap.png',
    ]);
    FlameAudio.audioCache.loadAll([
      'bg_music.mp3',
      'score.wav',
      'jump.wav',
      'crash.wav',
    ]);
    FlameAudio.bgm.initialize();
    decorator = PaintDecorator.blur(0);
    return super.onLoad();
  }

  @override
  void onMount() {
    _initializeGame();
    super.onMount();
  }

  _initializeGame() {
    currentScore.value = 0;
    lastObstaclePosition = -400;
    obstacleSpacing = 400;
    player = Player(position: Vector2(0, 250));
    ground = Ground(position: Vector2(0, 400));
    world.add(ground);
    world.add(player);
    camera.moveTo(Vector2.zero());
    _generateCircleComponent(
      position: Vector2(0, 0),
      radius: 100,
    );
    _generateCircleComponent(
      position: Vector2(0, -400),
      radius: 100,
    );
    if (FlameAudio.bgm.isPlaying) FlameAudio.bgm.stop();

    FlameAudio.bgm.play(
      'bg_music.mp3',
    );
  }

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = player.position.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = player.position;
    }

    // Check if it's time to generate a new obstacle
    if (playerY <= lastObstaclePosition - obstacleSpacing) {
      var circleCount = Random().nextInt(2) + 1;
      // Generate a new obstacle
      _generateCircleComponent(
        position: Vector2(0, lastObstaclePosition - 2 * obstacleSpacing),
        radius: 100,
        circleCount: circleCount,
      );

      // Update the position of the last obstacle
      lastObstaclePosition -= obstacleSpacing;
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    super.onTapDown(event);
  }

  void _generateCircleComponent(
      {required Vector2 position,
      required double radius,
      int circleCount = 1}) {
    double totalArcLength = 0.0;
    // Calculate the total arc length for both circles
    for (int i = 0; i < circleCount; i++) {
      double currentRadius =
          radius - (i * 16); // Adjusted based on your description
      double currentCircumference = 2 * pi * currentRadius; // Pi * Diameter

      totalArcLength += currentCircumference;
    }
    // Calculate linear speed to meet in 3 seconds
    double linearSpeed = totalArcLength / 3;
    for (int i = 0; i < circleCount; i++) {
      double currentRadius =
          radius - (i * 16); // Adjusted based on your description
      double currentRotationSpeed = linearSpeed / currentRadius;
      final circle = RotatingCircle(
        position: position,
        radius: currentRadius,
        rotationSpeed: currentRotationSpeed,
      );
      world.add(circle);
    }
    world.add(StarComponent(position: position));
    final colorSwitcher = ColorSwitcher(position: position + Vector2(0, 200));
    world.add(colorSwitcher);
  }

  void gameOver() {
    FlameAudio.play('crash.wav');
    FlameAudio.bgm.stop();
    for (var component in world.children) {
      component.removeFromParent();
    }
    _initializeGame();
  }

  void pauseGame() {
    FlameAudio.bgm.pause();
    (decorator as PaintDecorator).addBlur(4);
    timeScale = 0;
  }

  void resumeGame() {
    FlameAudio.bgm.resume();
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1;
  }

  void incrementScore() {
    currentScore.value++;
  }

  @override
  void onDispose() {
    FlameAudio.bgm.dispose();
    super.onDispose();
  }

  @override
  void onRemove() {
    // Optional based on your game needs.
    removeAll(children);
    processLifecycleEvents();
    Flame.images.clearCache();
    Flame.assets.clearCache();
    FlameAudio.audioCache.clearAll();
    FlameAudio.bgm.dispose();
    // Any other code that you want to run when the game is removed.
  }
}
