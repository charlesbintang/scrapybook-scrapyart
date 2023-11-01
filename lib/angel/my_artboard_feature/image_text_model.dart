// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:scrapyart_home/angel/my_artboard_feature/drawing_point.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/image_text_charles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/default_button.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/my_artboard.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/stack_object_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_cropper/image_cropper.dart';

enum ActionCallback {
  none,
  imageAdded,
  textAdded,
  isButtonClicked,
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
  TextEditingController newTextController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textColorController = TextEditingController(
      text:
          'FF000000'); // The initial value can be provided directly to the controller.
  CroppedFile? croppedFile;
  Offset tapPosition = Offset.zero;
  List<StackObject> globalListObject = [];
  int currentIndex = 0;
  double widthContainerRender = 0;
  double heightContainerRender = 0;
  double canvasWidth = 0.0;
  double canvasHeight = 0.0;
  ActionCallback isButtonClicked = ActionCallback.none;
  ActionCallback isButtonBrushClicked = ActionCallback.none;
  ActionCallback isTextAdded = ActionCallback.none;
  ActionCallback isImageAdded = ActionCallback.none;
  String menu = "images";
  List<String> assetFiles = [];
  List<DrawingPoint> drawingPoint = [];

  @override
  void initState() {
    super.initState();
    getAssetFiles();
  }

  Future<void> getAssetFiles() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final assetPaths = manifestMap.keys
        .where((String key) => key.startsWith('lib/angel/artboard_assets/'))
        .toList();

    assetFiles = List<String>.from(assetPaths);

    setState(() {});
  }

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
      isButtonClicked = ActionCallback.isButtonClicked;
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
        if (indexImage == 0 && indexImage + globalListObject.length == 1) {
          isTextAdded = ActionCallback.none;
          isImageAdded = ActionCallback.none;
          isButtonClicked = ActionCallback.none;
        }
        if (globalListObject[indexImage].text.isNotEmpty) {
          isButtonClicked = ActionCallback.none;
          Future.delayed(Durations.short1, () {
            globalListObject.removeAt(indexImage);
            setState(() {});
          });
        }
        if (globalListObject[indexImage].image != null ||
            globalListObject[indexImage].assetImage.isNotEmpty) {
          isButtonClicked = ActionCallback.none;
          Future.delayed(Durations.short1, () {
            globalListObject.removeAt(indexImage);
            setState(() {});
          });
        }
      },
    );
    var reset = PopupMenuItem(
      child: const Text("Reset"),
      onTap: () {
        if (globalListObject[indexImage].image != null) {
          globalListObject[indexImage].croppedFile = null;
          globalListObject[indexImage].rotateValue = 0.0;
          globalListObject[indexImage].imageWidth = 200.0;
          globalListObject[indexImage].imageHeight = 200.0;
          globalListObject[indexImage].boxRoundValue = 15.0;
          globalListObject[indexImage].onClicked = OnAction.isFalse;
          globalListObject[indexImage].onScaling = OnAction.isFalse;
          globalListObject[indexImage].boxRound = OnAction.isFalse;
        } else if (globalListObject[indexImage].text.isNotEmpty) {
          globalListObject[indexImage].color = Colors.black;
          globalListObject[indexImage].fontWeight = FontWeight.normal;
          globalListObject[indexImage].fontStyle = FontStyle.normal;
          globalListObject[indexImage].fontSize = 20;
          globalListObject[indexImage].decoration = TextDecoration.none;
        }
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
    if (imageOnCurrentIndex.image != null ||
        imageOnCurrentIndex.assetImage.isNotEmpty) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageOnCurrentIndex.image != null
            ? imageOnCurrentIndex.image!.path
            : imageOnCurrentIndex.assetImage,
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
    if (newTextController.text.isNotEmpty) {
      setState(() {
        globalListObject.add(
          StackObject(
            text: newTextController.text,
          ),
        );
        newTextController.text = "";
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
          controller: newTextController,
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

  Future<dynamic> editText(int i) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Edit Text',
        ),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: InputDecoration(
            suffixIcon: const Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: globalListObject[i].text,
          ),
        ),
        actions: [
          DefaultButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.white,
              textcolor: Colors.black,
              child: const Text('Back')),
          DefaultButton(
              onPressed: () {
                setState(() {
                  globalListObject[i].text = textEditingController.text;
                });
                Navigator.of(context).pop();
              },
              color: const Color.fromARGB(255, 122, 74, 37),
              textcolor: Colors.white,
              child: const Text('Save'))
        ],
      ),
    );
  }

  deleteAllImages() {
    for (var i = 0; i < globalListObject.length; i++) {
      globalListObject[i].image = null;
    }
    globalListObject
        .removeWhere((element) => element.image == null && element.text == "");
    isImageAdded = ActionCallback.none;
    setState(() {});
  }

  deleteAllTexts() {
    globalListObject.removeWhere((element) => element.text.isNotEmpty);
    isTextAdded = ActionCallback.none;
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

  bool isObjectAdded() {
    if (globalListObject.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  List<Widget> dataStack() {
    List<Widget> data = [];
    for (var i = 0; i < globalListObject.length; i++) {
      // images
      if (globalListObject[i].image != null) {
        var imageOnCurentIndex = globalListObject[i];
        data.addAll([
          Positioned(
            top: imageOnCurentIndex.top,
            left: imageOnCurentIndex.left,
            child: GestureDetector(
              onPanUpdate: imageOnCurentIndex.onClicked == OnAction.isFalse
                  ? (details) {
                      imageOnCurentIndex.top =
                          imageOnCurentIndex.top + details.delta.dy;
                      imageOnCurentIndex.left =
                          imageOnCurentIndex.left + details.delta.dx;
                      setState(() {});
                    }
                  : null,
              child: Container(
                key: GlobalObjectKey(i),
                width: imageOnCurentIndex.imageWidth,
                height: imageOnCurentIndex.imageHeight,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                    imageOnCurentIndex.rotateValue / 180 * pi),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: imageOnCurentIndex.imageWidth - 20,
                        height: imageOnCurentIndex.imageHeight - 20,
                        decoration: BoxDecoration(
                          borderRadius:
                              imageOnCurentIndex.boxRound == OnAction.isRounded
                                  ? BorderRadius.circular(
                                      imageOnCurentIndex.boxRoundValue)
                                  : null,
                          image: DecorationImage(
                              image: imageOnCurentIndex.croppedFile == null
                                  ? FileImage(imageOnCurentIndex.image!)
                                  : FileImage(File(
                                      imageOnCurentIndex.croppedFile!.path)),
                              fit: BoxFit.fill),
                          border: imageOnCurentIndex.onClicked ==
                                  OnAction.isClicked
                              ? Border.all(color: Colors.blueAccent, width: 2)
                              : null,
                        ),
                        child: GestureDetector(
                          onTapDown: (position) {
                            getTapPosition(position);
                            getSizeOfTheBox(i);
                          },
                          onTap: () {
                            if (imageOnCurentIndex.onClicked ==
                                OnAction.isFalse) {
                              setState(() {
                                for (var i = 0;
                                    i < globalListObject.length;
                                    i++) {
                                  var imageOnCurentIndex = globalListObject[i];
                                  imageOnCurentIndex.onClicked =
                                      OnAction.isFalse;
                                }
                                imageOnCurentIndex.onClicked =
                                    OnAction.isClicked;
                              });
                            } else if (imageOnCurentIndex.onClicked ==
                                OnAction.isClicked) {
                              imageOnCurentIndex.onClicked = OnAction.isFalse;
                            }
                          },
                          onLongPress: () {
                            moveImage(i).then((value) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                    ),
                    // tombol resize image
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width: imageOnCurentIndex.imageWidth - 20,
                        height: imageOnCurentIndex.imageHeight - 20,
                        child: Column(
                          children: [
                            const Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(child: SizedBox()),
                                imageOnCurentIndex.onClicked ==
                                        OnAction.isClicked
                                    ? GestureDetector(
                                        onPanUpdate: (details) {
                                          getSizeOfTheBox(i);

                                          imageOnCurentIndex.imageHeight = max(
                                              70,
                                              imageOnCurentIndex.imageHeight +
                                                  details.delta.dy);
                                          imageOnCurentIndex.imageWidth = max(
                                              90,
                                              imageOnCurentIndex.imageWidth +
                                                  details.delta.dx);
                                          setState(() {});
                                        },
                                        child: const Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Icon(
                                              Icons.circle,
                                              color: Colors.blueAccent,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // tombol scaling image
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: imageOnCurentIndex.onClicked == OnAction.isClicked
                          ? GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                imageOnCurentIndex.imageWidth = max(
                                    90,
                                    imageOnCurentIndex.imageWidth +
                                        details.delta.dx);
                                imageOnCurentIndex.imageHeight = max(
                                    70,
                                    imageOnCurentIndex.imageHeight +
                                        details.delta.dx);
                                getSizeOfTheBox(i);
                                setState(() {});
                              },
                              onVerticalDragUpdate: (details) {
                                imageOnCurentIndex.imageWidth = max(
                                    90,
                                    imageOnCurentIndex.imageWidth +
                                        details.delta.dy);
                                imageOnCurentIndex.imageHeight = max(
                                    70,
                                    imageOnCurentIndex.imageHeight +
                                        details.delta.dy);
                                getSizeOfTheBox(i);
                                setState(() {});
                              },
                              child: Transform.rotate(
                                angle: 45 / 180 * pi,
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // tombol untuk crop, rotate, dan border image
          Positioned(
            top: imageOnCurentIndex.top,
            left: imageOnCurentIndex.left,
            width: widthContainerRender + 1,
            height: heightContainerRender * 235 / 100,
            child: imageOnCurentIndex.onClicked == OnAction.isClicked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () {
                          imageOnCurentIndex.onClicked = OnAction.isFalse;
                          cropImage(imageOnCurentIndex);
                        },
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.crop_rounded,
                              color: Colors.blueAccent,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            imageOnCurentIndex.rotateValue -= details.delta.dx;
                            imageOnCurentIndex.rotateValue %= 360;
                            setState(() {});
                          },
                          onVerticalDragUpdate: (details) {
                            imageOnCurentIndex.rotateValue -= details.delta.dy;
                            imageOnCurentIndex.rotateValue %= 360;
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.autorenew,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (imageOnCurentIndex.boxRound ==
                              OnAction.isRounded) {
                            imageOnCurentIndex.boxRoundValue = 15.0;
                            imageOnCurentIndex.boxRound = OnAction.isFalse;
                          } else {
                            imageOnCurentIndex.boxRoundValue = 15.0;
                            imageOnCurentIndex.boxRound = OnAction.isRounded;
                          }
                          setState(() {});
                        },
                        onHorizontalDragUpdate: (details) {
                          imageOnCurentIndex.boxRoundValue = max(
                              10,
                              imageOnCurentIndex.boxRoundValue +
                                  details.delta.dx);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.border_all_rounded,
                          color: Colors.blueAccent,
                          size: 25,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  )
                : const SizedBox(),
          ),
        ]);
      }
      // asset images
      if (globalListObject[i].assetImage.isNotEmpty) {
        var imageOnCurentIndex = globalListObject[i];
        data.addAll([
          Positioned(
            top: imageOnCurentIndex.top,
            left: imageOnCurentIndex.left,
            child: GestureDetector(
              onPanUpdate: imageOnCurentIndex.onClicked == OnAction.isFalse
                  ? (details) {
                      imageOnCurentIndex.top =
                          imageOnCurentIndex.top + details.delta.dy;
                      imageOnCurentIndex.left =
                          imageOnCurentIndex.left + details.delta.dx;
                      setState(() {});
                    }
                  : null,
              child: Container(
                key: GlobalObjectKey(i),
                width: imageOnCurentIndex.imageWidth,
                height: imageOnCurentIndex.imageHeight,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                    imageOnCurentIndex.rotateValue / 180 * pi),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: imageOnCurentIndex.imageWidth - 20,
                        height: imageOnCurentIndex.imageHeight - 20,
                        decoration: BoxDecoration(
                          borderRadius:
                              imageOnCurentIndex.boxRound == OnAction.isRounded
                                  ? BorderRadius.circular(
                                      imageOnCurentIndex.boxRoundValue)
                                  : null,
                          image: imageOnCurentIndex.croppedFile == null
                              ? DecorationImage(
                                  image:
                                      AssetImage(imageOnCurentIndex.assetImage),
                                  fit: BoxFit.fill)
                              : DecorationImage(
                                  image: FileImage(
                                    File(imageOnCurentIndex.croppedFile!.path),
                                  ),
                                ),
                          border: imageOnCurentIndex.onClicked ==
                                  OnAction.isClicked
                              ? Border.all(color: Colors.blueAccent, width: 2)
                              : null,
                        ),
                        child: GestureDetector(
                          onTapDown: (position) {
                            getTapPosition(position);
                            getSizeOfTheBox(i);
                          },
                          onTap: () {
                            if (imageOnCurentIndex.onClicked ==
                                OnAction.isFalse) {
                              setState(() {
                                for (var i = 0;
                                    i < globalListObject.length;
                                    i++) {
                                  var imageOnCurentIndex = globalListObject[i];
                                  imageOnCurentIndex.onClicked =
                                      OnAction.isFalse;
                                }
                                imageOnCurentIndex.onClicked =
                                    OnAction.isClicked;
                              });
                            } else if (imageOnCurentIndex.onClicked ==
                                OnAction.isClicked) {
                              imageOnCurentIndex.onClicked = OnAction.isFalse;
                            }
                          },
                          onLongPress: () {
                            moveImage(i).then((value) {
                              setState(() {});
                            });
                          },
                        ),
                      ),
                    ),
                    // tombol resize image
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width: imageOnCurentIndex.imageWidth - 20,
                        height: imageOnCurentIndex.imageHeight - 20,
                        child: Column(
                          children: [
                            const Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(child: SizedBox()),
                                imageOnCurentIndex.onClicked ==
                                        OnAction.isClicked
                                    ? GestureDetector(
                                        onPanUpdate: (details) {
                                          getSizeOfTheBox(i);

                                          imageOnCurentIndex.imageHeight = max(
                                              70,
                                              imageOnCurentIndex.imageHeight +
                                                  details.delta.dy);
                                          imageOnCurentIndex.imageWidth = max(
                                              90,
                                              imageOnCurentIndex.imageWidth +
                                                  details.delta.dx);
                                          setState(() {});
                                        },
                                        child: const Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Icon(
                                              Icons.circle,
                                              color: Colors.blueAccent,
                                              size: 15,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // tombol scaling image
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: imageOnCurentIndex.onClicked == OnAction.isClicked
                          ? GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                imageOnCurentIndex.imageWidth = max(
                                    90,
                                    imageOnCurentIndex.imageWidth +
                                        details.delta.dx);
                                imageOnCurentIndex.imageHeight = max(
                                    70,
                                    imageOnCurentIndex.imageHeight +
                                        details.delta.dx);
                                getSizeOfTheBox(i);
                                setState(() {});
                              },
                              onVerticalDragUpdate: (details) {
                                imageOnCurentIndex.imageWidth = max(
                                    90,
                                    imageOnCurentIndex.imageWidth +
                                        details.delta.dy);
                                imageOnCurentIndex.imageHeight = max(
                                    70,
                                    imageOnCurentIndex.imageHeight +
                                        details.delta.dy);
                                getSizeOfTheBox(i);
                                setState(() {});
                              },
                              child: Transform.rotate(
                                angle: 45 / 180 * pi,
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // tombol untuk crop, rotate, dan border image
          Positioned(
            top: imageOnCurentIndex.top,
            left: imageOnCurentIndex.left,
            width: widthContainerRender + 1,
            height: heightContainerRender * 235 / 100,
            child: imageOnCurentIndex.onClicked == OnAction.isClicked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      // SEDANG DICOMMENT KARENA FITUR BELUM BERHASIL
                      // GestureDetector(
                      //   onTap: () {
                      //     imageOnCurentIndex.onClicked = OnAction.isFalse;
                      //     cropImage(imageOnCurentIndex);
                      //   },
                      //   child: const Stack(
                      //     alignment: Alignment.center,
                      //     children: [
                      //       Icon(
                      //         Icons.crop_rounded,
                      //         color: Colors.blueAccent,
                      //         size: 25,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            imageOnCurentIndex.rotateValue -= details.delta.dx;
                            imageOnCurentIndex.rotateValue %= 360;
                            setState(() {});
                          },
                          onVerticalDragUpdate: (details) {
                            imageOnCurentIndex.rotateValue -= details.delta.dy;
                            imageOnCurentIndex.rotateValue %= 360;
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.autorenew,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (imageOnCurentIndex.boxRound ==
                              OnAction.isRounded) {
                            imageOnCurentIndex.boxRoundValue = 15.0;
                            imageOnCurentIndex.boxRound = OnAction.isFalse;
                          } else {
                            imageOnCurentIndex.boxRoundValue = 15.0;
                            imageOnCurentIndex.boxRound = OnAction.isRounded;
                          }
                          setState(() {});
                        },
                        onHorizontalDragUpdate: (details) {
                          imageOnCurentIndex.boxRoundValue = max(
                              10,
                              imageOnCurentIndex.boxRoundValue +
                                  details.delta.dx);
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.border_all_rounded,
                          color: Colors.blueAccent,
                          size: 25,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  )
                : const SizedBox(),
          ),
        ]);
      }
      // texts
      if (globalListObject[i].text.isNotEmpty) {
        data.add(
          Positioned(
            left: globalListObject[i].left,
            top: globalListObject[i].top,
            child: GestureDetector(
              onTapDown: (position) {
                getTapPosition(position);
              },
              onLongPress: () {
                moveImage(i).then((value) {
                  setState(() {});
                });
              },
              onDoubleTap: () {
                textEditingController.text = globalListObject[i].text;
                editText(i);
              },
              onTap: () => setCurrentIndex(context, i),
              child: Draggable(
                feedback: ImageTextCharles(stackObject: globalListObject[i]),
                child: ImageTextCharles(stackObject: globalListObject[i]),
                onDragStarted: () {},
                onDragEnd: (drag) {
                  final renderBox = context.findRenderObject() as RenderBox;
                  Offset off = renderBox.globalToLocal(drag.offset);
                  setState(() {
                    globalListObject[i].top = off.dy - 120;
                    globalListObject[i].left = off.dx - 18;
                  });
                },
              ),
            ),
          ),
        );
      }
    }
    return data;
  }
}
