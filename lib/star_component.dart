import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent {
  StarComponent({required super.position});
  late Sprite _starSprite;
  @override
  FutureOr<void> onLoad() async {
    _starSprite = await Sprite.load('star_icon.png');
    anchor = Anchor.center;
    size = Vector2(30, 30);
    decorator.addLast(PaintDecorator.tint(Colors.white));
    add(CircleHitbox(
      radius: size.x / 2,
      collisionType: CollisionType.passive,
    ));
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _starSprite.render(
      canvas,
      size: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    super.render(canvas);
  }
}
