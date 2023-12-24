// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:color_switch_game/ground.dart';
import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  final double radius;
  Player({this.radius = 12, required super.position});

  final Vector2 _speed = Vector2.zero();
  final double _gravity = 980.0;
  final double _jumpSpeed = -350.0;
  final Color _color = Colors.white;

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;
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

  jump() {
    _speed.y = _jumpSpeed;
  }
}
