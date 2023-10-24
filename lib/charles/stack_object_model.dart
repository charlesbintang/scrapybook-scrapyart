import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

enum OnAction { isFalse, isClicked, isScaling, isRounded }

class StackObject {
  File? image;
  CroppedFile? croppedFile;
  double top;
  double left;
  double imageWidth;
  double imageHeight;
  double boxRoundValue;
  double rotateValue;
  OnAction onClicked;
  OnAction onScaling;
  OnAction boxRound;
  String text;
  Color color;
  FontWeight fontWeight;
  FontStyle fontStyle;
  double fontSize;
  TextDecoration decoration;

  StackObject({
    this.image,
    this.croppedFile,
    this.top = 0.0,
    this.left = 0.0,
    this.boxRoundValue = 15.0,
    this.imageWidth = 200.0,
    this.imageHeight = 200.0,
    this.rotateValue = 0.0,
    this.onClicked = OnAction.isFalse,
    this.onScaling = OnAction.isFalse,
    this.boxRound = OnAction.isFalse,
    this.text = "",
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 20,
    this.decoration = TextDecoration.none,
  });
}

// fontStyle: FontStyle.normal,
//           fontSize: 20,
//           textAlign: TextAlign.left,
//           decoration: TextDecoration.none,

// class TextInfo {
//   String text;
//   double left;
//   double top;
//   Color color;
//   FontWeight fontWeight;
//   FontStyle fontStyle;
//   double fontSize;
//   TextAlign textAlign;
//   TextDecoration decoration;

//   TextInfo({
//     required this.text,
//     required this.left,
//     required this.top,
//     required this.color,
//     required this.fontWeight,
//     required this.fontStyle,
//     required this.fontSize,
//     required this.textAlign,
//     required this.decoration,
//   });
// }
