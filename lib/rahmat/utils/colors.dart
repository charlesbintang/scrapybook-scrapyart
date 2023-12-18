import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFF7F4F2),
  100: Color(0xFFEBE4DF),
  200: Color(0xFFDDD3C9),
  300: Color(0xFFCFC1B3),
  400: Color(0xFFC5B3A3),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFFB59E8B),
  700: Color(0xFFAC9580),
  800: Color(0xFFA48B76),
  900: Color(0xFF967B64),
});
const int _primaryPrimaryValue = 0xFFBBA693;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFFFFCCA2),
  700: Color(0xFFFFBE89),
});
const int _primaryAccentValue = 0xFFFFE8D5;
