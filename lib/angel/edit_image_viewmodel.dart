import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/default_button.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/my_artboard.dart';
import 'package:scrapyart_home/angel/text_info.dart';

abstract class EditImageViewModel extends State<MyArtboard> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  List<TextInfo> texts = [];
  int currentIndex = 0;
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
  Color selectedColor = Colors.black; // Warna awal

  void updateTextColor(double value) {
    setState(() {
      _sliderValue = value;
      int colorIndex = (_sliderValue * (_colorOptions.length - 1)).round();
      selectedColor = _colorOptions[colorIndex];
    });
    texts[currentIndex].color = selectedColor;
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
  //   texts[currentIndex].color = selectedColor;
  // }

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

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize = texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize = texts[currentIndex].fontSize -= 2;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  underlineText() {
    setState(() {
      if (texts[currentIndex].decoration == TextDecoration.underline) {
        texts[currentIndex].decoration = TextDecoration.none;
      } else {
        texts[currentIndex].decoration = TextDecoration.underline;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addNewsText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
          decoration: TextDecoration.none,
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
              color: Colors.white,
              textcolor: Colors.black),
          DefaultButton(
              onPressed: () => addNewsText(context),
              child: const Text('Add Text'),
              color: const Color.fromARGB(255, 122, 74, 37),
              textcolor: Colors.white)
        ],
      ),
    );
  }
}
