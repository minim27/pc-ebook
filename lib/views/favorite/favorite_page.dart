import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/controllers/favorite/favorite_controller.dart';

import '../../utils/my_colors.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_content.dart';
import '../../widgets/my_loading.dart';
import '../../widgets/my_scaffold.dart';
import '../../widgets/my_text.dart';
import '../../widgets/my_text_form_field.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final favC = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      key: favC.sKey,
      appBar: AppBar(
        title: MyTextFormFieldSearch(
          controller: favC.txtSearch,
          hintText: "Search your favorite book here...",
          onFieldSubmitted: (value) => favC.fetchApi(
            search: favC.txtSearch.text,
            isRefresh: true,
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.filter_list_rounded, color: MyColors.black),
                Obx(() => Visibility(
                      visible: (favC.catSelected.value != null ||
                          favC.langSelected.isNotEmpty ||
                          favC.crSelected.value != null),
                      child: const Positioned(
                        right: -2,
                        top: -2,
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: MyColors.primary,
                          size: 12,
                        ),
                      ),
                    ))
              ],
            ),
            onPressed: () {
              favC.catDumSelected.value = favC.catSelected.value;
              favC.langDumSelected.assignAll(favC.langSelected);
              favC.crDumSelected.value = favC.crSelected.value;

              favC.sKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: FavDrawer(favC: favC, widget: widget),
      body: Obx(() {
        if (favC.isLoading.value && favC.res.isEmpty) {
          return const MyLoading();
        } else {
          return (favC.res.isEmpty)
              ? const Center(
                  child: MyText(
                    text: "- Favorite books not found -",
                    color: MyColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if ((!favC.isLoading.value && favC.hasMore.value) &&
                        (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent)) {
                      favC.fetchApi();
                      return true;
                    }
                    return false;
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          crossAxisCount: 2,
                          childAspectRatio: 0.44,
                        ),
                        itemCount: favC.res.length,
                        itemBuilder: (context, index) => MyContent(
                          isFav: favC.res[index].favorite,
                          mediaType: favC.res[index].mediaType,
                          formats: favC.res[index].formats,
                          title: favC.res[index].title,
                          authors: favC.res[index].authors,
                          downloadCount: favC.res[index].downloadCount,
                          onTap: () => favC
                              .openBookDetail(id: favC.res[index].id)
                              .then((value) => favC.fetchApi(isRefresh: true)),
                          onFav: () => favC.setFavorite(id: favC.res[index].id),
                        ),
                      ),
                      Visibility(
                        visible: (favC.hasMore.value == true),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: MyMoreLoading(),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }
      }),
    );
  }
}

class FavDrawer extends StatelessWidget {
  const FavDrawer({
    super.key,
    required this.favC,
    required this.widget,
  });

  final FavoriteController favC;
  final FavoritePage widget;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MyColors.white,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            SizedBox(
              height: Get.size.height * (18 / 100),
              width: Get.size.width,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: MyColors.primary.withOpacity(0.1),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: MyText(
                    text: 'Filter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 12),
                  FavFilCat(favC: favC),
                  const SizedBox(height: 24),
                  FavFilLang(favC: favC),
                  const SizedBox(height: 24),
                  FavFilCopy(favC: favC),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: MyButton(
                      color: MyColors.primary.withOpacity(0.2),
                      text: "Reset",
                      textColor: MyColors.primary,
                      onTap: () => favC.resetFilter(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyButton(
                      text: "Filter",
                      onTap: () => favC.addFilter(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FavFilCopy extends StatelessWidget {
  const FavFilCopy({
    super.key,
    required this.favC,
  });

  final FavoriteController favC;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          text: "Copyright",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            favC.filCR.length,
            (index) => GestureDetector(
              onTap: () => favC.changeSelected(
                variable: favC.crDumSelected,
                val: favC.filCR[index]["value"],
              ),
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: (favC.crDumSelected.value ==
                              favC.filCR[index]["value"])
                          ? MyColors.primary
                          : MyColors.white,
                      border: Border.all(
                          color: (favC.crDumSelected.value ==
                                  favC.filCR[index]["value"])
                              ? MyColors.primary
                              : MyColors.lightGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MyText(
                        text: favC.filCR[index]["name"],
                        fontWeight: (favC.crDumSelected.value ==
                                favC.filCR[index]["value"])
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (favC.crDumSelected.value ==
                                favC.filCR[index]["value"])
                            ? MyColors.white
                            : MyColors.black),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

class FavFilLang extends StatelessWidget {
  const FavFilLang({
    super.key,
    required this.favC,
  });

  final FavoriteController favC;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          text: "Languages",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            favC.filLanguages.length,
            (index) => GestureDetector(
              onTap: () => favC.changeLangSelected(
                  val: favC.filLanguages[index]["value"]),
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: (favC.langDumSelected
                              .contains(favC.filLanguages[index]["value"]))
                          ? MyColors.primary
                          : MyColors.white,
                      border: Border.all(
                          color: (favC.langDumSelected
                                  .contains(favC.filLanguages[index]["value"]))
                              ? MyColors.primary
                              : MyColors.lightGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MyText(
                        text: favC.filLanguages[index]["name"],
                        fontWeight: (favC.langDumSelected
                                .contains(favC.filLanguages[index]["value"]))
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (favC.langDumSelected
                                .contains(favC.filLanguages[index]["value"]))
                            ? MyColors.white
                            : MyColors.black),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

class FavFilCat extends StatelessWidget {
  const FavFilCat({
    super.key,
    required this.favC,
  });

  final FavoriteController favC;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyText(
          text: "Category",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            favC.filCategory.length,
            (index) => GestureDetector(
              onTap: () => favC.changeSelected(
                variable: favC.catDumSelected,
                val: favC.filCategory[index]["name"],
              ),
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: (favC.catDumSelected.value ==
                              favC.filCategory[index]["name"])
                          ? MyColors.primary
                          : MyColors.white,
                      border: Border.all(
                          color: (favC.catDumSelected.value ==
                                  favC.filCategory[index]["name"])
                              ? MyColors.primary
                              : MyColors.lightGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MyText(
                        text: favC.filCategory[index]["name"],
                        fontWeight: (favC.catDumSelected.value ==
                                favC.filCategory[index]["name"])
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (favC.catDumSelected.value ==
                                favC.filCategory[index]["name"])
                            ? MyColors.white
                            : MyColors.black),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
