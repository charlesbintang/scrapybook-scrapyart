// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/default_button.dart';
// import 'package:scrapyart_home/angel/text_info.dart';
import 'package:scrapyart_home/charles/my_artboard_charles.dart';
import 'package:scrapyart_home/charles/stack_object_model.dart';

abstract class EditImageViewModelCharles extends MyArtboardCharles {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  // List<TextInfo> globalListObject = [];
  // int currentIndex = 0;
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
  // Color selectedColor = Colors.black; // Warna awal

  void updateTextColor(double value) {
    setState(() {
      _sliderValue = value;
      int colorIndex = (_sliderValue * (_colorOptions.length - 1)).round();
      selectedColor = _colorOptions[colorIndex];
    });
    globalListObject[currentIndex].color = selectedColor;
  }

  Slider colorSlider() {
    return Slider(
      value: _sliderValue,
      onChanged: updateTextColor,
      min: 0.0,
      max: 1.0,
      activeColor: selectedColor,
      inactiveColor: Colors.transparent,
    );
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
    // ignore: prefer_is_empty
    setState(() {
      globalListObject.add(
        StackObject(
          text: textEditingController.text,
        ),
      );
      Navigator.of(context).pop();
    });
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
        actions: <Widget>[
          DefaultButton(
              onPressed: () {}, //=> Navigator.of(context).pop(),
              color: Colors.white,
              textcolor: Colors.black,
              child: const Text('Back')),
          DefaultButton(
              onPressed: textEditingController.text.isEmpty
                  ? () => addNewsText(context)
                  : () => addNewsText(context),
              color: const Color.fromARGB(255, 122, 74, 37),
              textcolor: Colors.white,
              child: const Text('Add Text'))
        ],
      ),
    );
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
          onPressed: () {
            for (var i = 0; i < globalListObject.length; i++) {
              globalListObject[i].image = null;
            }
            globalListObject.removeWhere((element) => element.image == null);
            setState(() {});
          },
          icon: const Icon(Icons.delete, color: Colors.black),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Column columRowTextsMenu() {
    return Column(
      children: [
        colorSlider(),
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
            IconButton(
              onPressed: increaseFontSize,
              icon: const Icon(
                Icons.text_increase_rounded,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: decreaseFontSize,
              icon: const Icon(
                Icons.text_decrease_rounded,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: boldText,
              icon: const Icon(
                Icons.format_bold_rounded,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: italicText,
              icon: const Icon(
                Icons.format_italic_rounded,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: underlineText,
              icon: const Icon(
                Icons.format_underline_rounded,
                color: Colors.black,
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  switchListView(String menu) {
    ListView returnedListView = ListView();
    switch (menu) {
      case "texts":
        returnedListView = textsMenu();
        break;
      case "images":
        returnedListView = imagesMenu();
        break;
      default:
        print("tidak ada list view yang ditampilkan");
    }
    return returnedListView;
  }

  ListView imagesMenu() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
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
          onPressed: () {
            for (var i = 0; i < globalListObject.length; i++) {
              globalListObject[i].image = null;
            }
            globalListObject.removeWhere((element) => element.image == null);
            setState(() {});
          },
          icon: const Icon(Icons.delete, color: Colors.black),
        ),
      ],
    );
  }

  ListView textsMenu() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        IconButton(
          onPressed: () => addNewDialog(context),
          icon: const Icon(
            Icons.add_rounded,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: increaseFontSize,
          icon: const Icon(
            Icons.text_increase_rounded,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: decreaseFontSize,
          icon: const Icon(
            Icons.text_decrease_rounded,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: boldText,
          icon: const Icon(
            Icons.format_bold_rounded,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: italicText,
          icon: const Icon(
            Icons.format_italic_rounded,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: underlineText,
          icon: const Icon(
            Icons.format_underline_rounded,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
