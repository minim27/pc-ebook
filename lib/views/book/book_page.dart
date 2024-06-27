import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_colors.dart';
import 'package:pc_book_dika_desandra_ardiansyah/widgets/my_button.dart';
import 'package:pc_book_dika_desandra_ardiansyah/widgets/my_text_form_field.dart';

import '../../controllers/book/book_controller.dart';
import '../../widgets/my_content.dart';
import '../../widgets/my_loading.dart';
import '../../widgets/my_scaffold.dart';
import '../../widgets/my_text.dart';

class BookPage extends StatefulWidget {
  const BookPage({
    super.key,
    this.ids,
    this.topic,
    this.isSearch,
  });

  final dynamic ids, topic;
  final bool? isSearch;

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final bookC = Get.put(BookController());

  @override
  void initState() {
    bookC.catDumSelected.value = widget.topic;
    bookC.catSelected.value = bookC.catDumSelected.value;

    if (widget.isSearch == false) {
      bookC.fetchApi(
        valIds: widget.ids,
        valTopic: bookC.catSelected.value,
        search: bookC.txtSearch.text,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      key: bookC.sKey,
      appBar: AppBar(
        title: MyTextFormFieldSearch(
          autofocus: widget.isSearch,
          controller: bookC.txtSearch,
          hintText: "What do you want to read?",
          onFieldSubmitted: (value) => bookC.fetchApi(
            valIds: widget.ids,
            valTopic: bookC.catSelected.value,
            search: bookC.txtSearch.text,
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
                      visible: (bookC.catSelected.value != null ||
                          bookC.langSelected.isNotEmpty ||
                          bookC.crSelected.value != null),
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
              bookC.catDumSelected.value = bookC.catSelected.value;
              bookC.langDumSelected.assignAll(bookC.langSelected);
              bookC.crDumSelected.value = bookC.crSelected.value;

              bookC.sKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: BookDrawer(bookC: bookC, widget: widget),
      body: Obx(() {
        if (bookC.isLoading.value && bookC.resBooks.isEmpty) {
          return const MyLoading();
        } else {
          return (bookC.resBooks.isEmpty)
              ? const Center(
                  child: MyText(
                    text: "- Books not found -",
                    color: MyColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if ((!bookC.isLoading.value && bookC.hasMore.value) &&
                        (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent)) {
                      bookC.fetchApi(
                        valIds: widget.ids,
                        valTopic: bookC.catSelected.value,
                        search: bookC.txtSearch.text,
                      );
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
                        itemCount: bookC.resBooks.length,
                        itemBuilder: (context, index) => MyContent(
                          isFav: bookC.resBooks[index].favorite,
                          mediaType: bookC.resBooks[index].mediaType,
                          formats: bookC.resBooks[index].formats,
                          title: bookC.resBooks[index].title,
                          authors: bookC.resBooks[index].authors,
                          downloadCount: bookC.resBooks[index].downloadCount,
                          onTap: () => bookC
                              .openBookDetail(id: bookC.resBooks[index].id)
                              .then((value) => bookC.fetchApi(
                                    isRefresh: true,
                                    valIds: widget.ids,
                                    valTopic: bookC.catSelected.value,
                                    search: bookC.txtSearch.text,
                                  )),
                          onFav: () =>
                              bookC.setFavorite(res: bookC.resBooks[index]),
                        ),
                      ),
                      Visibility(
                        visible: (bookC.hasMore.value),
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

class BookDrawer extends StatelessWidget {
  const BookDrawer({
    super.key,
    required this.bookC,
    required this.widget,
  });

  final BookController bookC;
  final BookPage widget;

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
                  BookFilCat(bookC: bookC),
                  const SizedBox(height: 24),
                  BookFilLang(bookC: bookC),
                  const SizedBox(height: 24),
                  BookFilCopy(bookC: bookC),
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
                      onTap: () => bookC.resetFilter(valIds: widget.ids),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyButton(
                      text: "Filter",
                      onTap: () => bookC.addFilter(valIds: widget.ids),
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

class BookFilCopy extends StatelessWidget {
  const BookFilCopy({
    super.key,
    required this.bookC,
  });

  final BookController bookC;

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
            bookC.filCR.length,
            (index) => GestureDetector(
              onTap: () => bookC.changeSelected(
                variable: bookC.crDumSelected,
                val: bookC.filCR[index]["value"],
              ),
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: (bookC.crDumSelected.value ==
                              bookC.filCR[index]["value"])
                          ? MyColors.primary
                          : MyColors.white,
                      border: Border.all(
                          color: (bookC.crDumSelected.value ==
                                  bookC.filCR[index]["value"])
                              ? MyColors.primary
                              : MyColors.lightGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MyText(
                        text: bookC.filCR[index]["name"],
                        fontWeight: (bookC.crDumSelected.value ==
                                bookC.filCR[index]["value"])
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (bookC.crDumSelected.value ==
                                bookC.filCR[index]["value"])
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

class BookFilLang extends StatelessWidget {
  const BookFilLang({
    super.key,
    required this.bookC,
  });

  final BookController bookC;

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
            bookC.filLanguages.length,
            (index) => GestureDetector(
              onTap: () => bookC.changeLangSelected(
                  val: bookC.filLanguages[index]["value"]),
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: (bookC.langDumSelected
                              .contains(bookC.filLanguages[index]["value"]))
                          ? MyColors.primary
                          : MyColors.white,
                      border: Border.all(
                          color: (bookC.langDumSelected
                                  .contains(bookC.filLanguages[index]["value"]))
                              ? MyColors.primary
                              : MyColors.lightGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MyText(
                        text: bookC.filLanguages[index]["name"],
                        fontWeight: (bookC.langDumSelected
                                .contains(bookC.filLanguages[index]["value"]))
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (bookC.langDumSelected
                                .contains(bookC.filLanguages[index]["value"]))
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

class BookFilCat extends StatelessWidget {
  const BookFilCat({
    super.key,
    required this.bookC,
  });

  final BookController bookC;

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
            bookC.filCategory.length,
            (index) => GestureDetector(
              onTap: () => bookC.changeSelected(
                variable: bookC.catDumSelected,
                val: bookC.filCategory[index]["name"],
              ),
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: (bookC.catDumSelected.value ==
                              bookC.filCategory[index]["name"])
                          ? MyColors.primary
                          : MyColors.white,
                      border: Border.all(
                          color: (bookC.catDumSelected.value ==
                                  bookC.filCategory[index]["name"])
                              ? MyColors.primary
                              : MyColors.lightGrey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: MyText(
                        text: bookC.filCategory[index]["name"],
                        fontWeight: (bookC.catDumSelected.value ==
                                bookC.filCategory[index]["name"])
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: (bookC.catDumSelected.value ==
                                bookC.filCategory[index]["name"])
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
