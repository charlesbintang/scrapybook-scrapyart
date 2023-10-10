// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrapyart_home/charles/feature_my_artboard/stack_image_model.dart';
import 'package:screenshot/screenshot.dart';

extension on List {
  void moveImage(StackImage element, int shift) {
    if (contains(element)) {
      final curPos = indexOf(element);
      final newPos = curPos + shift;
      if (newPos >= 0 && newPos < length) {
        removeAt(curPos);
        insert(newPos, element);
      }
    }
  }
}

class MyArtboard extends StatefulWidget {
  const MyArtboard({Key? key}) : super(key: key);

  @override
  State<MyArtboard> createState() => _MyArtboardState();
}

class _MyArtboardState extends State<MyArtboard> {
  ScreenshotController screenshotController = ScreenshotController();

  File? _selectedImage;

  bool isFilePicked = false;

  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails tapPostion) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPostion.globalPosition);
      print(_tapPosition);
    });
  }

  List<StackImage> globalListImage = [];

  // buat kembalikan list widget yang akan di tumpuk
  List<Widget> dataStack() {
    List<Widget> data = [];
    for (var i = 0; i < globalListImage.length; i++) {
      var imageOnCurentIndex = globalListImage[i];
      data.add(Positioned(
        top: imageOnCurentIndex.top,
        left: imageOnCurentIndex.left,
        child: GestureDetector(
          onTapDown: (position) {
            _getTapPosition(position);
            print("index $i");
          },
          onLongPress: () {
            moveImage(i).then((value) {
              setState(() {});
            });
          },
          onPanUpdate: (details) {
            imageOnCurentIndex.top =
                max(0, imageOnCurentIndex.top + details.delta.dy);
            imageOnCurentIndex.left =
                max(0, imageOnCurentIndex.left + details.delta.dx);
            setState(() {});
          },
          child: Image.file(imageOnCurentIndex.image!),
        ),
      ));
    }
    return data;
  }

  Future<void> moveImage(
    int indexImage,
  ) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    var up = PopupMenuItem(
      child: const Text("Bawa Maju"),
      onTap: () {
        globalListImage.moveImage(globalListImage[indexImage], 1);
      },
    );

    var down = PopupMenuItem(
      child: const Text("Bawa Mundur"),
      onTap: () {
        globalListImage.moveImage(globalListImage[indexImage], -1);
      },
    );

    List<PopupMenuItem<dynamic>> actions = [];

    // gambar pertama
    if (indexImage == 0) {
      actions.add(up);
    } else if (indexImage == globalListImage.length - 1) {
      actions.add(down);
    } else {
      actions.add(up);
      actions.add(down);
    }

    await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height),
        ),
        items: actions);
  }

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
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (globalListImage.isNotEmpty)
            ElevatedButton(
              onPressed: () => saveToGallery(context),
              child: Text("Simpan",
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              _pickImageFromGallery1();
            },
            child: Text("Impor gambar ${globalListImage.length + 1}",
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ]),
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
          child: Stack(children: dataStack()),
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
      // ignore: invalid_return_type_for_catch_error,
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
      _selectedImage = File(returnedImage.path);
      globalListImage.add(StackImage(image: _selectedImage));

      isFilePicked = true;
    });
  }
}
