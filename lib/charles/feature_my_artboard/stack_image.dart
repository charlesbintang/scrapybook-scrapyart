import 'dart:io';

enum Layers {
  layerA,
  layerB,
  layerC,
  layerD,
  layerE,
}

class StackImage {
  File? image;
  double top;
  double left;

  StackImage({required this.image, this.top = 0, this.left = 0});
}







// Future _pickImageFromGallery1() async {
//   final returnedImage =
//       await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (returnedImage == null) return;
//   setState(() {
//     _selectedImage1 = File(returnedImage.path);
//     isFilePicked = true;
//   });
// }
