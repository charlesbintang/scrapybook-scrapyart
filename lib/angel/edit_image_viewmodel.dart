import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/default_button.dart';
import 'package:scrapyart_home/angel/feature_my_artboard/my_artboard.dart';
import 'package:scrapyart_home/angel/text_info.dart';

abstract class EditImageViewModel extends State<MyArtboard> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  List<TextInfo> texts = [];

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
            textAlign: TextAlign.left),
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
