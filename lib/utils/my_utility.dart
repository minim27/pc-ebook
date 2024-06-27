import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyUtility {
  static String formatWithDotSeparator({required int number}) {
    final NumberFormat numberFormat = NumberFormat('#,##0', 'en_US');
    return numberFormat.format(number).replaceAll(',', '.');
  }

  static String formatNumberWithSuffix({required int number}) {
    if (number >= 1000 && number < 1000000) {
      double value = number / 1000;
      return '${value.toStringAsFixed(1)}K';
    } else if (number >= 1000000 && number < 1000000000) {
      double value = number / 1000000;
      return '${value.toStringAsFixed(1)}M';
    } else if (number >= 1000000000) {
      double value = number / 1000000000;
      return '${value.toStringAsFixed(1)}B';
    }
    return NumberFormat.decimalPattern().format(number);
  }

  static Future showMyDialog({
    bool? barrierDismissible,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
  }) async =>
      await showAdaptiveDialog(
        barrierDismissible: barrierDismissible,
        context: Get.context!,
        builder: (context) => AlertDialog.adaptive(
          title: title,
          content: content,
          actions: actions,
        ),
      );

  static myAdaptiveAction(
      {required Widget child, required VoidCallback onPressed}) {
    final ThemeData theme = Theme.of(Get.context!);

    switch (theme.platform) {
      case TargetPlatform.android:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }
}
