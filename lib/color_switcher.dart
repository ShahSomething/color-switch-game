import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:color_switch_game/my_game.dart';
import 'package:flame/components.dart';

class ColorSwitcher extends PositionComponent with HasGameRef<MyGame> {
  final double radius;
  ColorSwitcher({
    this.radius = 20,
    required super.position,
  });

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;
    size = Vector2.all(radius * 2);
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
        Paint()..color = color,
      );
    }
    super.render(canvas);
  }
}
