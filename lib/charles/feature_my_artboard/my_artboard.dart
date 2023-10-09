import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class MyArtboard extends StatefulWidget {
  const MyArtboard({Key? key}) : super(key: key);

  @override
  State<MyArtboard> createState() => _MyArtboardState();
}

class _MyArtboardState extends State<MyArtboard> {
  ScreenshotController screenshotController = ScreenshotController();

  // DONE: Buat 5 gambar yang bisa diimport.
  // TODO: Pindah layer dengan onLongPress.
  // TODO: scaling gambar dengan gesture detection.
  File? _selectedImage1;
  File? _selectedImage2;
  File? _selectedImage3;
  File? _selectedImage4;
  File? _selectedImage5;

  // for onPanUpdate function to 5 image
  double _top1 = 0;
  double _left1 = 0;
  double _top2 = 0;
  double _left2 = 0;
  double _top3 = 0;
  double _left3 = 0;
  double _top4 = 0;
  double _left4 = 0;
  double _top5 = 0;
  double _left5 = 0;

  // boolean
  bool isFilePicked = false;
  // A = layer1
  bool isImage1AVisible = true;
  bool isImage2AVisible = true;
  bool isImage3AVisible = true;
  bool isImage4AVisible = true;
  bool isImage5AVisible = true;
  // B = layer2
  bool isImage1BVisible = false;
  bool isImage2BVisible = false;
  bool isImage3BVisible = false;
  bool isImage4BVisible = false;
  bool isImage5BVisible = false;
  // C = layer3
  bool isImage1CVisible = false;
  bool isImage2CVisible = false;
  bool isImage3CVisible = false;
  bool isImage4CVisible = false;
  bool isImage5CVisible = false;
  // D = layer4
  bool isImage1DVisible = false;
  bool isImage2DVisible = false;
  bool isImage3DVisible = false;
  bool isImage4DVisible = false;
  bool isImage5DVisible = false;
  // E = layer5
  bool isImage1EVisible = false;
  bool isImage2EVisible = false;
  bool isImage3EVisible = false;
  bool isImage4EVisible = false;
  bool isImage5EVisible = false;

  // bool for visible button
  bool isImage2Existed = true;
  bool isImage3Existed = true;
  bool isImage4Existed = true;
  bool isImage5Existed = true;

  // start of pop up menu
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPostion) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPostion.globalPosition);
      print(_tapPosition);
    });
  }

  // void _showContextMenu(context) async {
  //   final RenderObject? overlay =
  //       Overlay.of(context).context.findRenderObject();
  //   // ignore: unused_local_variable
  //   final result = await showMenu(
  //       context: context,
  //       position: RelativeRect.fromRect(
  //         Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
  //         Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
  //             overlay.paintBounds.size.height),
  //       ),
  //       items: [
  //         PopupMenuItem(
  //           child: const Text("Bawa Maju"),
  //           onTap: () {
  //             setState(() {});
  //           },
  //         ),
  //         PopupMenuItem(
  //           child: const Text("Bawa Mundur"),
  //           onTap: () {
  //             setState(() {});
  //           },
  //         ),
  //       ]);
  // }

  void _showContextMenu1A(context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    // ignore: unused_local_variable
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: [
          PopupMenuItem(
            child: const Text("Bawa Maju"), //bawa maju ke 1B
            onTap: () {
              setState(() {
                isImage1AVisible = false;
                isImage2AVisible = true;
                isImage3AVisible = false;
                isImage4AVisible = false;
                isImage5AVisible = false;

                isImage1BVisible = true;
                isImage2BVisible = false;
                isImage3BVisible = true;
                isImage4BVisible = true;
                isImage5BVisible = true;
              });
            },
          ),
        ]);
  }

  void _showContextMenu1B(context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    // ignore: unused_local_variable
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: [
          PopupMenuItem(
            child: const Text("Bawa Maju"), //bawa maju ke 1C
            onTap: () {
              setState(() {
                isImage1AVisible = false;
                isImage2AVisible = false;
                isImage3AVisible = false;
                isImage4AVisible = false;
                isImage5AVisible = false;

                isImage1BVisible = false;
                isImage2BVisible = true;
                isImage3BVisible = true;
                isImage4BVisible = false;
                isImage5BVisible = false;

                isImage1CVisible = true;
                isImage2CVisible = false;
                isImage3CVisible = false;
                isImage4CVisible = true;
                isImage5CVisible = true;
              });
            },
          ),
          PopupMenuItem(
            child: const Text("Bawa Mundur"), //bawa mundur ke 1A
            onTap: () {
              setState(() {
                isImage1AVisible = true;
                isImage2AVisible = true;
                isImage3AVisible = true;
                isImage4AVisible = true;
                isImage5AVisible = true;

                isImage1BVisible = false;
                isImage2BVisible = false;
                isImage3BVisible = false;
                isImage4BVisible = false;
                isImage5BVisible = false;
              });
            },
          ),
        ]);
  }

  void _showContextMenu1C(context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    // ignore: unused_local_variable
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: [
          PopupMenuItem(
            child: const Text("Bawa Maju"), //bawa maju ke 1D
            onTap: () {
              setState(() {
                isImage1AVisible = false;
                isImage2AVisible = false;
                isImage3AVisible = false;
                isImage4AVisible = false;
                isImage5AVisible = false;

                isImage1BVisible = false;
                isImage2BVisible = false;
                isImage3BVisible = false;
                isImage4BVisible = false;
                isImage5BVisible = false;

                isImage1CVisible = false;
                isImage2CVisible = true;
                isImage3CVisible = true;
                isImage4CVisible = true;
                isImage5CVisible = false;

                isImage1DVisible = true;
                isImage2DVisible = false;
                isImage3DVisible = false;
                isImage4DVisible = false;
                isImage5DVisible = true;

                isImage1EVisible = false;
                isImage2EVisible = false;
                isImage3EVisible = false;
                isImage4EVisible = false;
                isImage5EVisible = false;
              });
            },
          ),
          PopupMenuItem(
            child: const Text("Bawa Mundur"), //bawa mundur ke 1B
            onTap: () {
              setState(() {
                isImage1AVisible = false;
                isImage2AVisible = true;
                isImage3AVisible = false;
                isImage4AVisible = false;
                isImage5AVisible = false;

                isImage1BVisible = true;
                isImage2BVisible = false;
                isImage3BVisible = true;
                isImage4BVisible = true;
                isImage5BVisible = true;

                isImage1CVisible = false;
                isImage2CVisible = false;
                isImage3CVisible = false;
                isImage4CVisible = false;
                isImage5CVisible = false;
              });
            },
          ),
        ]);
  }

  void _showContextMenu1D(context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    // ignore: unused_local_variable
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: [
          PopupMenuItem(
            child: const Text("Bawa Maju"), //bawa maju ke 1E
            onTap: () {
              setState(() {
                isImage1AVisible = false;
                isImage2AVisible = false;
                isImage3AVisible = false;
                isImage4AVisible = false;
                isImage5AVisible = false;

                isImage1BVisible = false;
                isImage2BVisible = false;
                isImage3BVisible = false;
                isImage4BVisible = false;
                isImage5BVisible = false;

                isImage1CVisible = false;
                isImage2CVisible = false;
                isImage3CVisible = false;
                isImage4CVisible = false;
                isImage5CVisible = false;

                isImage1DVisible = false;
                isImage2DVisible = true;
                isImage3DVisible = true;
                isImage4DVisible = true;
                isImage5DVisible = true;

                isImage1EVisible = true;
                isImage2EVisible = false;
                isImage3EVisible = false;
                isImage4EVisible = false;
                isImage5EVisible = false;
              });
            },
          ),
          PopupMenuItem(
            child: const Text("Bawa Mundur"), //bawa mundur ke 1C
            onTap: () {
              setState(() {
                isImage1AVisible = false;
                isImage2AVisible = false;
                isImage3AVisible = false;
                isImage4AVisible = false;
                isImage5AVisible = false;

                isImage1BVisible = false;
                isImage2BVisible = true;
                isImage3BVisible = true;
                isImage4BVisible = false;
                isImage5BVisible = false;

                isImage1CVisible = true;
                isImage2CVisible = false;
                isImage3CVisible = false;
                isImage4CVisible = true;
                isImage5CVisible = true;

                isImage1DVisible = false;
                isImage2DVisible = false;
                isImage3DVisible = false;
                isImage4DVisible = false;
                isImage5DVisible = false;
              });
            },
          ),
        ]);
  }

  void _showContextMenu1E(context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    // ignore: unused_local_variable
    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: [
          PopupMenuItem(
            child: const Text("Bawa Mundur"), //bawa mundur ke 1D
            onTap: () {
              setState(() {
                isImage1CVisible = false;
                isImage2CVisible = true;
                isImage3CVisible = true;
                isImage4CVisible = true;
                isImage5CVisible = false;

                isImage1DVisible = true;
                isImage2DVisible = false;
                isImage3DVisible = false;
                isImage4DVisible = false;
                isImage5DVisible = true;

                isImage1EVisible = false;
                isImage2EVisible = false;
                isImage3EVisible = false;
                isImage4EVisible = false;
                isImage5EVisible = false;
              });
            },
          ),
        ]);
  }
  // end of pop up menu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(218, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title:
            Text("MyArtboard", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: isFilePicked == true
          ? artboardCanvas(context)
          : Center(
              child: Text(
              "Tidak ada gambar, silakan impor sebuah gambar",
              style: Theme.of(context).textTheme.bodyMedium,
            )),
      floatingActionButton: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_selectedImage1 == null)
              ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery1();
                },
                child: Text("Impor gambar 1",
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
            if (_selectedImage1 != null)
              ElevatedButton(
                onPressed: () => saveToGallery(context),
                child: Text("Simpan",
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
            if (_selectedImage1 != null)
              Container(
                margin: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFilePicked = false;

                      _selectedImage1 = null;
                      _selectedImage2 = null;
                      _selectedImage3 = null;
                      _selectedImage4 = null;
                      _selectedImage5 = null;

                      _top1 = 0;
                      _left1 = 0;
                      _top2 = 0;
                      _left2 = 0;
                      _top3 = 0;
                      _left3 = 0;
                      _top4 = 0;
                      _left4 = 0;
                      _top5 = 0;
                      _left5 = 0;

                      // isImage2Existed = !isImage2Existed;
                      // isImage3Existed = !isImage3Existed;
                      // isImage4Existed = !isImage4Existed;
                      // isImage5Existed = !isImage5Existed;

                      isImage2Existed = true;
                      isImage3Existed = true;
                      isImage4Existed = true;
                      isImage5Existed = true;

                      // A = layer1
                      isImage1AVisible = true;
                      isImage2AVisible = true;
                      isImage3AVisible = true;
                      isImage4AVisible = true;
                      isImage5AVisible = true;
                      // B = layer2
                      isImage1BVisible = false;
                      isImage2BVisible = false;
                      isImage3BVisible = false;
                      isImage4BVisible = false;
                      isImage5BVisible = false;
                      // C = layer3
                      isImage1CVisible = false;
                      isImage2CVisible = false;
                      isImage3CVisible = false;
                      isImage4CVisible = false;
                      isImage5CVisible = false;
                      // D = layer4
                      isImage1DVisible = false;
                      isImage2DVisible = false;
                      isImage3DVisible = false;
                      isImage4DVisible = false;
                      isImage5DVisible = false;
                      // E = layer5
                      isImage1EVisible = false;
                      isImage2EVisible = false;
                      isImage3EVisible = false;
                      isImage4EVisible = false;
                      isImage5EVisible = false;
                    });
                  },
                  child: Text("Hapus",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            if (_selectedImage1 != null)
              Visibility(
                visible: isImage2Existed,
                child: ElevatedButton(
                  onPressed: () {
                    _pickImageFromGallery2();
                    setState(() {
                      isImage2Existed = false;
                    });
                  },
                  child: Text("Impor gambar 2",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            if (_selectedImage2 != null)
              Visibility(
                visible: isImage3Existed,
                child: ElevatedButton(
                  onPressed: () {
                    _pickImageFromGallery3();
                    setState(() {
                      isImage3Existed = false;
                    });
                  },
                  child: Text("Impor gambar 3",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            if (_selectedImage3 != null)
              Visibility(
                visible: isImage4Existed,
                child: ElevatedButton(
                  onPressed: () {
                    _pickImageFromGallery4();
                    setState(() {
                      isImage4Existed = false;
                    });
                  },
                  child: Text("Impor gambar 4",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            if (_selectedImage4 != null)
              Visibility(
                visible: isImage5Existed,
                child: ElevatedButton(
                  onPressed: () {
                    _pickImageFromGallery5();
                    setState(() {
                      isImage5Existed = false;
                    });
                  },
                  child: Text("Impor gambar 5",
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
          ],
        ),
      ]),
    );
  }

  Center artboardCanvas(BuildContext context) {
    return Center(
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          height: 620,
          width: 375,
          margin: const EdgeInsets.only(bottom: 65),
          child: Stack(
            children: [
              // gambar 1,2,3,4, dan 5 A.
              Visibility(
                visible: isImage1AVisible, //isImage1AVisible,
                replacement: const SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                ),
                child: Positioned(
                  top: _top1, //_top1,
                  left: _left1, //_left1,
                  child: GestureDetector(
                    onTapDown: (position) {
                      _getTapPosition(position);
                      print("ini imageDanLayer1");
                    },
                    onLongPress: () {
                      _showContextMenu1A(context);
                    },
                    onPanUpdate: (details) {
                      _top1 = max(0, _top1 + details.delta.dy);
                      _left1 = max(0, _left1 + details.delta.dx);
                      setState(() {});
                    },
                    child: Image.file(_selectedImage1!),
                  ),
                ),
              ),
              if (_selectedImage2 != null)
                Positioned(
                  top: _top2,
                  left: _left2,
                  child: GestureDetector(
                    onTapDown: (position) {
                      _getTapPosition(position);
                    },
                    onLongPress: () {
                      //_showContextMenu(context);
                    },
                    onPanUpdate: (details) {
                      _top2 = max(0, _top2 + details.delta.dy);
                      _left2 = max(0, _left2 + details.delta.dx);
                      setState(() {});
                    },
                    child: Image.file(_selectedImage2!),
                  ),
                ),
              if (_selectedImage3 != null)
                Visibility(
                  visible: isImage3AVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top3,
                    left: _left3,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                      },
                      onLongPress: () {
                        //_showContextMenu(context);
                      },
                      onPanUpdate: (details) {
                        _top3 = max(0, _top3 + details.delta.dy);
                        _left3 = max(0, _left3 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage3!),
                    ),
                  ),
                ),
              if (_selectedImage4 != null)
                Visibility(
                  visible: isImage4AVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top4,
                    left: _left4,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                      },
                      onLongPress: () {
                        //_showContextMenu(context);
                      },
                      onPanUpdate: (details) {
                        _top4 = max(0, _top4 + details.delta.dy);
                        _left4 = max(0, _left4 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage4!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage5AVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top5,
                    left: _left5,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                      },
                      onLongPress: () {
                        //_showContextMenu(context);
                      },
                      onPanUpdate: (details) {
                        _top5 = max(0, _top5 + details.delta.dy);
                        _left5 = max(0, _left5 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage5!),
                    ),
                  ),
                ),
              // gambar 1,2,3,4, dan 5 B.
              if (_selectedImage2 != null)
                Visibility(
                  visible: isImage1BVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top1,
                    left: _left1,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                        print("ini imageDanLayer2");
                      },
                      onLongPress: () {
                        _showContextMenu1B(context);
                      },
                      onPanUpdate: (details) {
                        _top1 = max(0, _top1 + details.delta.dy);
                        _left1 = max(0, _left1 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage1!),
                    ),
                  ),
                ),
              if (_selectedImage2 != null)
                Visibility(
                  visible: isImage2BVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top2,
                    left: _left2,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top2 = max(0, _top2 + details.delta.dy);
                        _left2 = max(0, _left2 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage2!),
                    ),
                  ),
                ),
              if (_selectedImage3 != null)
                Visibility(
                  visible: isImage3BVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top3,
                    left: _left3,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top3 = max(0, _top3 + details.delta.dy);
                        _left3 = max(0, _left3 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage3!),
                    ),
                  ),
                ),
              if (_selectedImage4 != null)
                Visibility(
                  visible: isImage4BVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top4,
                    left: _left4,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top4 = max(0, _top4 + details.delta.dy);
                        _left4 = max(0, _left4 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage4!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage5BVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top5,
                    left: _left5,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top5 = max(0, _top5 + details.delta.dy);
                        _left5 = max(0, _left5 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage5!),
                    ),
                  ),
                ),
              // gambar 1,2,3,4, dan 5 C.
              if (_selectedImage3 != null)
                Visibility(
                  visible: isImage1CVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top1,
                    left: _left1,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                        print("ini imageDanLayer3");
                      },
                      onLongPress: () {
                        _showContextMenu1C(context);
                      },
                      onPanUpdate: (details) {
                        _top1 = max(0, _top1 + details.delta.dy);
                        _left1 = max(0, _left1 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage1!),
                    ),
                  ),
                ),
              if (_selectedImage3 != null)
                Visibility(
                  visible: isImage2CVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top2,
                    left: _left2,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top2 = max(0, _top2 + details.delta.dy);
                        _left2 = max(0, _left2 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage2!),
                    ),
                  ),
                ),
              if (_selectedImage3 != null)
                Visibility(
                  visible: isImage3CVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top3,
                    left: _left3,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top3 = max(0, _top3 + details.delta.dy);
                        _left3 = max(0, _left3 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage3!),
                    ),
                  ),
                ),
              if (_selectedImage4 != null)
                Visibility(
                  visible: isImage4CVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top4,
                    left: _left4,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top4 = max(0, _top4 + details.delta.dy);
                        _left4 = max(0, _left4 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage4!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage5CVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top5,
                    left: _left5,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top5 = max(0, _top5 + details.delta.dy);
                        _left5 = max(0, _left5 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage5!),
                    ),
                  ),
                ),
              // gambar 1,2,3,4, dan 5 D.
              if (_selectedImage4 != null)
                Visibility(
                  visible: isImage1DVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top1,
                    left: _left1,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                        print("ini imageDanLayer4");
                      },
                      onLongPress: () {
                        _showContextMenu1D(context);
                      },
                      onPanUpdate: (details) {
                        _top1 = max(0, _top1 + details.delta.dy);
                        _left1 = max(0, _left1 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage1!),
                    ),
                  ),
                ),
              if (_selectedImage4 != null)
                Visibility(
                  visible: isImage2DVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top2,
                    left: _left2,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top2 = max(0, _top2 + details.delta.dy);
                        _left2 = max(0, _left2 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage2!),
                    ),
                  ),
                ),
              if (_selectedImage4 != null)
                Visibility(
                  visible: isImage3DVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top3,
                    left: _left3,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top3 = max(0, _top3 + details.delta.dy);
                        _left3 = max(0, _left3 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage3!),
                    ),
                  ),
                ),
              if (_selectedImage4 != null)
                Visibility(
                  visible: isImage4DVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top4,
                    left: _left4,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top4 = max(0, _top4 + details.delta.dy);
                        _left4 = max(0, _left4 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage4!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage5DVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top5,
                    left: _left5,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top5 = max(0, _top5 + details.delta.dy);
                        _left5 = max(0, _left5 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage5!),
                    ),
                  ),
                ),
              // gambar 1,2,3,4, dan 5 E.
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage1EVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top1,
                    left: _left1,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                        print("ini imageDanLayer4");
                      },
                      onLongPress: () {
                        _showContextMenu1E(context);
                      },
                      onPanUpdate: (details) {
                        _top1 = max(0, _top1 + details.delta.dy);
                        _left1 = max(0, _left1 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage1!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage2EVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top2,
                    left: _left2,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top2 = max(0, _top2 + details.delta.dy);
                        _left2 = max(0, _left2 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage2!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage3EVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top3,
                    left: _left3,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top3 = max(0, _top3 + details.delta.dy);
                        _left3 = max(0, _left3 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage3!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage4EVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top4,
                    left: _left4,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        _top4 = max(0, _top4 + details.delta.dy);
                        _left4 = max(0, _left4 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage4!),
                    ),
                  ),
                ),
              if (_selectedImage5 != null)
                Visibility(
                  visible: isImage5EVisible,
                  replacement: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  child: Positioned(
                    top: _top5,
                    left: _left5,
                    child: GestureDetector(
                      onTapDown: (position) {
                        _getTapPosition(position);
                      },
                      onLongPress: () {
                        //_showContextMenu(context);
                      },
                      onPanUpdate: (details) {
                        _top5 = max(0, _top5 + details.delta.dy);
                        _left5 = max(0, _left5 + details.delta.dx);
                        setState(() {});
                      },
                      child: Image.file(_selectedImage5!),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  saveToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) {
      saveImage(image!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil disimpan!"),
        ),
      );
      // ignore: invalid_return_type_for_catch_error, avoid_print
    }).catchError((err) => print(err));
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(';', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future _pickImageFromGallery1() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage1 = File(returnedImage.path);
      isFilePicked = true;
    });
  }

  Future _pickImageFromGallery2() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage2 = File(returnedImage.path);
    });
  }

  Future _pickImageFromGallery3() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage3 = File(returnedImage.path);
    });
  }

  Future _pickImageFromGallery4() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage4 = File(returnedImage.path);
    });
  }

  Future _pickImageFromGallery5() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage5 = File(returnedImage.path);
    });
  }
}
