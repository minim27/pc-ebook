import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_images.dart';

import '../../../utils/my_colors.dart';
import '../../../widgets/my_scaffold.dart';
import '../../controllers/onboarding/onboarding_controller.dart';
import '../../widgets/my_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final onboardC = Get.put(OnboardingController());

  @override
  void initState() {
    onboardC.pageIController = PageController(initialPage: 0);
    onboardC.pageTController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    onboardC.pageIController.dispose();
    onboardC.pageTController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: MyColors.linearHor),
        child: Stack(
          children: [
            OBImage(onboardC: onboardC),
            Positioned(
              bottom: 0,
              child: OBIndicator(onboardC: onboardC),
            ),
            Positioned(
              bottom: 70,
              child: OBText(onboardC: onboardC),
            ),
          ],
        ),
      ),
    );
  }
}

class OBImage extends StatelessWidget {
  const OBImage({
    super.key,
    required this.onboardC,
  });

  final OnboardingController onboardC;

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: onboardC.pageIController,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(40, 0, 40, 30),
          child: Image.asset(MyImages.imgMockHome),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 0, 40, 30),
          child: Image.asset(MyImages.imgMockFav),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 0, 40, 30),
          child: Image.asset(MyImages.imgMockDet),
        ),
      ],
    );
  }
}

class OBIndicator extends StatelessWidget {
  const OBIndicator({
    super.key,
    required this.onboardC,
  });

  final OnboardingController onboardC;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width,
      height: Get.size.height * (40 / 100),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Visibility(
                  visible: onboardC.pageSelected.value > 0,
                  replacement: const SizedBox(width: 50, height: 50),
                  child: GestureDetector(
                    onTap: () => onboardC.back(),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: MyColors.primary),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: MyColors.primary,
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 10,
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => Obx(() => Container(
                      width: (onboardC.pageSelected.value == index) ? 22 : 10,
                      height: (onboardC.pageSelected.value == index) ? 12 : 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: (onboardC.pageSelected.value == index)
                            ? MyColors.primary
                            : MyColors.lightGrey,
                      ),
                    )),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: 3,
                scrollDirection: Axis.horizontal,
              ),
            ),
            GestureDetector(
              onTap: () => onboardC.next(),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: MyColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: MyColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OBText extends StatelessWidget {
  const OBText({
    super.key,
    required this.onboardC,
  });

  final OnboardingController onboardC;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width,
      height: Get.size.height * (26 / 100),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: onboardC.pageTController,
        children: const [
          OBTextContent(
            textSpan: [
              TextSpan(
                text: "Start Your ",
                style: TextStyle(
                  color: MyColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: "Reading Adventure",
                style: TextStyle(
                  color: MyColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            desc:
                "Dive into a world of endless stories and knowledge. Discover new authors, genres, and titles that will captivate your imagination and enrich your mind.",
          ),
          OBTextContent(
            textSpan: [
              TextSpan(
                text: "Effortlessly Bookmark ",
                style: TextStyle(
                  color: MyColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: "Your Favorite Book",
                style: TextStyle(
                  color: MyColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            desc:
                "Keep track of your favorite books with ease. Our simple bookmarking feature ensures you never lose your place or miss out on your top reads.",
          ),
          OBTextContent(
            textSpan: [
              TextSpan(
                text: "Easy Download ",
                style: TextStyle(
                  color: MyColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: "Your Favorite Book",
                style: TextStyle(
                  color: MyColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            desc:
                "Enjoy the convenience of downloading books for offline reading. Access your library anytime, anywhere, without the need for an internet connection.",
          ),
        ],
      ),
    );
  }
}

class OBTextContent extends StatelessWidget {
  const OBTextContent({
    super.key,
    required this.textSpan,
    required this.desc,
  });

  final List<InlineSpan> textSpan;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: textSpan),
          ),
          const SizedBox(height: 16),
          MyText(
            text: desc,
            textAlign: TextAlign.center,
            color: MyColors.grey,
          ),
        ],
      ),
    );
  }
}
