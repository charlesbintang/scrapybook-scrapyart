// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/default_button.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/image_text_model.dart';
import 'package:scrapyart_home/angel/stack_object_model.dart';
// import 'package:scrapyart_home/angel/text_info.dart';

enum ActionCallback {
  none,
  imageAdded,
  textAdded,
}

abstract class ImageTextController extends ImageTextModel {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();

  ActionCallback isTextAdded = ActionCallback.none;
  double _sliderValue = 0.0;

  final List<Color> _colorOptions = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.redAccent,
    Colors.orange,
    Colors.white,
    Colors.amber,
    Colors.brown,
  ];

  void updateTextColor(double value) {
    setState(() {
      _sliderValue = value;
      int colorIndex = (_sliderValue * (_colorOptions.length - 1)).round();
      selectedColor = _colorOptions[colorIndex];
    });
    globalListObject[currentIndex].color = selectedColor;
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
    globalListObject.removeWhere((element) => element.image == null);
    setState(() {});
  }

  switchMenuItems(String menu) {
    Widget returnedRowItems = Container();
    switch (menu) {
      case "texts":
        returnedRowItems = columRowTextsMenu();
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
        IconButton(
          onPressed: () => deleteAllImage,
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Column columRowTextsMenu() {
    return Column(
      children: [
        AbsorbPointer(
          absorbing: isTextAdded == ActionCallback.textAdded ? false : true,
          child: Slider(
            value: _sliderValue,
            onChanged: updateTextColor,
            min: 0.0,
            max: 1.0,
            activeColor: isTextAdded == ActionCallback.textAdded
                ? selectedColor
                : Colors.black45,
            inactiveColor: Colors.transparent,
          ),
        ),
        Row(
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
                  setState(() {});
                },
                icon: Icon(
                  Icons.rectangle_rounded,
                  color: isTextAdded == ActionCallback.textAdded
                      ? selectedColor
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
        ),
      ],
    );
  }
}
