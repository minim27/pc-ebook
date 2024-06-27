import 'package:flutter/material.dart';

import '../utils/my_colors.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    super.key,
    this.backgroundColor = MyColors.white,
    this.appBar,
    this.extendBodyBehindAppBar = false,
    this.drawer,
    this.endDrawer,
    this.drawerEnableOpenDragGesture = true,
    this.body,
    this.bottomNavigationBar,
  });

  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? body, bottomNavigationBar, drawer, endDrawer;
  final bool drawerEnableOpenDragGesture;
  final bool? extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: key,
        extendBodyBehindAppBar: extendBodyBehindAppBar!,
        appBar: appBar,
        backgroundColor: backgroundColor,
        drawer: drawer,
        endDrawer: endDrawer,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
