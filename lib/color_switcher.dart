import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:color_switch_game/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ColorSwitcher extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double radius;
  late Paint _paint;
  ColorSwitcher({
    this.radius = 20,
    required super.position,
  });

  @override
  FutureOr<void> onLoad() {
    _paint = Paint();
    anchor = Anchor.center;
    size = Vector2.all(radius * 2);
    add(
      CircleHitbox(
        position: size / 2,
        radius: radius,
        anchor: anchor,
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final colors = gameRef.gameColors;
    final arcCount = colors.length;
    const circle = math.pi * 2;
    final arcAngle = circle / arcCount;

    for (int i = 0; i < arcCount; i++) {
      final startAngle = arcAngle * i;
      final color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(
          center: (size / 2).toOffset(),
          radius: radius,
        ),
        startAngle,
        arcAngle,
        true,
        _paint..color = color,
      );
    }
    super.render(canvas);
  }
}
