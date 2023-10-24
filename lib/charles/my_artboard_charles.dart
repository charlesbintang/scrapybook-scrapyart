// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/image_text_charles.dart';
// import 'package:scrapyart_home/angel/feature_my_artboard/image_text.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/my_artboard.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:scrapyart_home/angel/text_info.dart';
// import 'package:scrapyart_home/charles/stack_image_model.dart';
import 'package:scrapyart_home/charles/stack_object_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_cropper/image_cropper.dart';

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

abstract class MyArtboardCharles extends State<MyArtboard> {
  File? selectedImage;
  ScreenshotController screenshotController = ScreenshotController();
  CroppedFile? croppedFile;
  Offset tapPosition = Offset.zero;
  List<StackObject> globalListObject = [];
  // List<TextInfo> texts = [];
  int currentIndex = 0;
  double widthContainerRender = 0;
  double heightContainerRender = 0;
  Color selectedColor = Colors.black; // Warna awal

  void _getTapPosition(TapDownDetails tapPostion) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      tapPosition = renderBox.globalToLocal(tapPostion.globalPosition);
      print(tapPosition);
    });
  }

  void _getSizeOfTheBox(i) {
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

  // buat kembalikan list widget yang akan di tumpuk
  List<Widget> dataStack() {
    List<Widget> data = [];
    for (var i = 0; i < globalListObject.length; i++) {
      if (globalListObject[i].image != null) {
        var imageOnCurentIndex = globalListObject[i];
        data.addAll([
          // images
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
                        // color: Colors.amber,
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
                            _getTapPosition(position);
                            _getSizeOfTheBox(i);
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
                                        onTap: () {
                                          print(imageOnCurentIndex.imageWidth);
                                          print(imageOnCurentIndex.imageHeight);
                                        },
                                        onPanUpdate: (details) {
                                          _getSizeOfTheBox(i);

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
                                _getSizeOfTheBox(i);
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
                                _getSizeOfTheBox(i);
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
                          _cropImage(imageOnCurentIndex);
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
                          print(imageOnCurentIndex.boxRound);
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
              onLongPress: () {
                print('long press detected');
              },
              onTap: () => setCurrentIndex(context, i),
              child: Draggable(
                feedback: ImageTextCharles(stackObject: globalListObject[i]),
                child: ImageTextCharles(stackObject: globalListObject[i]),
                onDragEnd: (drag) {
                  final renderBox = context.findRenderObject() as RenderBox;
                  Offset off = renderBox.globalToLocal(drag.offset);
                  setState(() {
                    globalListObject[i].color = selectedColor;
                    globalListObject[i].top = off.dy - 120;
                    globalListObject[i].left = off.dx;
                  });
                },
              ),
            ),
          ),
        );
      }
    }
    // for (int i = 0; i < texts.length; i++) {
    //   data.add(
    //     Positioned(
    //       left: texts[i].left,
    //       top: texts[i].top,
    //       child: GestureDetector(
    //         onLongPress: () {
    //           print('long press detected');
    //         },
    //         onTap: () => setCurrentIndex(context, i),
    //         child: Draggable(
    //           feedback: ImageText(textInfo: texts[i]),
    //           child: ImageText(textInfo: texts[i]),
    //           onDragEnd: (drag) {
    //             final renderBox = context.findRenderObject() as RenderBox;
    //             Offset off = renderBox.globalToLocal(drag.offset);
    //             setState(() {
    //               texts[i].color = selectedColor;
    //               texts[i].top = off.dy - 120;
    //               texts[i].left = off.dx;
    //             });
    //           },
    //         ),
    //       ),
    //     ),
    //   );
    // }
    return data;
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
      // actions.add(down);
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
          // pickImageFromGallery harus menyertakan image didalamnya
          image: selectedImage,
        ),
      );
    });
  }

  Future<void> _cropImage(StackObject imageOnCurrentIndex) async {
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
}
