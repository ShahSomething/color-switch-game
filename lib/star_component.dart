import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent {
  StarComponent({required super.position});
  late Sprite _starSprite;
  @override
  FutureOr<void> onLoad() async {
    _starSprite = await Sprite.load('star_icon.png');
    anchor = Anchor.center;
    size = Vector2(30, 30);

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

  void showCollisionEffect() {
    final rnd = Random();
    Vector2 randomVector() => (Vector2.random(rnd) - Vector2.random(rnd)) * 100;
    final particle = ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 20,
        lifespan: 1,
        generator: (i) => AcceleratedParticle(
          acceleration: randomVector(),
          speed: randomVector(),
          position: size / 2,
          child: RotatingParticle(
            to: rnd.nextDouble() * pi * 2,
            child: ComputedParticle(renderer: (canvas, particle) {
              var progress = particle.progress;
              var color =
                  Color.lerp(Colors.white, Colors.transparent, (1 - progress));
              _starSprite.render(
                canvas,
                size: (size / 2) * (1 - progress),
                position: size / 2,
                anchor: Anchor.center,
                overridePaint: Paint()..color = color!,
              );
            }),
          ),
        ),
      ),
    );

    parent?.add(particle);
    removeFromParent();
  }
}
