import 'dart:io';

enum OnTapWinner { none, clicked }

class StackImage {
  File? image;
  double top;
  double left;
  double scale;
  double previousScale;
  OnTapWinner click;

  StackImage({
    required this.image,
    this.top = 0,
    this.left = 0,
    this.scale = 10.0,
    this.previousScale = 10.0,
    this.click = OnTapWinner.none,
  });
}
