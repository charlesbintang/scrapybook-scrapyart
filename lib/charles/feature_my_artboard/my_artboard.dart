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
import 'package:image_cropper/image_cropper.dart';

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
  CroppedFile? croppedFile;
  Offset _tapPosition = Offset.zero;
  List<StackImage> globalListImage = [];
  double widthContainerRender = 0;
  double heightContainerRender = 0;

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
      body: artboardCanvas(context),
      floatingActionButton: floatingActionButton(),
    );
  }

  void _getTapPosition(TapDownDetails tapPostion) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPostion.globalPosition);
      print(_tapPosition);
    });
  }

  void _getSizeOfTheBox(i) {
    final RenderBox box =
        GlobalObjectKey(i).currentContext!.findRenderObject() as RenderBox;
    widthContainerRender = box.size.width;
    heightContainerRender = box.size.height;
    setState(() {});
  }

  // buat kembalikan list widget yang akan di tumpuk
  // ignore: unused_element
  List<Widget> dataStack() {
    List<Widget> data = [];
    for (var i = 0; i < globalListImage.length; i++) {
      var imageOnCurentIndex = globalListImage[i];
      data.add(
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
              transformAlignment: Alignment.center,
              height: imageOnCurentIndex.imageHeight,
              width: imageOnCurentIndex.imageWidth,
              transform:
                  Matrix4.rotationZ(imageOnCurentIndex.rotateValue / 180 * pi),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: imageOnCurentIndex.boxRound == OnAction.isRounded
                    ? BorderRadius.circular(imageOnCurentIndex.boxRoundValue)
                    : null,
                image: DecorationImage(
                    image: imageOnCurentIndex.croppedFile == null
                        ? FileImage(imageOnCurentIndex.image!)
                        : FileImage(File(imageOnCurentIndex.croppedFile!.path)),
                    fit: BoxFit.fill),
                border: imageOnCurentIndex.onClicked == OnAction.isClicked
                    ? Border.all(color: Colors.blueAccent, width: 2)
                    : null,
              ),
              child: GestureDetector(
                onTapDown: (position) {
                  _getTapPosition(position);
                  _getSizeOfTheBox(i);
                },
                onTap: () {
                  if (imageOnCurentIndex.onClicked == OnAction.isFalse) {
                    setState(() {
                      for (var i = 0; i < globalListImage.length; i++) {
                        var imageOnCurentIndex = globalListImage[i];
                        imageOnCurentIndex.onClicked = OnAction.isFalse;
                      }
                      imageOnCurentIndex.onClicked = OnAction.isClicked;
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
                // child: imageOnCurentIndex.croppedFile == null
                //     ? Image.file(
                //         imageOnCurentIndex.image!,
                //         width: imageOnCurentIndex.imageWidth,
                //         fit: BoxFit.fill,
                //       )
                //     : Image.file(
                //         File(imageOnCurentIndex.croppedFile!.path),
                //         width: imageOnCurentIndex.imageWidth,
                //         fit: BoxFit.fill,
                //       ),
              ),
            ),
          ),
        ),
      );
      data.add(
        Positioned(
          top: imageOnCurentIndex.top,
          left: imageOnCurentIndex.left,
          width: widthContainerRender + 1,
          height: heightContainerRender + 1,
          child: Container(
            transformAlignment: Alignment.center,
            transform:
                Matrix4.rotationZ(imageOnCurentIndex.rotateValue / 180 * pi),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // imageOnCurentIndex.onClicked == OnAction.isClicked
                    //     ? GestureDetector(
                    //         onHorizontalDragUpdate: (details) {
                    //           imageOnCurentIndex.imageWidth = max(
                    //               20,
                    //               imageOnCurentIndex.imageWidth +
                    //                   details.delta.dx);
                    //           _getSizeOfTheBox(i);
                    //           setState(() {});
                    //         },
                    //         onHorizontalDragEnd: (details) {
                    //           setState(() {
                    //             imageOnCurentIndex.onClicked ==
                    //                 OnAction.isFalse;
                    //           });
                    //         },
                    //         onVerticalDragUpdate: (details) {
                    //           imageOnCurentIndex.imageHeight =
                    //               imageOnCurentIndex.imageHeight +
                    //                   details.delta.dy;
                    //           _getSizeOfTheBox(i);
                    //           setState(() {});
                    //         },
                    //         onVerticalDragEnd: (details) {
                    //           setState(() {
                    //             imageOnCurentIndex.onClicked ==
                    //                 OnAction.isFalse;
                    //           });
                    //         },
                    //         child: const Stack(
                    //           alignment: Alignment.center,
                    //           children: [
                    //             Icon(
                    //               Icons.circle,
                    //               color: Colors.white,
                    //               size: 25,
                    //             ),
                    //             Icon(
                    //               Icons.circle,
                    //               color: Colors.blueAccent,
                    //               size: 15,
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(child: SizedBox()),
                    imageOnCurentIndex.onClicked == OnAction.isClicked
                        ? GestureDetector(
                            // onHorizontalDragUpdate: (details) {
                            //   imageOnCurentIndex.imageWidth = max(
                            //       20,
                            //       imageOnCurentIndex.imageWidth +
                            //           details.delta.dx);
                            //   _getSizeOfTheBox(i);
                            //   setState(() {});
                            // },
                            // onHorizontalDragEnd: (details) {
                            //   setState(() {
                            //     imageOnCurentIndex.onClicked ==
                            //         OnAction.isFalse;
                            //   });
                            // },
                            // onVerticalDragUpdate: (details) {
                            //   imageOnCurentIndex.imageHeight =
                            //       imageOnCurentIndex.imageHeight +
                            //           details.delta.dy;
                            //   _getSizeOfTheBox(i);
                            //   setState(() {});
                            // },
                            // onVerticalDragEnd: (details) {
                            //   setState(() {
                            //     imageOnCurentIndex.onClicked ==
                            //         OnAction.isFalse;
                            //   });
                            // },
                            onTap: () {
                              print(imageOnCurentIndex.imageHeight);
                              print(imageOnCurentIndex.imageWidth);
                            },
                            onPanUpdate: (details) {
                              imageOnCurentIndex.imageHeight = max(
                                  28,
                                  imageOnCurentIndex.imageHeight +
                                      details.delta.dy);
                              imageOnCurentIndex.imageWidth = max(
                                  92,
                                  imageOnCurentIndex.imageWidth +
                                      details.delta.dx);
                              _getSizeOfTheBox(i);
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
      );
      data.add(
        // tombol untuk rotate image
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
                        if (imageOnCurentIndex.boxRound == OnAction.isRounded) {
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
    var reset = PopupMenuItem(
      child: const Text("Reset"),
      onTap: () {
        globalListImage[indexImage].croppedFile = null;
        globalListImage[indexImage].rotateValue = 0.0;
        globalListImage[indexImage].imageWidth = 200.0;
        globalListImage[indexImage].imageHeight = 200.0;
        globalListImage[indexImage].boxRoundValue = 15.0;
        globalListImage[indexImage].onClicked = OnAction.isFalse;
        globalListImage[indexImage].onScaling = OnAction.isFalse;
        globalListImage[indexImage].boxRound = OnAction.isFalse;
      },
    );

    // gambar pertama
    if (indexImage == 0 && indexImage + globalListImage.length == 1) {
      // actions.add(down);
      actions.add(delete);
      actions.add(reset);
    } else if (indexImage == 0 && indexImage + globalListImage.length > 1) {
      actions.add(up);
      actions.add(delete);
      actions.add(reset);
    } else if (indexImage == globalListImage.length - 1) {
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
      globalListImage.add(
        StackImage(
          image: _selectedImage,
        ),
      );
    });
  }

  Future<void> _cropImage(StackImage imageOnCurrentIndex) async {
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

  Center artboardCanvas(BuildContext context) {
    return Center(
      child: Screenshot(
        controller: screenshotController,
        child: GestureDetector(
          onTap: () {
            print("tertekan");
            setState(() {
              for (var i = 0; i < globalListImage.length; i++) {
                var imageOnCurentIndex = globalListImage[i];
                imageOnCurentIndex.onClicked == OnAction.isFalse;
              }
            });
          },
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            height: MediaQuery.of(context).size.height - 160,
            width: MediaQuery.of(context).size.width - 20,
            margin: const EdgeInsets.only(bottom: 55),
            child: Stack(
              // clipBehavior: Clip.none,
              children: dataStack(),
            ),
          ),
        ),
      ),
    );
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
}
