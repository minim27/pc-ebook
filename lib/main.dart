import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/views/splash_screen_page.dart';

import 'utils/my_colors.dart';
import 'utils/my_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: MyColors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MyColors.white,
          selectedItemColor: MyColors.primary,
          unselectedItemColor: MyColors.disable,
          selectedLabelStyle: TextStyle(
            fontFamily: MyFonts.poppins,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: MyFonts.poppins,
            fontSize: 12,
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreenPage(),
    );
  }
}
