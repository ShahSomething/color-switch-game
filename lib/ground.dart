import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The ground component should be the first component added to the world.
/// The player cannot pass through the ground.
class Ground extends PositionComponent {
  Ground({required super.position});
  late Sprite fingerSprite;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(100, 100);
    anchor = Anchor.topCenter;

    fingerSprite = await Sprite.load('finger_tap.png');
  }

  @override
  void render(Canvas canvas) {
    fingerSprite.render(
      canvas,
      size: size,
      position: Vector2(8, 0),
    );
    super.render(canvas);
  }
}
