import 'package:flutter/material.dart';
import 'package:game_of_life/constants.dart';

//TODO: Implement drag
class GamePainter extends CustomPainter {
  final Map<Rect, bool> map;
  GamePainter({
    @required this.map,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (Rect rect in map.keys) {
      bool isAlive = map[rect];
      canvas.drawRect(
        rect,
        isAlive ? Constants.alivePaint : Constants.deadPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return true;
  }
}
