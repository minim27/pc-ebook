import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/my_images.dart';
import '../../widgets/my_scaffold.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final ssC = Get.put(SplashScreenController());

  @override
  void initState() {
    ssC.animatedSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(child: Image.asset(MyImages.imgPE, scale: 6)),
    );
  }
}
