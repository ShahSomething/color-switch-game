// import 'dart:async';

// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';

// class RotatingTriangle extends PositionComponent {
//   @override
//   FutureOr<void> onLoad() {
//     size = Vector2(200, 20);
//     position = Vector2(0, 0);
//     anchor = Anchor.center;
//     return super.onLoad();
//   }

//   @override
//   void render(Canvas canvas) {
//     canvas.drawLine(
//       (position + Vector2(0, 10)).toOffset(),
//       (position + Vector2(200, 10)).toOffset(),
//       Paint()
//         ..color = Colors.yellow
//         ..strokeWidth = 20
//         ..strokeCap = StrokeCap.round,
//     );
//     super.render(canvas);
//   }
// }
