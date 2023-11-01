import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/drawing_point.dart';

class DrawingLine extends CustomPainter {
  final List<DrawingPoint> drawingPoints;
  DrawingLine(this.drawingPoints);
  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i].offset !=
              const Offset(
                -10.0,
                -10.0,
              ) &&
          drawingPoints[i + 1].offset !=
              const Offset(
                -10.0,
                -10.0,
              )) {
        canvas.drawLine(drawingPoints[i].offset, drawingPoints[i + 1].offset,
            drawingPoints[i].paint);
      } else if (drawingPoints[i].offset !=
              const Offset(
                -10.0,
                -10.0,
              ) &&
          drawingPoints[i + 1].offset ==
              const Offset(
                -10.0,
                -10.0,
              )) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i].offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingLine oldDelegate) => true;
}
