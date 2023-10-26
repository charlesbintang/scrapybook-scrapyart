// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/image_text_model.dart';
import 'package:scrapyart_home/angel/image_text_charles.dart';
import 'package:scrapyart_home/angel/stack_object_model.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

abstract class ImageTextController extends ImageTextModel {
  switchMenuItems(String menu) {
    Widget returnedRowItems = Container();
    switch (menu) {
      case "texts":
        returnedRowItems = rowTextsMenu();
        break;
      case "images":
        returnedRowItems = rowImagesMenu();
        break;
      default:
        print("tidak ada list view yang ditampilkan");
    }
    return returnedRowItems;
  }

  Row rowImagesMenu() {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () => pickImageFromGallery(),
          icon: const Icon(
            Icons.add_a_photo,
            color: Colors.black,
          ),
        ),
        // IconButton(
        //   onPressed: () {
        // TODO : hapus gambar yang telah dipilih
        //     }
        //   },
        //   icon: const Icon(Icons.hide_image),
        // ),
        AbsorbPointer(
          absorbing: isImageAdded == ActionCallback.imageAdded ? false : true,
          child: IconButton(
            onPressed: deleteAllImage,
            icon: Icon(
              Icons.delete,
              color: isImageAdded == ActionCallback.imageAdded
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Row rowTextsMenu() {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () => addNewDialog(context),
          icon: const Icon(
            Icons.add_rounded,
            color: Colors.black,
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    titlePadding: const EdgeInsets.all(0),
                    contentPadding: const EdgeInsets.all(0),
                    content: Column(
                      children: [
                        ColorPicker(
                          pickerColor: globalListObject[currentIndex].color,
                          onColorChanged: changeColor,
                          colorPickerWidth: 300,
                          pickerAreaHeightPercent: 0.7,
                          displayThumbColor: true,
                          paletteType: PaletteType.hsl,
                          labelTypes: const [],
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                          hexInputController: textController, // <- here
                          portraitOnly: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          /* It can be any text field, for example:

                            * TextField
                            * TextFormField
                            * CupertinoTextField
                            * EditableText
                            * any text field from 3-rd party package
                            * your own text field

                            so basically anything that supports/uses
                            a TextEditingController for an editable text.
                            */
                          child: CupertinoTextField(
                            controller: textController,
                            // Everything below is purely optional.
                            prefix: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(Icons.tag)),
                            suffix: IconButton(
                              icon: const Icon(Icons.content_paste_rounded),
                              onPressed: () =>
                                  copyToClipboard(textController.text),
                            ),
                            autofocus: true,
                            maxLength: 9,
                            onEditingComplete: () =>
                                Navigator.of(context).pop(),
                            inputFormatters: [
                              // Any custom input formatter can be passed
                              // here or use any Form validator you want.
                              UpperCaseTextFormatter(),
                              FilteringTextInputFormatter.allow(
                                  RegExp(kValidHexPattern)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.rectangle_rounded,
              color: isTextAdded == ActionCallback.textAdded
                  ? globalListObject[currentIndex].color
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: IconButton(
            onPressed: increaseFontSize,
            icon: Icon(
              Icons.text_increase_rounded,
              color: isTextAdded == ActionCallback.textAdded
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: IconButton(
            onPressed: decreaseFontSize,
            icon: Icon(
              Icons.text_decrease_rounded,
              color: isTextAdded == ActionCallback.textAdded
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: IconButton(
            onPressed: boldText,
            icon: Icon(
              Icons.format_bold_rounded,
              color: isTextAdded == ActionCallback.textAdded
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: IconButton(
            onPressed: italicText,
            icon: Icon(
              Icons.format_italic_rounded,
              color: isTextAdded == ActionCallback.textAdded
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: IconButton(
            onPressed: underlineText,
            icon: Icon(
              Icons.format_underline_rounded,
              color: isTextAdded == ActionCallback.textAdded
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Row menusButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.save_alt,
          ),
          onPressed: () => saveToGallery(context),
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.format_paint_outlined,
            color: Colors.white30,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.square_outlined,
            color: Colors.white30,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.photo,
          ),
          onPressed: () {
            setState(() {
              menu = "images";
            });
          },
        ),
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.text_fields_rounded,
          ),
          onPressed: () {
            setState(() {
              menu = "texts";
            });
          },
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.brush_rounded,
            color: Colors.white30,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.face_retouching_natural_rounded,
            color: Colors.white30,
          ),
          onPressed: () {},
        ),
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.layers,
            color: Colors.white30,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  // Column rowTextsMenu() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       // AbsorbPointer(
  //       //   absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
  //       //   child: Slider(
  //       //     value: sliderValue,
  //       //     onChanged: updateTextColor,
  //       //     min: 0.0,
  //       //     max: 1.0,
  //       //     activeColor: isTextAdded == ActionCallback.textAdded
  //       //         ? selectedColor
  //       //         : Colors.black45,
  //       //     inactiveColor: Colors.transparent,
  //       //   ),
  //       // ),
  //       Row(
  //         children: [
  //           const Expanded(child: SizedBox()),
  //           IconButton(
  //             onPressed: () => addNewDialog(context),
  //             icon: const Icon(
  //               Icons.add_rounded,
  //               color: Colors.black,
  //             ),
  //           ),
  //           AbsorbPointer(
  //             absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
  //             child: IconButton(
  //               onPressed: () {
  //                 setState(() {});
  //               },
  //               icon: Icon(
  //                 Icons.rectangle_rounded,
  //                 color: isTextAdded == ActionCallback.textAdded
  //                     ? selectedColor
  //                     : Colors.black45,
  //               ),
  //             ),
  //           ),
  //           AbsorbPointer(
  //             absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
  //             child: IconButton(
  //               onPressed: increaseFontSize,
  //               icon: Icon(
  //                 Icons.text_increase_rounded,
  //                 color: isTextAdded == ActionCallback.textAdded
  //                     ? Colors.black
  //                     : Colors.black45,
  //               ),
  //             ),
  //           ),
  //           AbsorbPointer(
  //             absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
  //             child: IconButton(
  //               onPressed: decreaseFontSize,
  //               icon: Icon(
  //                 Icons.text_decrease_rounded,
  //                 color: isTextAdded == ActionCallback.textAdded
  //                     ? Colors.black
  //                     : Colors.black45,
  //               ),
  //             ),
  //           ),
  //           AbsorbPointer(
  //             absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
  //             child: IconButton(
  //               onPressed: boldText,
  //               icon: Icon(
  //                 Icons.format_bold_rounded,
  //                 color: isTextAdded == ActionCallback.textAdded
  //                     ? Colors.black
  //                     : Colors.black45,
  //               ),
  //             ),
  //           ),
  //           AbsorbPointer(
  //             absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
  //             child: IconButton(
  //               onPressed: italicText,
  //               icon: Icon(
  //                 Icons.format_italic_rounded,
  //                 color: isTextAdded == ActionCallback.textAdded
  //                     ? Colors.black
  //                     : Colors.black45,
  //               ),
  //             ),
  //           ),
  //           AbsorbPointer(
  //             absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
  //             child: IconButton(
  //               onPressed: underlineText,
  //               icon: Icon(
  //                 Icons.format_underline_rounded,
  //                 color: isTextAdded == ActionCallback.textAdded
  //                     ? Colors.black
  //                     : Colors.black45,
  //               ),
  //             ),
  //           ),
  //           const Expanded(child: SizedBox()),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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
