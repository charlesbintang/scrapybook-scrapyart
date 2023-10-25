// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrapyart_home/angel/default_button.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/my_artboard.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrapyart_home/angel/stack_object_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_cropper/image_cropper.dart';

enum ActionCallback {
  none,
  imageAdded,
  textAdded,
}

extension on List {
  void moveImage(StackObject element, int shift) {
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

abstract class ImageTextModel extends State<MyArtboard> {
  File? selectedImage;
  ScreenshotController screenshotController = ScreenshotController();
  CroppedFile? croppedFile;
  Offset tapPosition = Offset.zero;
  List<StackObject> globalListObject = [];
  int currentIndex = 0;
  double widthContainerRender = 0;
  double heightContainerRender = 0;
  double canvasWidth = 0.0;
  double canvasHeight = 0.0;
  final textController = TextEditingController(
      text:
          'FF000000'); // The initial value can be provided directly to the controller.

  void getTapPosition(TapDownDetails tapPostion) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      tapPosition = renderBox.globalToLocal(tapPostion.globalPosition);
    });
  }

  void getSizeOfTheBox(i) {
    final RenderBox box =
        GlobalObjectKey(i).currentContext!.findRenderObject() as RenderBox;
    widthContainerRender = box.size.width;
    heightContainerRender = box.size.height;
    setState(() {});
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Selected for Styling",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  List<Widget> buttonSimpanHapusImpor() {
    List<Widget> data = [];
    data.addAll([
      ElevatedButton(
        onPressed: () {
          pickImageFromGallery();
        },
        child: Text("Impor gambar ${globalListObject.length + 1}",
            style: TextStyle(color: Theme.of(context).primaryColor)),
      )
    ]);
    if (globalListObject.isNotEmpty) {
      data.addAll([
        ElevatedButton(
          onPressed: () => saveToGallery(context),
          child: Text("Simpan",
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
        ElevatedButton(
          onPressed: () {
            globalListObject.clear();
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
        globalListObject.moveImage(globalListObject[indexImage], 1);
      },
    );
    var down = PopupMenuItem(
      child: const Text("Bawa Mundur"),
      onTap: () {
        globalListObject.moveImage(globalListObject[indexImage], -1);
      },
    );
    var delete = PopupMenuItem(
      child: const Text("Hapus"),
      onTap: () {
        globalListObject.removeAt(indexImage);
      },
    );
    var reset = PopupMenuItem(
      child: const Text("Reset"),
      onTap: () {
        globalListObject[indexImage].croppedFile = null;
        globalListObject[indexImage].rotateValue = 0.0;
        globalListObject[indexImage].imageWidth = 200.0;
        globalListObject[indexImage].imageHeight = 200.0;
        globalListObject[indexImage].boxRoundValue = 15.0;
        globalListObject[indexImage].onClicked = OnAction.isFalse;
        globalListObject[indexImage].onScaling = OnAction.isFalse;
        globalListObject[indexImage].boxRound = OnAction.isFalse;
      },
    );

    // gambar pertama
    if (indexImage == 0 && indexImage + globalListObject.length == 1) {
      actions.add(delete);
      actions.add(reset);
    } else if (indexImage == 0 && indexImage + globalListObject.length > 1) {
      actions.add(up);
      actions.add(delete);
      actions.add(reset);
    } else if (indexImage == globalListObject.length - 1) {
      actions.add(down);
      actions.add(delete);
      actions.add(reset);
    } else {
      actions.add(up);
      actions.add(down);
      actions.add(delete);
      actions.add(reset);
    }

    await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 10, 10),
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

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage.path);
      globalListObject.add(
        StackObject(
          /// pickImageFromGallery harus menyertakan image didalamnya
          image: selectedImage,
        ),
      );
      isImageAdded = ActionCallback.imageAdded;
    });
  }

  Future<void> cropImage(StackObject imageOnCurrentIndex) async {
    if (imageOnCurrentIndex.image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageOnCurrentIndex.image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          imageOnCurrentIndex.croppedFile = croppedFile;
        });
      }
    }
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

  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();

  ActionCallback isTextAdded = ActionCallback.none;
  ActionCallback isImageAdded = ActionCallback.none;

  increaseFontSize() {
    setState(() {
      globalListObject[currentIndex].fontSize =
          globalListObject[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      globalListObject[currentIndex].fontSize =
          globalListObject[currentIndex].fontSize -= 2;
    });
  }

  boldText() {
    setState(() {
      if (globalListObject[currentIndex].fontWeight == FontWeight.bold) {
        globalListObject[currentIndex].fontWeight = FontWeight.normal;
      } else {
        globalListObject[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  underlineText() {
    setState(() {
      if (globalListObject[currentIndex].decoration ==
          TextDecoration.underline) {
        globalListObject[currentIndex].decoration = TextDecoration.none;
      } else {
        globalListObject[currentIndex].decoration = TextDecoration.underline;
      }
    });
  }

  italicText() {
    setState(() {
      if (globalListObject[currentIndex].fontStyle == FontStyle.italic) {
        globalListObject[currentIndex].fontStyle = FontStyle.normal;
      } else {
        globalListObject[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addNewsText(BuildContext context) {
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        globalListObject.add(
          StackObject(
            text: textEditingController.text,
          ),
        );
        isTextAdded = ActionCallback.textAdded;
      });
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Add New Text',
        ),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: 'Your Text Here..',
          ),
        ),
        actions: [
          DefaultButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.white,
              textcolor: Colors.black,
              child: const Text('Back')),
          DefaultButton(
              onPressed: () => addNewsText(context),
              color: const Color.fromARGB(255, 122, 74, 37),
              textcolor: Colors.white,
              child: const Text('Add Text'))
        ],
      ),
    );
  }

  deleteAllImage() {
    for (var i = 0; i < globalListObject.length; i++) {
      globalListObject[i].image = null;
    }
    globalListObject
        .removeWhere((element) => element.image == null && element.text == "");
    isImageAdded = ActionCallback.none;
    setState(() {});
  }

  void copyToClipboard(String input) {
    String textToCopy = input.replaceFirst('#', '').toUpperCase();
    if (textToCopy.startsWith('FF') && textToCopy.length == 8) {
      textToCopy = textToCopy.replaceFirst('FF', '');
    }
    Clipboard.setData(ClipboardData(text: '#$textToCopy'));
  }

  void changeColor(Color color) =>
      setState(() => globalListObject[currentIndex].color = color);
}
