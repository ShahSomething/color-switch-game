import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The ground component should be the first component added to the world.
/// The player cannot pass through the ground.
class Ground extends PositionComponent {
  Ground({required super.position});
  @override
  Future<void> onLoad() async {
    size = Vector2(100, 2);
    anchor = Anchor.center;
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.red);
    super.render(canvas);
  }
}
