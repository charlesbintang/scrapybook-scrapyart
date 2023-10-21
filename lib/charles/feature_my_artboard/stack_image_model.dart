import 'dart:io';

enum OnAction { isFalse, isClicked, isScaling }

class StackImage {
  File? image;
  double top;
  double left;
  double imageWidth;
  double previousImageWidth;
  double imageScale;
  double previousImageScale;
  double rotateValue;
  OnAction onClicked;
  OnAction onScaling;

  StackImage({
    required this.image,
    this.top = 0.0,
    this.left = 0.0,
    this.imageScale = 1.0,
    this.previousImageScale = 1.0,
    this.imageWidth = 200.0,
    this.previousImageWidth = 200.0,
    this.rotateValue = 0.0,
    this.onClicked = OnAction.isFalse,
    this.onScaling = OnAction.isFalse,
  });
}
