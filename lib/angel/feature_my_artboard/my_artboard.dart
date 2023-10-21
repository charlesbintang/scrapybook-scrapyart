import 'package:flutter/material.dart';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:scrapyart_home/angel/edit_image_viewmodel.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/image_text.dart';
// import 'package:scrapyart_home/angel/feature_my_artboard/stack_image_model.dart';
import 'package:screenshot/screenshot.dart';

class MyArtboard extends StatefulWidget {
  const MyArtboard({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyArtboard> createState() => _MyArtboardState();
}

class _MyArtboardState extends EditImageViewModel {
  // double _sliderValue = 0.0;

  // List<Color> _colorOptions = [
  //   Colors.black,
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.yellow,
  //   Colors.purple,
  //   Colors.orange,
  // ];
  // Color selectedColor = Colors.black; // Warna awal

  // updateTextColor(double value) {
  //   setState(() {
  //     _sliderValue = value;
  //     int colorIndex = (_sliderValue * (_colorOptions.length - 1)).round();
  //     selectedColor = _colorOptions[colorIndex];
  //   });
  // }

  ScreenshotController screenshotController = ScreenshotController();

  // File? _selectedImage;

  bool isFilePicked = false;

  // Offset _tapPosition = Offset.zero;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title:
            Text("MyArtboard", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(clipBehavior: Clip.none, children: [
          Center(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                height: 375,
                width: 375,
                margin: const EdgeInsets.only(bottom: 250),
                // child: Stack(children: dataStack()),
                child: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Stack(
                      children: [
                        for (int i = 0; i < texts.length; i++)
                          Positioned(
                            left: texts[i].left,
                            top: texts[i].top,
                            child: GestureDetector(
                              onLongPress: () {
                                print('long press detected');
                              },
                              onTap: () => setCurrentIndex(context, i),
                              child: Draggable(
                                feedback: ImageText(textInfo: texts[i]),
                                child: ImageText(textInfo: texts[i]),
                                onDragEnd: (drag) {
                                  final renderBox =
                                      context.findRenderObject() as RenderBox;
                                  Offset off =
                                      renderBox.globalToLocal(drag.offset);
                                  setState(() {
                                    texts[i].color = selectedColor;
                                    texts[i].top = off.dy - 120;
                                    texts[i].left = off.dx;
                                  });
                                },
                              ),
                            ),
                          ),
                        // creatorText.text.isNotEmpty
                        //     ? Positioned(
                        //         left: 0,
                        //         bottom: 0,
                        //         child: Text(
                        //           creatorText.text,
                        //           style: TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold,
                        //               color:
                        //                   Color.fromARGB(255, 161, 0, 0)
                        //                       .withOpacity(
                        //                 0.3,
                        //               )),
                        //         ),
                        //       )
                        //     : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 400,
              height: 250,
              color: Color.fromARGB(255, 240, 240, 240),
            ),
          ),
          Positioned(
            bottom: 150,
            right: 0,
            left: 0,
            child: Container(
              color: const Color.fromARGB(255, 122, 74, 37),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.note_add_outlined,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.format_paint_outlined,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(
                      Icons.text_fields_rounded,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.square_outlined,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.face_retouching_natural_rounded,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.brush_rounded,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 25,
                    icon: const Icon(
                      Icons.layers,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            right: 0,
            left: 0,
            child: Container(
              height: 40,
              child: colorSlider(),
            ),
          ),
          // Positioned(
          //   bottom: 100,
          //   right: 0,
          //   left: 0,
          //   child: SizedBox(
          //     height: 50,
          //     width: double.infinity,
          //     child: ListView(
          //       children: [],
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 100,
            right: 0,
            left: 0,
            child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    IconButton(
                      onPressed: () => addNewDialog(context),
                      icon: const Icon(
                        Icons.add_rounded,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: increaseFontSize,
                      icon: const Icon(
                        Icons.text_increase_rounded,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: decreaseFontSize,
                      icon: const Icon(
                        Icons.text_decrease_rounded,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: boldText,
                      icon: const Icon(
                        Icons.format_bold_rounded,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: italicText,
                      icon: const Icon(
                        Icons.format_italic_rounded,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: underlineText,
                      icon: const Icon(
                        Icons.format_underline_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}

// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:scrapyart_home/angel/edit_image_viewmodel.dart';
// import 'package:scrapyart_home/angel/feature_my_artboard/stack_image_model.dart';
// import 'package:screenshot/screenshot.dart';

// extension on List {
//   void moveImage(StackImage element, int shift) {
//     if (contains(element)) {
//       final curPos = indexOf(element);
//       final newPos = curPos + shift;
//       if (newPos >= 0 && newPos < length) {
//         removeAt(curPos);
//         insert(newPos, element);
//       }
//     }
//   }
// }

// class MyArtboard extends StatefulWidget {
//   const MyArtboard({Key? key}) : super(key: key);

//   @override
//   State<MyArtboard> createState() => _MyArtboardState();
// }

// class _MyArtboardState extends EditImageViewModel {
//   ScreenshotController screenshotController = ScreenshotController();

//   File? _selectedImage;

//   bool isFilePicked = false;

//   Offset _tapPosition = Offset.zero;

//   void _getTapPosition(TapDownDetails tapPostion) {
//     final RenderBox renderBox = context.findRenderObject() as RenderBox;
//     setState(() {
//       _tapPosition = renderBox.globalToLocal(tapPostion.globalPosition);
//       print(_tapPosition);
//     });
//   }

//   List<StackImage> globalListImage = [];

//   // buat kembalikan list widget yang akan di tumpuk
//   List<Widget> dataStack() {
//     List<Widget> data = [];
//     for (var i = 0; i < globalListImage.length; i++) {
//       var imageOnCurentIndex = globalListImage[i];
//       data.add(Positioned(
//         top: imageOnCurentIndex.top,
//         left: imageOnCurentIndex.left,
//         child: GestureDetector(
//           onTapDown: (position) {
//             _getTapPosition(position);
//             print("index $i");
//           },
//           onLongPress: () {
//             moveImage(i).then((value) {
//               setState(() {});
//             });
//           },
//           onPanUpdate: (details) {
//             imageOnCurentIndex.top =
//                 max(0, imageOnCurentIndex.top + details.delta.dy);
//             imageOnCurentIndex.left =
//                 max(0, imageOnCurentIndex.left + details.delta.dx);
//             setState(() {});
//           },
//           child: Image.file(imageOnCurentIndex.image!),
//         ),
//       ));
//     }
//     return data;
//   }

//   Future<void> moveImage(
//     int indexImage,
//   ) async {
//     final RenderObject? overlay =
//         Overlay.of(context).context.findRenderObject();

//     var up = PopupMenuItem(
//       child: const Text("Bawa Maju"),
//       onTap: () {
//         globalListImage.moveImage(globalListImage[indexImage], 1);
//       },
//     );

//     var down = PopupMenuItem(
//       child: const Text("Bawa Mundur"),
//       onTap: () {
//         globalListImage.moveImage(globalListImage[indexImage], -1);
//       },
//     );

//     List<PopupMenuItem<dynamic>> actions = [];

//     // gambar pertama
//     if (indexImage == 0) {
//       actions.add(up);
//     } else if (indexImage == globalListImage.length - 1) {
//       actions.add(down);
//     } else {
//       actions.add(up);
//       actions.add(down);
//     }

//     await showMenu(
//         context: context,
//         position: RelativeRect.fromRect(
//           Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
//           Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
//               overlay.paintBounds.size.height),
//         ),
//         items: actions);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(218, 255, 255, 255),
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         title:
//             Text("MyArtboard", style: Theme.of(context).textTheme.titleLarge),
//         centerTitle: true,
//       ),
//       body: isFilePicked == true
//           ? artboardCanvas(context)
//           : Center(
//               child: Text(
//               "Tidak ada gambar, silakan impor sebuah gambar",
//               style: Theme.of(context).textTheme.bodyMedium,
//             )),
//       floatingActionButton: Stack(children: [
//         Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//           if (globalListImage.isNotEmpty)
//             ElevatedButton(
//               onPressed: () => saveToGallery(context),
//               child: Text("Simpan",
//                   style: TextStyle(color: Theme.of(context).primaryColor)),
//             ),
//           const SizedBox(width: 10),
//           _addnewTextFab,
//           const SizedBox(width: 10),
//           ElevatedButton(
//             onPressed: () {
//               _pickImageFromGallery1();
//             },
//             child: Text("Impor gambar ${globalListImage.length + 1}",
//                 style: TextStyle(color: Theme.of(context).primaryColor)),
//           ),
//         ]),
//       ]),
//     );
//   }

//   Widget get _addnewTextFab => FloatingActionButton(
//         onPressed: () => addNewDialog(context),
//         backgroundColor: Colors.white,
//         tooltip: 'Add New Text',
//         child: const Icon(
//           Icons.edit,
//           color: Colors.black,
//         ),
//       );

//   Center artboardCanvas(BuildContext context) {
//     return Center(
//       child: Screenshot(
//         controller: screenshotController,
//         child: Container(
//           color: const Color.fromARGB(255, 255, 255, 255),
//           height: 620,
//           width: 375,
//           margin: const EdgeInsets.only(bottom: 65),
//           child: Stack(children: dataStack()),
//         ),
//       ),
//     );
//   }

//   saveToGallery(BuildContext context) {
//     screenshotController.capture().then((Uint8List? image) {
//       saveImage(image!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Berhasil disimpan!"),
//         ),
//       );
//       // ignore: invalid_return_type_for_catch_error,
//     }).catchError((err) => print(err));
//   }

//   saveImage(Uint8List bytes) async {
//     final time = DateTime.now()
//         .toIso8601String()
//         .replaceAll('.', '-')
//         .replaceAll(';', '-');
//     final name = "screenshot_$time";
//     await requestPermission(Permission.storage);
//     await ImageGallerySaver.saveImage(bytes, name: name);
//   }

//   Future<bool> requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }

//   Future _pickImageFromGallery1() async {
//     final returnedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (returnedImage == null) return;
//     setState(() {
//       _selectedImage = File(returnedImage.path);
//       globalListImage.add(StackImage(image: _selectedImage));

//       isFilePicked = true;
//     });
//   }
// }
