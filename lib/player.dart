// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  final double radius;
  Player({this.radius = 15});

  final Vector2 _speed = Vector2.zero();
  final double _gravity = 980.0;
  final double _jumpSpeed = -350.0;

  @override
  FutureOr<void> onLoad() {
    position = Vector2.zero();
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;
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
      (size / 2).toOffset(),
      radius,
      Paint()..color = const Color(0xFF00FF00),
    );
    super.render(canvas);
  }

  jump() {
    _speed.y = _jumpSpeed;
  }
}
