import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/stack_object_model.dart';

class DrawingLine extends CustomPainter {
  final List<StackObject> drawingPoints;
  DrawingLine(this.drawingPoints);
  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i].offset != null &&
          drawingPoints[i + 1].offset != null) {
        canvas.drawLine(
            drawingPoints[i].offset as Offset,
            drawingPoints[i + 1].offset as Offset,
            drawingPoints[i].paint as Paint);
      } else if (drawingPoints[i].offset != null &&
          drawingPoints[i + 1].offset == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i].offset as Offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i].paint as Paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingLine oldDelegate) => true;
}
