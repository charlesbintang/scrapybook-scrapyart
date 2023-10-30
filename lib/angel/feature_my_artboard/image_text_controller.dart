// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/image_text_model.dart';
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
        IconButton(
          onPressed: () {},
          icon: Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage("lib/assets/google_logo.png"),
              ),
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
        AbsorbPointer(
          child: IconButton(
            iconSize: 25,
            icon: const Icon(
              Icons.brush_rounded,
              color: Colors.white30,
            ),
            onPressed: () {},
          ),
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
