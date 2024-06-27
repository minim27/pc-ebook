import 'package:flutter/material.dart';

class MyColors {
  static const Color primary = Color(0xFF0fb6b9);

  static const Color grey = Color(0xFFa5a5a5);
  static const Color grey2 = Color.fromARGB(255, 220, 220, 220);
  static const Color lightGrey = Color(0xFFe3e2e8);
  static const Color lightGrey2 = Color.fromARGB(255, 245, 245, 245);

  static const Color disable = Color(0xFFbababa);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFD0061A);
  static const Color white = Color(0xFFffffff);

  static const List<Color> linear = [grey2, lightGrey2];

  static const Gradient disLinear = LinearGradient(colors: [grey, grey]);

  static const Gradient linearHor = LinearGradient(colors: MyColors.linear);

  static const Gradient linearVer = LinearGradient(
    colors: MyColors.linear,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
