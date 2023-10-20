import 'dart:io';

class StackImage {
  File? image;
  double top;
  double left;
  double imageWidth;
  double previousImageWidth;
  double imageScale;
  double previousImageScale;
  double rotateValue;
  bool isClicked;

  StackImage({
    required this.image,
    this.top = 0.0,
    this.left = 0.0,
    this.imageScale = 1.0,
    this.previousImageScale = 1.0,
    this.imageWidth = 200.0,
    this.previousImageWidth = 200.0,
    this.rotateValue = 0.0,
    this.isClicked = false,
  });
}
