// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:color_switch_game/color_switcher.dart';
import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/my_game.dart';
import 'package:color_switch_game/rotating_circle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double radius;
  Player({this.radius = 12, required super.position});

  final Vector2 _speed = Vector2.zero();
  final double _gravity = 980.0;
  final double _jumpSpeed = -350.0;
  Color _color = Colors.white;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ColorSwitcher) {
      other.removeFromParent();
      _changeColorRandomly();
    } else if (other is CircleArc) {
      if (other.color != _color) {
        debugPrint("Game Over");
        gameRef.gameOver();
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;
    add(
      CircleHitbox(
        position: size / 2,
        radius: radius,
        anchor: anchor,
        collisionType: CollisionType.active,
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += _speed * dt;

    Ground ground = gameRef.ground;
    if (ground.toRect().overlaps(toRect())) {
      position = Vector2(position.x, ground.position.y - radius);
      _speed.y = 0;
    }
    _speed.y += _gravity * dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      (size / 2).toOffset(),
      radius,
      Paint()..color = _color,
    );
    super.render(canvas);
  }

  void jump() {
    _speed.y = _jumpSpeed;
  }

  void _changeColorRandomly() {
    _color = gameRef.gameColors.random();
  }
}
