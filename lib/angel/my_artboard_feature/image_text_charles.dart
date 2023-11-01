import 'package:flutter/material.dart';
import 'package:scrapyart_home/angel/my_artboard_feature/stack_object_model.dart';

class ImageTextCharles extends StatelessWidget {
  final StackObject stackObject;
  const ImageTextCharles({
    Key? key,
    required this.stackObject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      stackObject.text,
      style: TextStyle(
        fontSize: stackObject.fontSize,
        fontWeight: stackObject.fontWeight,
        fontStyle: stackObject.fontStyle,
        color: stackObject.color,
        decoration: stackObject.decoration,
        decorationColor: stackObject.color,
      ),
    );
  }
}
