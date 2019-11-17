import 'package:flutter/material.dart';

class Constants {

  ///The height for each cell
  static final double cellHeight = 30.0;

  ///The width for each cell
  static final double cellWidth = 30.0;

  ///The space between all cells
  static final double cellSpace = 10.0;

  ///Paint used to draw dead cells
  static final deadPaint = Paint()
    ..color = Colors.grey[400]
    ..style = PaintingStyle.fill;

  ///Paint used to draw alive cells
  static final alivePaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.fill;
}
