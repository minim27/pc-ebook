import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/controllers/home/home_controller.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_colors.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_icons.dart';
import 'package:pc_book_dika_desandra_ardiansyah/widgets/my_text.dart';

import '../../controllers/favorite/favorite_controller.dart';
import '../../widgets/my_content.dart';
import '../../widgets/my_loading.dart';
import '../../widgets/my_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeC = Get.put(HomeController());
  final favC = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          const SizedBox(height: 34),
          Header(homeC: homeC),
          const SizedBox(height: 32),
          HomeTC(homeC: homeC),
          const SizedBox(height: 32),
          HomeRFY(homeC: homeC, favC: favC),
          const SizedBox(height: 32),
          HomeHistories(homeC: homeC, favC: favC),
          const SizedBox(height: 32),
          HomeOther(homeC: homeC, favC: favC),
        ],
      ),
    );
  }
}

class HomeOther extends StatelessWidget {
  const HomeOther({
    super.key,
    required this.homeC,
    required this.favC,
  });

  final HomeController homeC;
  final FavoriteController favC;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                text: "Others",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    homeC.openBookPage().then((value) => homeC.checkHist()),
                child: const MyText(text: "See all", color: MyColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (homeC.isLoadingOther.value) {
              return const MyLoading();
            } else {
              return GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                  childAspectRatio: 0.44,
                ),
                itemCount:
                    (homeC.resOthers.length > 8) ? 8 : homeC.resOthers.length,
                itemBuilder: (context, index) => MyContent(
                  isFav: homeC.resOthers[index].favorite,
                  mediaType: homeC.resOthers[index].mediaType,
                  formats: homeC.resOthers[index].formats,
                  title: homeC.resOthers[index].title,
                  authors: homeC.resOthers[index].authors,
                  downloadCount: homeC.resOthers[index].downloadCount,
                  onTap: () => homeC
                      .openBookDetail(id: homeC.resOthers[index].id)
                      .then((value) => homeC.checkHist()),
                  onFav: () => homeC.setFavorite(
                      favC: favC, res: homeC.resOthers[index]),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}

class HomeHistories extends StatelessWidget {
  const HomeHistories({
    super.key,
    required this.homeC,
    required this.favC,
  });

  final HomeController homeC;
  final FavoriteController favC;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                text: "Your history",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => homeC
                    .openBookPage(valIds: homeC.ids.value)
                    .then((value) => homeC.checkHist()),
                child: const MyText(text: "See all", color: MyColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (homeC.isLoadingHis.value) {
            return const MyLoading();
          } else {
            return (homeC.resHis.isEmpty)
                ? const SizedBox(
                    height: 60,
                    child: Center(
                      child: MyText(
                        text: "- You don't have any history -",
                        color: MyColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : SizedBox(
                    width: Get.size.width,
                    height: 370,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          (homeC.resHis.length > 3) ? 3 : homeC.resHis.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      itemBuilder: (context, index) => MyContent(
                        isFav: homeC.resHis[index].favorite,
                        mediaType: homeC.resHis[index].mediaType,
                        formats: homeC.resHis[index].formats,
                        title: homeC.resHis[index].title,
                        authors: homeC.resHis[index].authors,
                        downloadCount: homeC.resHis[index].downloadCount,
                        onTap: () => homeC
                            .openBookDetail(id: homeC.resHis[index].id)
                            .then((value) => homeC.checkHist()),
                        onFav: () => homeC.setFavorite(
                            favC: favC, res: homeC.resHis[index]),
                      ),
                    ),
                  );
          }
        })
      ],
    );
  }
}

class HomeRFY extends StatelessWidget {
  const HomeRFY({
    super.key,
    required this.homeC,
    required this.favC,
  });

  final HomeController homeC;
  final FavoriteController favC;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyText(
                text: "Recommended for you",
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => homeC
                    .openBookPage(valTopic: homeC.topic.value)
                    .then((value) => homeC.checkHist()),
                child: const MyText(text: "See all", color: MyColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (homeC.isLoadingRFY.value) {
            return const MyLoading();
          } else {
            return SizedBox(
              width: Get.size.width,
              height: 370,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: (homeC.resRec.length > 3) ? 3 : homeC.resRec.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) => MyContent(
                  isFav: homeC.resRec[index].favorite,
                  mediaType: homeC.resRec[index].mediaType,
                  formats: homeC.resRec[index].formats,
                  title: homeC.resRec[index].title,
                  authors: homeC.resRec[index].authors,
                  downloadCount: homeC.resRec[index].downloadCount,
                  onTap: () => homeC
                      .openBookDetail(id: homeC.resRec[index].id)
                      .then((value) => homeC.checkHist()),
                  onFav: () =>
                      homeC.setFavorite(favC: favC, res: homeC.resRec[index]),
                ),
              ),
            );
          }
        })
      ],
    );
  }
}

class HomeTC extends StatelessWidget {
  const HomeTC({
    super.key,
    required this.homeC,
  });

  final HomeController homeC;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyText(
            text: "Top categories",
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            direction: Axis.horizontal,
            children: List.generate(
              homeC.topCategory.length,
              (index) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => homeC
                    .openBookPage(valTopic: homeC.topCategory[index]["name"])
                    .then((value) => homeC.checkHist()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    border: Border.all(color: MyColors.lightGrey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MyText(
                    text: homeC.topCategory[index]["name"],
                    color: MyColors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.homeC,
  });

  final HomeController homeC;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: MyText(
                  text: "Discover new read",
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 100),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: MyColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(MyIcons.icPalm, scale: 18),
              )
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => homeC
                .openBookPage(isSearch: true)
                .then((value) => homeC.checkHist()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 52,
              width: Get.size.width,
              decoration: BoxDecoration(
                color: MyColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: MyColors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MyText(
                    text: "What do you want to read?",
                    color: MyColors.grey,
                  ),
                  Image.asset(MyIcons.icSearch, scale: 4)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
