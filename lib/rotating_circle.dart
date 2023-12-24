import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatingCircle extends PositionComponent with HasGameRef<MyGame> {
  final double radius;
  final double thickness;
  final double rotationSpeed;
  RotatingCircle({
    this.radius = 15,
    required super.position,
    this.thickness = 8,
    this.rotationSpeed = 2,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;

    final colors = gameRef.gameColors;
    final arcCount = colors.length;
    const circle = math.pi * 2;
    final arcAngle = circle / arcCount;

    for (int i = 0; i < arcCount; i++) {
      final startAngle = arcAngle * i;
      final color = colors[i];
      final arc = CircleArc(
        startAngle: startAngle,
        sweepAngle: arcAngle,
        color: color,
      );
      add(arc);
    }

    add(
      RotateEffect.to(
        circle,
        EffectController(
          duration: rotationSpeed,
          infinite: true,
        ),
      ),
    );
    super.onLoad();
  }
}

class CircleArc extends PositionComponent with ParentIsA<RotatingCircle> {
  final double startAngle;
  final double sweepAngle;
  final Color color;
  CircleArc({
    this.startAngle = 0,
    this.sweepAngle = 0,
    required this.color,
  });

  @override
  Future<void> onLoad() async {
    size = parent.size;
    position = parent.position;
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    double radius = parent.radius - parent.thickness / 2;
    canvas.drawArc(
      Rect.fromCircle(
        radius: radius,
        center: (size / 2).toOffset(),
      ),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = parent.thickness,
    );
    super.render(canvas);
  }
}
