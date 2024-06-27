import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/my_colors.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({
    super.key,
    this.isStack = false,
  });

  final bool? isStack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (isStack == false)
          ? MyColors.white
          : MyColors.white.withOpacity(0.50),
      child: const Center(
        child: SpinKitFadingCircle(color: MyColors.primary),
      ),
    );
  }
}

class MyMoreLoading extends StatelessWidget {
  const MyMoreLoading({
    super.key,
    this.backgroundColor,
  });

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFadingCircle(color: MyColors.primary, size: 30),
    );
  }
}

class MyImageLoading extends StatelessWidget {
  const MyImageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFadingCircle(color: MyColors.primary),
    );
  }
}
