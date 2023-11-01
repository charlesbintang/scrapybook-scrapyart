// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/image_text_model.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/stack_object_model.dart';
import 'package:flutter/cupertino.dart' show CupertinoTextField;
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

abstract class ImageTextController extends ImageTextModel {
  switchMenuItems(String menu) {
    switch (menu) {
      case "text":
        return rowTextMenu();
      case "image":
        return rowImageMenu();
      case "brush":
        return rowBrushMenu();
      default:
        print("tidak ada list view yang ditampilkan");
    }
  }

  SizedBox rowImageMenu() {
    List<Widget> data = [];
    data.addAll([
      IconButton(
        onPressed: () => pickImageFromGallery(),
        icon: const Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.black,
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
    ]);
    if (assetFiles.isNotEmpty) {
      for (var i = 0; i < assetFiles.length; i++) {
        data.add(
          IconButton(
            onPressed: () {
              // print("asset ke $i");
              globalListObject.add(
                StackObject(
                  /// pickImageFromGallery harus menyertakan image didalamnya
                  assetImage: assetFiles[i],
                ),
              );
              isImageAdded = ActionCallback.imageAdded;
              setState(() {});
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
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: data,
      ),
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
              color: isTextAdded == ActionCallback.textAdded
                  ? isButtonClicked == ActionCallback.isButtonClicked
                      ? globalListObject[currentIndex].color
                      : Colors.black45
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
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: IconButton(
            onPressed: deleteAllTexts,
            icon: Icon(
              Icons.delete,
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

  Row rowBrushMenu() {
    return Row(
      children: [
        const Expanded(
          child: SizedBox(),
        ),
        IconButton(
          onPressed: () {
            if (isButtonBrushClicked == ActionCallback.none) {
              isButtonBrushClicked = ActionCallback.isButtonClicked;
            } else {
              isButtonBrushClicked = ActionCallback.none;
            }
            setState(() {});
          },
          icon: Icon(
            Icons.brush,
            color: isButtonBrushClicked == ActionCallback.isButtonClicked
                ? Colors.black
                : Colors.black45,
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }

  Row menusButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AbsorbPointer(
          absorbing: isObjectAdded(),
          child: IconButton(
            iconSize: 25,
            icon: Icon(
              Icons.save_alt,
              color: isObjectAdded() == false ? Colors.white : Colors.white30,
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
        AbsorbPointer(
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.format_paint_outlined,
              color: Colors.white30,
            ),
            onPressed: () {},
          ),
        ),
        AbsorbPointer(
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.square_outlined,
              color: Colors.white30,
            ),
            onPressed: () {},
          ),
        ),
        IconButton(
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
        IconButton(
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
        IconButton(
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
        AbsorbPointer(
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.face_retouching_natural_rounded,
              color: Colors.white30,
            ),
            onPressed: () {},
          ),
        ),
        AbsorbPointer(
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.layers,
              color: Colors.white30,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
