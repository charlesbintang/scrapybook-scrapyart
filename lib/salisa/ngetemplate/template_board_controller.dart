// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/stack_object_model.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:scrapyart_home/salisa/ngetemplate/template_board_model.dart';

abstract class TemplateBoardController extends TemplateBoardModel {
  Row menusButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AbsorbPointer(
          absorbing: isObjectEmpty(),
          child: IconButton(
            iconSize: 25,
            icon: Icon(
              Icons.save_alt,
              color: isGlobalListObjectEmpty ? Colors.white30 : Colors.green,
            ),
            onPressed: () {
              for (var i = 0; i < globalListObject.length; i++) {
                globalListObject[i].onClicked = OnAction.isFalse;
                setState(() {});
              }
              saveToGallery(context);
            },
          ),
        ),
        Container(
          // color: Colors.amber,
          decoration: menu == "image"
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color.fromARGB(255, 72, 30, 51),
                )
              : null,
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.photo,
            ),
            onPressed: () {
              setState(() {
                menu = "image";
              });
            },
          ),
        ),
        Container(
          decoration: menu == "text"
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color.fromARGB(255, 72, 30, 51),
                )
              : null,
          child: IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.text_fields_rounded,
            ),
            onPressed: () {
              setState(() {
                menu = "text";
              });
            },
          ),
        ),
        Container(
          decoration: menu == "brush"
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color.fromARGB(255, 72, 30, 51),
                )
              : null,
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.brush_rounded,
            ),
            onPressed: () {
              setState(() {
                menu = "brush";
              });
            },
          ),
        ),
        // Stiker
        Container(
          decoration: menu == "stiker"
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color.fromARGB(255, 72, 30, 51),
                )
              : null,
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.face_retouching_natural_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                menu = "stiker";
              });
            },
          ),
        ),
        AbsorbPointer(
          absorbing: isGlobalListObjectEmpty,
          child: IconButton(
            iconSize: 25,
            icon: Icon(
              Icons.undo,
              color: isGlobalListObjectEmpty ? Colors.white30 : Colors.white,
            ),
            onPressed: undoObject,
          ),
        ),
        AbsorbPointer(
          absorbing: isEndOfHistoryGlobalListObject,
          child: IconButton(
            iconSize: 25,
            icon: Icon(
              Icons.redo,
              color: isEndOfHistoryGlobalListObject
                  ? Colors.white30
                  : Colors.white,
            ),
            onPressed: redoObject,
          ),
        ),
      ],
    );
  }

  switchMenuItems(String menu) {
    switch (menu) {
      // case "wallpaper":
      //   return rowWallpaperMenu();
      case "image":
        return rowImageMenu();
      case "text":
        return rowTextMenu();
      case "brush":
        return rowBrushMenu();
      case "stiker":
        return rowStikerMenu();
      default:
        print("tidak ada list view yang ditampilkan");
    }
  }

  Row rowImageMenu() {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        AbsorbPointer(
          absorbing: placeholderTotal > 0 ? false : true,
          child: IconButton(
            onPressed: () {
              if (placeholderTotal > 0) {
                pickImageFromGallery();
              }
              placeholderTotal--;
            }, //=> pickImageFromGallery(),
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              color: placeholderTotal > 0 ? Colors.black : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isImageAdded == ActionCallback.imageAdded ? false : true,
          child: IconButton(
            onPressed: deleteAllImages,
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

  Row rowTextMenu() {
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
                          hexInputController: textColorController, // <- here
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
                            controller: textColorController,
                            // Everything below is purely optional.
                            prefix: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(Icons.tag)),
                            suffix: IconButton(
                              icon: const Icon(Icons.content_paste_rounded),
                              onPressed: () =>
                                  copyToClipboard(textColorController.text),
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
              color: isTextAdded == ActionCallback.textAdded &&
                      isButtonClicked == ActionCallback.isButtonClicked
                  ? globalListObject[currentIndex].color
                  : Colors.black45,
              shadows: [
                Shadow(
                  color: isTextAdded == ActionCallback.textAdded &&
                          isButtonClicked == ActionCallback.isButtonClicked
                      ? Colors.black
                      : Colors.white,
                  blurRadius: 5.0,
                  offset: Offset.zero,
                )
              ],
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded &&
                  isButtonClicked == ActionCallback.isButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: increaseFontSize,
            icon: Icon(
              Icons.text_increase_rounded,
              color: isTextAdded == ActionCallback.textAdded &&
                      isButtonClicked == ActionCallback.isButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded &&
                  isButtonClicked == ActionCallback.isButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: decreaseFontSize,
            icon: Icon(
              Icons.text_decrease_rounded,
              color: isTextAdded == ActionCallback.textAdded &&
                      isButtonClicked == ActionCallback.isButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded &&
                  isButtonClicked == ActionCallback.isButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: boldText,
            icon: Icon(
              Icons.format_bold_rounded,
              color: isTextAdded == ActionCallback.textAdded &&
                      isButtonClicked == ActionCallback.isButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded &&
                  isButtonClicked == ActionCallback.isButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: italicText,
            icon: Icon(
              Icons.format_italic_rounded,
              color: isTextAdded == ActionCallback.textAdded &&
                      isButtonClicked == ActionCallback.isButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded &&
                  isButtonClicked == ActionCallback.isButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: underlineText,
            icon: Icon(
              Icons.format_underline_rounded,
              color: isTextAdded == ActionCallback.textAdded &&
                      isButtonClicked == ActionCallback.isButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded &&
                  isButtonClicked == ActionCallback.isButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: deleteAllTexts,
            icon: Icon(
              Icons.delete,
              color: isTextAdded == ActionCallback.textAdded &&
                      isButtonClicked == ActionCallback.isButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Row rowBrushMenu() {
    return Row(
      children: [
        const Expanded(
          child: SizedBox(),
        ),

        /// brush on/off
        Container(
          decoration: isButtonClicked == ActionCallback.isBrushButtonClicked
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(23.0),
                  color: const Color(0xFF684500))
              : null,
          child: IconButton(
            onPressed: () {
              if (isButtonClicked == ActionCallback.none) {
                isButtonClicked = ActionCallback.isBrushButtonClicked;
              } else {
                isButtonClicked = ActionCallback.none;
              }
              setState(() {});
            },
            icon: Icon(
              Icons.brush,
              color: isButtonClicked == ActionCallback.isBrushButtonClicked
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),

        /// select color
        AbsorbPointer(
          absorbing: isButtonClicked == ActionCallback.isBrushButtonClicked
              ? false
              : true,
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
                          pickerColor: brushColor,
                          onColorChanged: changeBrushColor,
                          colorPickerWidth: 300,
                          pickerAreaHeightPercent: 0.7,
                          displayThumbColor: true,
                          paletteType: PaletteType.hsl,
                          labelTypes: const [],
                          pickerAreaBorderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                          hexInputController: textColorController, // <- here
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
                            controller: textColorController,
                            // Everything below is purely optional.
                            prefix: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(Icons.tag)),
                            suffix: IconButton(
                              icon: const Icon(Icons.content_paste_rounded),
                              onPressed: () =>
                                  copyToClipboard(textColorController.text),
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
              color: isButtonClicked == ActionCallback.isBrushButtonClicked
                  ? brushColor
                  : brushColor.withOpacity(0.6),
              shadows: [
                Shadow(
                  color: isButtonClicked == ActionCallback.isBrushButtonClicked
                      ? Colors.black
                      : Colors.transparent,
                  blurRadius: 5.0,
                  offset: Offset.zero,
                )
              ],
            ),
          ),
        ),

        /// increase brush stroke width
        AbsorbPointer(
          absorbing: isButtonClicked == ActionCallback.isBrushButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: () => increaseBrushStrokeWidth(context),
            icon: Icon(
              Icons.plus_one,
              color: isButtonClicked == ActionCallback.isBrushButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),

        /// decrease brush stroke width
        AbsorbPointer(
          absorbing: isButtonClicked == ActionCallback.isBrushButtonClicked
              ? false
              : true,
          child: IconButton(
            onPressed: () => decreaseBrushStrokeWidth(context),
            icon: Icon(
              Icons.exposure_neg_1,
              color: isButtonClicked == ActionCallback.isBrushButtonClicked
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),

        /// delete all paint
        AbsorbPointer(
          absorbing: isPaintAdded == ActionCallback.paintAdded ? false : true,
          child: IconButton(
            onPressed: deleteAllPaint,
            icon: Icon(
              Icons.delete,
              color: isPaintAdded == ActionCallback.paintAdded
                  ? Colors.black
                  : Colors.black45,
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }

  SizedBox rowStikerMenu() {
    List<Widget> data = [];
    // pindahkan semua stiker ke tombol stiker
    data.add(AbsorbPointer(
      absorbing: isStickerAdded == ActionCallback.stickerAdded ? false : true,
      child: IconButton(
        onPressed: deleteAllSticker,
        icon: Icon(
          Icons.delete,
          color: isStickerAdded == ActionCallback.stickerAdded
              ? Colors.black
              : Colors.black45,
        ),
      ),
    ));
    if (assetFiles.isNotEmpty) {
      allAsset(data);
    }
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: data,
      ),
    );
  }
}
