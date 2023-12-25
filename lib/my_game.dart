import 'dart:async';

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

  @override
  Color backgroundColor() {
    return const Color(0xFF222222);
  }

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
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
    player = Player(position: Vector2(0, 250));
    ground = Ground(position: Vector2(0, 400));
    world.add(ground);
    world.add(player);
    camera.moveTo(Vector2.zero());
    _generateCircleComponent();
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
}
