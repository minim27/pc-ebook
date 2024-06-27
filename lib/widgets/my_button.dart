import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import 'my_text.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.padding,
    this.isDisabled = false,
    required this.text,
    this.width,
    this.height = 46,
    this.fontSize,
    this.color = MyColors.primary,
    this.fontWeight = FontWeight.w600,
    this.textColor = MyColors.white,
    required this.onTap,
  });

  final EdgeInsetsGeometry? padding;
  final bool? isDisabled;
  final String text;
  final double? width, height, fontSize;
  final Color? color, textColor;
  final FontWeight? fontWeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isDisabled!) ? () {} : onTap,
      child: Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: (isDisabled!) ? MyColors.lightGrey : color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: MyText(
            color: textColor,
            text: text,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
