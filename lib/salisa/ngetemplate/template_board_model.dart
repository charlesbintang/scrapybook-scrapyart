// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:scrapyart_home/angel/my_artboard_feature/drawing_line.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/drawing_point.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/image_text_charles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/default_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/stack_object_model.dart';
import 'package:scrapyart_home/salisa/ngetemplate/template_board.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_cropper/image_cropper.dart';

enum ActionCallback {
  none,
  imageAdded,
  textAdded,
  wallpaperAdded,
  stickerAdded,
  paintAdded,
  isButtonClicked,
  isBrushButtonClicked,
  isUndoButtonClicked,
  endOfBrush,
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

abstract class TemplateBoardModel extends State<TemplateBoard> {
  String menu = "image";
  String selectedWallpaper = "";
  List<String> assetFiles = [];
  List<String> wallpaperFiles = [];
  List<DrawingPoint> drawingPoint = [];
  List<StackObject> globalListObject = [];
  List<StackObject> historyGlobalListObject = [];
  File? selectedImage;
  CroppedFile? croppedFile;
  Color brushColor = Colors.black;
  Color canvasColor = Colors.white;
  int currentIndex = 0;
  int globalListObjectIndex = 0;
  int placeholderTotal = 0;
  double brushStrokeWidth = 10.0;
  double widthContainerRender = 0;
  double heightContainerRender = 0;
  double canvasWidth = 0.0;
  double canvasHeight = 0.0;
  Offset tapPosition = Offset.zero;
  bool isGlobalListObjectEmpty = true;
  bool isHistoryGlobalListObjectEmpty = true;
  bool isEndOfHistoryGlobalListObject = true;
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController newTextController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textColorController = TextEditingController(
      text:
          'FF000000'); // The initial value can be provided directly to the controller.
  ActionCallback isButtonClicked = ActionCallback.none;
  ActionCallback isTextAdded = ActionCallback.none;
  ActionCallback isImageAdded = ActionCallback.none;
  ActionCallback isWallpaperAdded = ActionCallback.none;
  ActionCallback isStickerAdded = ActionCallback.none;
  ActionCallback isPaintAdded = ActionCallback.none;

  @override
  void initState() {
    super.initState();
    globalListObject.add(
      StackObject(
        template: TemplateBoard(
          id: widget.id,
          placeholder: widget.id,
          assetImage: widget.assetImage,
        ).assetImage,
      ),
    );
    print(globalListObject.length);
    print(globalListObject);
    historyGlobalListObject = List.of(globalListObject);
    placeholderTotal = widget.placeholder;
    print(placeholderTotal);
    getAssetFiles();
    initStateDone();
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

  Future<void> initStateDone() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
      () => getSizeOfTheCanvas("utama"),
    );
  }

  void getSizeOfTheCanvas(String string) {
    final RenderBox box =
        GlobalObjectKey(string).currentContext!.findRenderObject() as RenderBox;
    canvasWidth = box.size.width;
    canvasHeight = box.size.height;
    setState(() {});
  }

  void setCurrentIndex(BuildContext context, index) {
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
          isWallpaperAdded = ActionCallback.none;
          isStickerAdded = ActionCallback.none;
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
            globalListObject[indexImage].sticker.isNotEmpty) {
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
        if (globalListObject[indexImage].image != null ||
            globalListObject[indexImage].sticker.isNotEmpty) {
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
      globalListObject.insert(
        0,
        StackObject(
          /// pickImageFromGallery harus menyertakan image didalamnya
          image: selectedImage,
        ),
      );
      globalListObject.add(
        StackObject(
          /// pickImageFromGallery harus menyertakan image didalamnya
          image: selectedImage,
          transparent: true,
        ),
      );
      historyGlobalListObject = List.of(globalListObject);
      isHistoryGlobalListObjectEmpty = false;
      isImageAdded = ActionCallback.imageAdded;
    });
  }

  Future<void> cropImage(StackObject imageOnCurrentIndex) async {
    if (imageOnCurrentIndex.image != null ||
        imageOnCurrentIndex.sticker.isNotEmpty) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageOnCurrentIndex.image != null
            ? imageOnCurrentIndex.image!.path
            : imageOnCurrentIndex.sticker,
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
          max(0.0, globalListObject[currentIndex].fontSize -= 2);
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
      historyGlobalListObject = List.of(globalListObject);
      isHistoryGlobalListObjectEmpty = false;
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
              child: const Text('Back')),
          DefaultButton(
              onPressed: () => addNewsText(context),
              color: Colors.white,
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
              child: const Text('Back')),
          DefaultButton(
              onPressed: () {
                setState(() {
                  globalListObject[i].text = textEditingController.text;
                });
                Navigator.of(context).pop();
              },
              color: const Color.fromARGB(255, 122, 74, 37),
              child: const Text('Save'))
        ],
      ),
    );
  }

  allAsset(List<Widget> data) {
    for (var i = 0; i < assetFiles.length; i++) {
      data.add(
        IconButton(
          onPressed: () {
            // print("asset ke $i");
            setState(() {
              globalListObject.add(
                StackObject(
                  /// pickImageFromGallery harus menyertakan image didalamnya
                  sticker: assetFiles[i],
                ),
              );
            });
            historyGlobalListObject = List.of(globalListObject);
            isHistoryGlobalListObjectEmpty = false;
            isStickerAdded = ActionCallback.stickerAdded;
          },
          icon: Image.asset(
            assetFiles[i],
            width: 25,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }
  }

  void deleteAllImages() {
    globalListObject.removeWhere((element) => element.image != null);
    isImageAdded = ActionCallback.none;
    setState(() {});
  }

  void deleteAllTexts() {
    globalListObject.removeWhere((element) => element.text.isNotEmpty);
    isTextAdded = ActionCallback.none;
    isButtonClicked = ActionCallback.none;
    setState(() {});
  }

  // void deleteWallpaper() {
  //   selectedWallpaper = "";
  //   isWallpaperAdded = ActionCallback.none;
  //   setState(() {});
  // }

  void deleteAllSticker() {
    globalListObject.removeWhere((element) => element.sticker.isNotEmpty);
    isStickerAdded = ActionCallback.none;
    setState(() {});
  }

  void deleteAllPaint() {
    globalListObject.removeWhere(
        (element) => element.paint != null && element.offset != null);
    globalListObject.removeWhere(
        (element) => element.paint == null && element.offset == null);
    isPaintAdded = ActionCallback.none;
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

  void changeBrushColor(Color color) => setState(() => brushColor = color);

  void changeCanvasColor(Color color) => setState(() => canvasColor = color);

  void increaseBrushStrokeWidth(BuildContext context) {
    setState(() {
      brushStrokeWidth += 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Stroke Width : $brushStrokeWidth",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void decreaseBrushStrokeWidth(BuildContext context) {
    setState(() {
      brushStrokeWidth = max(0.5, brushStrokeWidth -= 1);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Stroke Width : $brushStrokeWidth",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  bool isObjectEmpty() {
    if (globalListObject.isEmpty) {
      isGlobalListObjectEmpty = true;
      return true;
    } else {
      isGlobalListObjectEmpty = false;
      globalListObjectIndex = globalListObject.length;
      return false;
    }
  }

  brushOnPanStart(details) {
    isButtonClicked == ActionCallback.isBrushButtonClicked
        ? setState(() {
            globalListObject.add(StackObject(
              offset: details.localPosition,
              paint: Paint()
                ..color = brushColor
                ..isAntiAlias = true
                ..strokeWidth = brushStrokeWidth
                ..strokeCap = StrokeCap.round,
            ));
          })
        : null;
    historyGlobalListObject = List.of(globalListObject);
    isHistoryGlobalListObjectEmpty = false;
  }

  brushOnPanUpdate(details) {
    isButtonClicked == ActionCallback.isBrushButtonClicked
        ? setState(() {
            globalListObject.add(StackObject(
              offset: details.localPosition,
              paint: Paint()
                ..color = brushColor
                ..isAntiAlias = true
                ..strokeWidth = brushStrokeWidth
                ..strokeCap = StrokeCap.round,
            ));
          })
        : null;
  }

  brushOnPanEnd(details) {
    isButtonClicked == ActionCallback.isBrushButtonClicked
        ? setState(() {
            globalListObject.add(StackObject(offset: null, paint: null));
            isPaintAdded = ActionCallback.paintAdded;
          })
        : null;
    historyGlobalListObject = List.of(globalListObject);
    isHistoryGlobalListObjectEmpty = false;
  }

  undoObject() {
    if (isGlobalListObjectEmpty == false) {
      setState(() {
        globalListObject.removeLast();
      });
      globalListObjectIndex -= 1;
      isEndOfHistoryGlobalListObject = false;
    }
  }

  redoObject() {
    if (globalListObject.length < historyGlobalListObject.length) {
      setState(() {
        globalListObject
            .add(historyGlobalListObject.elementAt(globalListObjectIndex));
      });
    }
    if (globalListObject.length == historyGlobalListObject.length) {
      isEndOfHistoryGlobalListObject = true;
    }
  }

  List<Widget> dataStack() {
    List<Widget> data = [];
    for (var i = 0; i < globalListObject.length; i++) {
      ///
      /// Template image
      ///
      if (globalListObject[i].template.isNotEmpty) {
        var objectOnCurrentIndex = globalListObject[i];
        data.addAll([
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: canvasWidth,
              height: canvasHeight,
              decoration: BoxDecoration(
                borderRadius: objectOnCurrentIndex.boxRound ==
                        OnAction.isRounded
                    ? BorderRadius.circular(objectOnCurrentIndex.boxRoundValue)
                    : null,
                image: objectOnCurrentIndex.croppedFile == null
                    ? DecorationImage(
                        image: AssetImage(objectOnCurrentIndex.template),
                        fit: BoxFit.fill)
                    : DecorationImage(
                        image: FileImage(
                          File(objectOnCurrentIndex.croppedFile!.path),
                        ),
                      ),
              ),
            ),
          ),
        ]);
      }

      ///
      /// images
      ///
      if (globalListObject[i].image != null &&
          globalListObject[i].transparent == false) {
        var objectOnCurrentIndex = globalListObject[i];
        data.addAll([
          Positioned(
            top: globalListObject[placeholderTotal].top,
            left: globalListObject[placeholderTotal].left,
            child: GestureDetector(
              onPanUpdate: globalListObject[placeholderTotal].onClicked ==
                      OnAction.isFalse
                  ? (details) {
                      globalListObject[placeholderTotal].top =
                          globalListObject[placeholderTotal].top +
                              details.delta.dy;
                      globalListObject[placeholderTotal].left =
                          globalListObject[placeholderTotal].left +
                              details.delta.dx;
                      setState(() {});
                    }
                  : null,
              child: Container(
                key: GlobalObjectKey(i),
                width: globalListObject[placeholderTotal].imageWidth,
                height: globalListObject[placeholderTotal].imageHeight,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                    globalListObject[placeholderTotal].rotateValue / 180 * pi),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width:
                            globalListObject[placeholderTotal].imageWidth - 20,
                        height:
                            globalListObject[placeholderTotal].imageHeight - 20,
                        decoration: BoxDecoration(
                          borderRadius: objectOnCurrentIndex.boxRound ==
                                  OnAction.isRounded
                              ? BorderRadius.circular(
                                  objectOnCurrentIndex.boxRoundValue)
                              : null,
                          image: DecorationImage(
                              image: objectOnCurrentIndex.croppedFile == null
                                  ? FileImage(objectOnCurrentIndex.image!)
                                  : FileImage(File(
                                      objectOnCurrentIndex.croppedFile!.path)),
                              fit: BoxFit.fill),
                          border: objectOnCurrentIndex.onClicked ==
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
                            if (globalListObject[placeholderTotal].onClicked ==
                                OnAction.isFalse) {
                              setState(() {
                                for (var i = 0;
                                    i < globalListObject.length;
                                    i++) {
                                  var objectOnCurrentIndex =
                                      globalListObject[i];
                                  objectOnCurrentIndex.onClicked =
                                      OnAction.isFalse;
                                }
                                globalListObject[placeholderTotal].onClicked =
                                    OnAction.isClicked;
                              });
                            } else if (globalListObject[placeholderTotal]
                                    .onClicked ==
                                OnAction.isClicked) {
                              globalListObject[placeholderTotal].onClicked =
                                  OnAction.isFalse;
                            }
                          },
                          // onLongPress: () {
                          //   moveImage(i).then((value) {
                          //     setState(() {});
                          //   });
                          // },
                        ),
                      ),
                    ),

                    ///
                    /// tombol resize image
                    ///
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width:
                            globalListObject[placeholderTotal].imageWidth - 20,
                        height:
                            globalListObject[placeholderTotal].imageHeight - 20,
                        child: Column(
                          children: [
                            const Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(child: SizedBox()),
                                globalListObject[placeholderTotal].onClicked ==
                                        OnAction.isClicked
                                    ? GestureDetector(
                                        onPanUpdate: (details) {
                                          getSizeOfTheBox(i);

                                          globalListObject[placeholderTotal]
                                                  .imageHeight =
                                              max(
                                                  70,
                                                  globalListObject[
                                                              placeholderTotal]
                                                          .imageHeight +
                                                      details.delta.dy);
                                          globalListObject[placeholderTotal]
                                                  .imageWidth =
                                              max(
                                                  90,
                                                  globalListObject[
                                                              placeholderTotal]
                                                          .imageWidth +
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

                    ///
                    /// tombol scaling image
                    ///
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: globalListObject[placeholderTotal].onClicked ==
                              OnAction.isClicked
                          ? GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                globalListObject[placeholderTotal].imageWidth =
                                    max(
                                        90,
                                        globalListObject[placeholderTotal]
                                                .imageWidth +
                                            details.delta.dx);
                                globalListObject[placeholderTotal].imageHeight =
                                    max(
                                        70,
                                        globalListObject[placeholderTotal]
                                                .imageHeight +
                                            details.delta.dx);
                                getSizeOfTheBox(i);
                                setState(() {});
                              },
                              onVerticalDragUpdate: (details) {
                                globalListObject[placeholderTotal].imageWidth =
                                    max(
                                        90,
                                        globalListObject[placeholderTotal]
                                                .imageWidth +
                                            details.delta.dy);
                                globalListObject[placeholderTotal].imageHeight =
                                    max(
                                        70,
                                        globalListObject[placeholderTotal]
                                                .imageHeight +
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

          ///
          /// tombol untuk crop, rotate, dan border image
          ///
          Positioned(
            top: globalListObject[placeholderTotal].top,
            left: globalListObject[placeholderTotal].left,
            width: widthContainerRender + 1,
            height: heightContainerRender * 235 / 100,
            child: globalListObject[placeholderTotal].onClicked ==
                    OnAction.isClicked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      // GestureDetector(
                      //   onTap: () {
                      //     globalListObject[placeholderTotal].onClicked =
                      //         OnAction.isFalse;
                      //     cropImage(globalListObject[placeholderTotal]);
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
                            globalListObject[placeholderTotal].rotateValue -=
                                details.delta.dx;
                            globalListObject[placeholderTotal].rotateValue %=
                                360;
                            setState(() {});
                          },
                          onVerticalDragUpdate: (details) {
                            globalListObject[placeholderTotal].rotateValue -=
                                details.delta.dy;
                            globalListObject[placeholderTotal].rotateValue %=
                                360;
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.autorenew,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     if (globalListObject[placeholderTotal].boxRound ==
                      //         OnAction.isRounded) {
                      //       globalListObject[placeholderTotal].boxRoundValue =
                      //           15.0;
                      //       globalListObject[placeholderTotal].boxRound =
                      //           OnAction.isFalse;
                      //     } else {
                      //       globalListObject[placeholderTotal].boxRoundValue =
                      //           15.0;
                      //       globalListObject[placeholderTotal].boxRound =
                      //           OnAction.isRounded;
                      //     }
                      //     setState(() {});
                      //   },
                      //   onHorizontalDragUpdate: (details) {
                      //     globalListObject[placeholderTotal].boxRoundValue =
                      //         max(
                      //             10,
                      //             globalListObject[placeholderTotal]
                      //                     .boxRoundValue +
                      //                 details.delta.dx);
                      //     setState(() {});
                      //   },
                      //   child: const Icon(
                      //     Icons.border_all_rounded,
                      //     color: Colors.blueAccent,
                      //     size: 25,
                      //   ),
                      // ),
                      const Expanded(child: SizedBox()),
                    ],
                  )
                : const SizedBox(),
          ),
        ]);
      }

      ///
      /// image transparent
      ///
      if (globalListObject[i].image != null &&
          globalListObject[i].transparent) {
        var objectOnCurrentIndex = globalListObject[i];
        data.addAll([
          Positioned(
            top: globalListObject[placeholderTotal].top,
            left: globalListObject[placeholderTotal].left,
            child: GestureDetector(
              onPanUpdate: objectOnCurrentIndex.onClicked == OnAction.isFalse
                  ? (details) {
                      globalListObject[placeholderTotal].top =
                          globalListObject[placeholderTotal].top +
                              details.delta.dy;
                      globalListObject[placeholderTotal].left =
                          globalListObject[placeholderTotal].left +
                              details.delta.dx;
                      setState(() {});
                    }
                  : null,
              child: Container(
                key: GlobalObjectKey(i),
                width: globalListObject[placeholderTotal].imageWidth,
                height: globalListObject[placeholderTotal].imageHeight,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                    globalListObject[placeholderTotal].rotateValue / 180 * pi),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width:
                            globalListObject[placeholderTotal].imageWidth - 20,
                        height:
                            globalListObject[placeholderTotal].imageHeight - 20,
                        decoration: BoxDecoration(
                          borderRadius: objectOnCurrentIndex.boxRound ==
                                  OnAction.isRounded
                              ? BorderRadius.circular(
                                  objectOnCurrentIndex.boxRoundValue)
                              : null,
                          image: DecorationImage(
                              image: objectOnCurrentIndex.croppedFile == null
                                  ? FileImage(objectOnCurrentIndex.image!)
                                  : FileImage(File(
                                      objectOnCurrentIndex.croppedFile!.path)),
                              fit: BoxFit.fill,
                              opacity: 0),
                          border: objectOnCurrentIndex.onClicked ==
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
                            if (objectOnCurrentIndex.onClicked ==
                                OnAction.isFalse) {
                              setState(() {
                                for (var i = 0;
                                    i < globalListObject.length;
                                    i++) {
                                  var objectOnCurrentIndex =
                                      globalListObject[i];
                                  objectOnCurrentIndex.onClicked =
                                      OnAction.isFalse;
                                }
                                objectOnCurrentIndex.onClicked =
                                    OnAction.isClicked;
                              });
                            } else if (objectOnCurrentIndex.onClicked ==
                                OnAction.isClicked) {
                              objectOnCurrentIndex.onClicked = OnAction.isFalse;
                            }
                          },
                          // onLongPress: () {
                          //   moveImage(i).then((value) {
                          //     setState(() {});
                          //   });
                          // },
                        ),
                      ),
                    ),

                    ///
                    /// tombol resize image
                    ///
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width:
                            globalListObject[placeholderTotal].imageWidth - 20,
                        height:
                            globalListObject[placeholderTotal].imageHeight - 20,
                        child: Column(
                          children: [
                            const Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(child: SizedBox()),
                                objectOnCurrentIndex.onClicked ==
                                        OnAction.isClicked
                                    ? GestureDetector(
                                        onPanUpdate: (details) {
                                          getSizeOfTheBox(i);

                                          globalListObject[placeholderTotal]
                                                  .imageHeight =
                                              max(
                                                  70,
                                                  globalListObject[
                                                              placeholderTotal]
                                                          .imageHeight +
                                                      details.delta.dy);
                                          globalListObject[placeholderTotal]
                                                  .imageWidth =
                                              max(
                                                  90,
                                                  globalListObject[
                                                              placeholderTotal]
                                                          .imageWidth +
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

                    ///
                    /// tombol scaling image
                    ///
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: objectOnCurrentIndex.onClicked ==
                              OnAction.isClicked
                          ? GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                globalListObject[placeholderTotal].imageWidth =
                                    max(
                                        90,
                                        globalListObject[placeholderTotal]
                                                .imageWidth +
                                            details.delta.dx);
                                globalListObject[placeholderTotal].imageHeight =
                                    max(
                                        70,
                                        globalListObject[placeholderTotal]
                                                .imageHeight +
                                            details.delta.dx);
                                getSizeOfTheBox(i);
                                setState(() {});
                              },
                              onVerticalDragUpdate: (details) {
                                globalListObject[placeholderTotal].imageWidth =
                                    max(
                                        90,
                                        globalListObject[placeholderTotal]
                                                .imageWidth +
                                            details.delta.dy);
                                globalListObject[placeholderTotal].imageHeight =
                                    max(
                                        70,
                                        globalListObject[placeholderTotal]
                                                .imageHeight +
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

          ///
          /// tombol untuk crop, rotate, dan border image
          ///
          Positioned(
            top: globalListObject[placeholderTotal].top,
            left: globalListObject[placeholderTotal].left,
            width: widthContainerRender + 1,
            height: heightContainerRender * 235 / 100,
            child: objectOnCurrentIndex.onClicked == OnAction.isClicked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      // GestureDetector(
                      //   onTap: () {
                      //     globalListObject[placeholderTotal].onClicked =
                      //         OnAction.isFalse;
                      //     cropImage(ob);
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
                            globalListObject[placeholderTotal].rotateValue -=
                                details.delta.dx;
                            globalListObject[placeholderTotal].rotateValue %=
                                360;
                            setState(() {});
                          },
                          onVerticalDragUpdate: (details) {
                            globalListObject[placeholderTotal].rotateValue -=
                                details.delta.dy;
                            globalListObject[placeholderTotal].rotateValue %=
                                360;
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.autorenew,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     if (globalListObject[placeholderTotal].boxRound ==
                      //         OnAction.isRounded) {
                      //       globalListObject[placeholderTotal].boxRoundValue =
                      //           15.0;
                      //       globalListObject[placeholderTotal].boxRound =
                      //           OnAction.isFalse;
                      //     } else {
                      //       globalListObject[placeholderTotal].boxRoundValue =
                      //           15.0;
                      //       globalListObject[placeholderTotal].boxRound =
                      //           OnAction.isRounded;
                      //     }
                      //     setState(() {});
                      //   },
                      //   onHorizontalDragUpdate: (details) {
                      //     globalListObject[placeholderTotal].boxRoundValue =
                      //         max(
                      //             10,
                      //             globalListObject[placeholderTotal]
                      //                     .boxRoundValue +
                      //                 details.delta.dx);
                      //     setState(() {});
                      //   },
                      //   child: const Icon(
                      //     Icons.border_all_rounded,
                      //     color: Colors.blueAccent,
                      //     size: 25,
                      //   ),
                      // ),
                      const Expanded(child: SizedBox()),
                    ],
                  )
                : const SizedBox(),
          ),
        ]);
      }

      ///
      /// sticker images
      ///
      if (globalListObject[i].sticker.isNotEmpty) {
        var objectOnCurrentIndex = globalListObject[i];
        data.addAll([
          Positioned(
            top: objectOnCurrentIndex.top,
            left: objectOnCurrentIndex.left,
            child: GestureDetector(
              onPanUpdate: objectOnCurrentIndex.onClicked == OnAction.isFalse
                  ? (details) {
                      objectOnCurrentIndex.top =
                          objectOnCurrentIndex.top + details.delta.dy;
                      objectOnCurrentIndex.left =
                          objectOnCurrentIndex.left + details.delta.dx;
                      setState(() {});
                    }
                  : null,
              child: Container(
                key: GlobalObjectKey(i),
                width: objectOnCurrentIndex.imageWidth,
                height: objectOnCurrentIndex.imageHeight,
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationZ(
                    objectOnCurrentIndex.rotateValue / 180 * pi),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: objectOnCurrentIndex.imageWidth - 20,
                        height: objectOnCurrentIndex.imageHeight - 20,
                        decoration: BoxDecoration(
                          borderRadius: objectOnCurrentIndex.boxRound ==
                                  OnAction.isRounded
                              ? BorderRadius.circular(
                                  objectOnCurrentIndex.boxRoundValue)
                              : null,
                          image: objectOnCurrentIndex.croppedFile == null
                              ? DecorationImage(
                                  image:
                                      AssetImage(objectOnCurrentIndex.sticker),
                                  fit: BoxFit.fill)
                              : DecorationImage(
                                  image: FileImage(
                                    File(
                                        objectOnCurrentIndex.croppedFile!.path),
                                  ),
                                ),
                          border: objectOnCurrentIndex.onClicked ==
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
                            if (objectOnCurrentIndex.onClicked ==
                                OnAction.isFalse) {
                              setState(() {
                                for (var i = 0;
                                    i < globalListObject.length;
                                    i++) {
                                  var objectOnCurrentIndex =
                                      globalListObject[i];
                                  objectOnCurrentIndex.onClicked =
                                      OnAction.isFalse;
                                }
                                objectOnCurrentIndex.onClicked =
                                    OnAction.isClicked;
                              });
                            } else if (objectOnCurrentIndex.onClicked ==
                                OnAction.isClicked) {
                              objectOnCurrentIndex.onClicked = OnAction.isFalse;
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

                    ///
                    /// tombol resize image
                    ///
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width: objectOnCurrentIndex.imageWidth - 20,
                        height: objectOnCurrentIndex.imageHeight - 20,
                        child: Column(
                          children: [
                            const Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(child: SizedBox()),
                                objectOnCurrentIndex.onClicked ==
                                        OnAction.isClicked
                                    ? GestureDetector(
                                        onPanUpdate: (details) {
                                          getSizeOfTheBox(i);

                                          objectOnCurrentIndex.imageHeight =
                                              max(
                                                  70,
                                                  objectOnCurrentIndex
                                                          .imageHeight +
                                                      details.delta.dy);
                                          objectOnCurrentIndex.imageWidth = max(
                                              90,
                                              objectOnCurrentIndex.imageWidth +
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

                    ///
                    /// tombol scaling image
                    ///
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child:
                          objectOnCurrentIndex.onClicked == OnAction.isClicked
                              ? GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    objectOnCurrentIndex.imageWidth = max(
                                        90,
                                        objectOnCurrentIndex.imageWidth +
                                            details.delta.dx);
                                    objectOnCurrentIndex.imageHeight = max(
                                        70,
                                        objectOnCurrentIndex.imageHeight +
                                            details.delta.dx);
                                    getSizeOfTheBox(i);
                                    setState(() {});
                                  },
                                  onVerticalDragUpdate: (details) {
                                    objectOnCurrentIndex.imageWidth = max(
                                        90,
                                        objectOnCurrentIndex.imageWidth +
                                            details.delta.dy);
                                    objectOnCurrentIndex.imageHeight = max(
                                        70,
                                        objectOnCurrentIndex.imageHeight +
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

          ///
          /// tombol untuk crop, rotate, dan border image
          ///
          Positioned(
            top: objectOnCurrentIndex.top,
            left: objectOnCurrentIndex.left,
            width: widthContainerRender + 1,
            height: heightContainerRender * 235 / 100,
            child: objectOnCurrentIndex.onClicked == OnAction.isClicked
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            objectOnCurrentIndex.rotateValue -=
                                details.delta.dx;
                            objectOnCurrentIndex.rotateValue %= 360;
                            setState(() {});
                          },
                          onVerticalDragUpdate: (details) {
                            objectOnCurrentIndex.rotateValue -=
                                details.delta.dy;
                            objectOnCurrentIndex.rotateValue %= 360;
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
                          if (objectOnCurrentIndex.boxRound ==
                              OnAction.isRounded) {
                            objectOnCurrentIndex.boxRoundValue = 15.0;
                            objectOnCurrentIndex.boxRound = OnAction.isFalse;
                          } else {
                            objectOnCurrentIndex.boxRoundValue = 15.0;
                            objectOnCurrentIndex.boxRound = OnAction.isRounded;
                          }
                          setState(() {});
                        },
                        onHorizontalDragUpdate: (details) {
                          objectOnCurrentIndex.boxRoundValue = max(
                              10,
                              objectOnCurrentIndex.boxRoundValue +
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

      /// Brush
      if (globalListObject[i].offset != null &&
          globalListObject[i].paint != null) {
        data.add(CustomPaint(
          painter: DrawingLine(globalListObject),
        ));
      }

      /// texts
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
