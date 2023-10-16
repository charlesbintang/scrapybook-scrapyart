import 'dart:io';

class StackImage {
  File? image;
  double top;
  double left;
  double imageWidth;
  double previousImageWidth;
  bool isClicked;

  StackImage({
    required this.image,
    this.top = 0,
    this.left = 0,
    this.imageWidth = 200.0,
    this.previousImageWidth = 200.0,
    this.isClicked = false,
  });
}
