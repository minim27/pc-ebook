import 'package:flutter/material.dart';

import '../utils/my_colors.dart';
import '../utils/my_fonts.dart';
import '../utils/my_icons.dart';

class MyTextFormFieldSearch extends StatelessWidget {
  const MyTextFormFieldSearch({
    super.key,
    this.controller,
    this.autofocus = false,
    required this.hintText,
    this.onFieldSubmitted,
    this.onChanged,
  });

  final TextEditingController? controller;
  final bool? autofocus;
  final String hintText;
  final ValueChanged<String>? onFieldSubmitted, onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MyColors.lightGrey),
      ),
      child: TextFormField(
        controller: controller!,
        autofocus: autofocus!,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        cursorColor: MyColors.primary,
        style: const TextStyle(
          fontSize: 12,
          color: MyColors.black,
          fontFamily: MyFonts.poppins,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 14, top: 5),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: MyColors.grey,
            fontFamily: MyFonts.poppins,
          ),
          suffixIcon: (controller!.text != "")
              ? GestureDetector(
                  onTap: () => controller!.text == "",
                  child: const Icon(
                    Icons.cancel_rounded,
                    size: 22,
                    color: MyColors.grey,
                  ),
                )
              : Image.asset(MyIcons.icSearch, scale: 4),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}
