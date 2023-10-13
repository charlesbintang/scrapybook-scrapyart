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
  Offset _tapPosition = Offset.zero;
  List<StackImage> globalListImage = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: jika diklik, tidak ada foto yang diborder
      onTapDown: (onTapDown) {
        setState(() {
          for (var i = 0; i < globalListImage.length; i++) {
            var imageOnCurentIndex = globalListImage[i];
            imageOnCurentIndex.click = OnTapWinner.none;
          }
        });
      },
      onTapCancel: () {},
      child: Scaffold(
        backgroundColor: const Color.fromARGB(218, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title:
              Text("MyArtboard", style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
        ),
        body: globalListImage.isNotEmpty
            ? artboardCanvas(context)
            : centerNoImage(context),
        floatingActionButton: floatingActionButton(),
      ),
    );
  }

  void _getTapPosition(TapDownDetails tapPostion) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPostion.globalPosition);
      print(_tapPosition);
    });
  }

  // buat kembalikan list widget yang akan di tumpuk
  List<Widget> dataStack() {
    List<Widget> data = [];
    for (var i = 0; i < globalListImage.length; i++) {
      var imageOnCurentIndex = globalListImage[i];
      data.add(
        Positioned(
          top: imageOnCurentIndex.top,
          left: imageOnCurentIndex.left,
          child: GestureDetector(
            onTapDown: (position) {
              _getTapPosition(position);
              print("index $i");
              print("index ${globalListImage.length}");
            },
            onTap: () {
              // imageOnCurentIndex.click = OnTapWinner.clicked;
              // setState(() {
              //   for (var i = 0; i < globalListImage.length; i++) {
              //     var imageOnCurentIndex = globalListImage[i];
              //     imageOnCurentIndex.click = OnTapWinner.none;
              //   }
              // });
              setState(() {
                for (var i = 0; i < globalListImage.length; i++) {
                  var imageOnCurentIndex = globalListImage[i];
                  imageOnCurentIndex.click = OnTapWinner.none;
                }
                imageOnCurentIndex.click = OnTapWinner.clicked;
              });
            },
            onLongPress: () {
              moveImage(i).then((value) {
                setState(() {});
              });
            },
            // onScaleUpdate: (details) {
            //   setState(() {
            //     imageOnCurentIndex.scale =
            //         imageOnCurentIndex.previousScale * details.scale;
            //   });
            // },
            // onScaleEnd: (details) {
            //   imageOnCurentIndex.previousScale = imageOnCurentIndex.scale;
            // },
            onPanUpdate: (details) {
              imageOnCurentIndex.top =
                  max(0, imageOnCurentIndex.top + details.delta.dy);
              imageOnCurentIndex.left =
                  max(0, imageOnCurentIndex.left + details.delta.dx);
              // imageOnCurentIndex.scale =
              // imageOnCurentIndex.previousScale * details.scale;
              setState(() {});
            },
            // child: Transform.scale(
            //   scale: imageOnCurentIndex.scale,
            child: Container(
              decoration: imageOnCurentIndex.click == OnTapWinner.clicked
                  ? BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 5))
                  : null,
              child: Image.file(
                imageOnCurentIndex.image!,
              ),
            ),
          ),
        ),
      );
    }
    return data;
  }

  List<Widget> buttonSimpanHapusImpor() {
    List<Widget> data = [];
    data.addAll([
      ElevatedButton(
        onPressed: () {
          _pickImageFromGallery();
        },
        child: Text("Impor gambar ${globalListImage.length + 1}",
            style: TextStyle(color: Theme.of(context).primaryColor)),
      )
    ]);
    if (globalListImage.isNotEmpty) {
      data.addAll([
        ElevatedButton(
          onPressed: () => saveToGallery(context),
          child: Text("Simpan",
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
        ElevatedButton(
          onPressed: () {
            globalListImage.clear();
            setState(() {});
          },
          child: Text("Hapus Semua Gambar",
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ]);
    }
    return data;
  }

  Future<void> moveImage(
    int indexImage,
  ) async {
    List<PopupMenuItem<dynamic>> actions = [];
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
    var delete = PopupMenuItem(
      child: const Text("Hapus"),
      onTap: () {
        globalListImage.removeAt(indexImage);
      },
    );

    // gambar pertama
    if (indexImage == 0) {
      actions.add(up);
      actions.add(delete);
    } else if (indexImage == globalListImage.length - 1) {
      actions.add(down);
      actions.add(delete);
    } else {
      actions.add(up);
      actions.add(down);
      actions.add(delete);
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

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
      globalListImage.add(StackImage(image: _selectedImage));
    });
  }

  Center artboardCanvas(BuildContext context) {
    return Center(
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          height: MediaQuery.of(context).size.height - 160, //620,
          width: MediaQuery.of(context).size.width - 20, //375,
          margin: const EdgeInsets.only(bottom: 55),
          child: Stack(children: dataStack()),
        ),
      ),
    );
  }

  Center centerNoImage(BuildContext context) {
    return Center(
        child: Text(
      "Tidak ada gambar, silakan impor sebuah gambar",
      style: Theme.of(context).textTheme.bodyMedium,
    ));
  }

  SizedBox floatingActionButton() {
    return SizedBox(
        height: 35,
        child: ListView.separated(
            padding: const EdgeInsets.only(left: 25),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => buttonSimpanHapusImpor()[index],
            separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
            itemCount: buttonSimpanHapusImpor().length));
  }

  ElevatedButton simpanHapus(BuildContext context) {
    return ElevatedButton(
      onPressed: () => saveToGallery(context),
      child: Text("Simpan",
          style: TextStyle(color: Theme.of(context).primaryColor)),
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
  // END OF METHOD EXTRACTED
}
