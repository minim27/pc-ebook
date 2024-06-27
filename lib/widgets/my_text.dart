import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';

class MyText extends StatelessWidget {
  const MyText({
    super.key,
    required this.text,
    this.color = MyColors.black,
    this.textAlign,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontStyle,
  });

  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        overflow: overflow,
        color: color,
        fontFamily: MyFonts.poppins,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
        fontStyle: fontStyle,
      ),
    );
  }
}
