import 'dart:io';

class StackImage {
  File? image;
  double top;
  double left;

  StackImage({required this.image, this.top = 0, this.left = 0});
}
