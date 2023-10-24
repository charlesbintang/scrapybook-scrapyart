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
    Colors.orange,
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
      onChanged: updateTextColor, //updateTextColor,
      min: 0.0,
      max: 1.0,
      activeColor: selectedColor,
      inactiveColor: Colors.transparent,
      // inactiveColor: Color.fromARGB(255, 251, 231, 215),
    );
  }

  // setTextColor(Color selectedColor) {
  //   globalListObject[currentIndex].color = selectedColor;
  // }

  // setCurrentIndex(BuildContext context, index) {
  //   setState(() {
  //     currentIndex = index;
  //   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text(
  //         "Selected for Styling",
  //         style: TextStyle(fontSize: 16),
  //       ),
  //     ),
  //   );
  // }

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
    if (textEditingController.text.length > 0) {
      setState(() {
        globalListObject.add(
          StackObject(
            text: textEditingController.text,
            // left: 0,
            // top: 0,
            // color: Colors.black,
            // fontWeight: FontWeight.normal,
            // fontStyle: FontStyle.normal,
            // fontSize: 20,
            // textAlign: TextAlign.left,
            // decoration: TextDecoration.none,
          ),
        );
        Navigator.of(context).pop();
      });
    }
    Navigator.of(context).pop();
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
}
