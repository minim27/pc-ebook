import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/controllers/book/book_detail_controller.dart';
import 'package:pc_book_dika_desandra_ardiansyah/widgets/my_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/my_colors.dart';
import '../../utils/my_icons.dart';
import '../../utils/my_utility.dart';
import '../../widgets/my_image.dart';
import '../../widgets/my_loading.dart';
import '../../widgets/my_scaffold.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({
    super.key,
    required this.id,
  });

  final dynamic id;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final bookDC = Get.put(BookDetailController());

  @override
  void initState() {
    bookDC.fetchApi(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: MyColors.grey2,

      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: const MyText(
      //     text: "Book Detail",
      //     fontSize: 16,
      //     fontWeight: FontWeight.w500,
      //   ),
      // ),
      body: Container(
        decoration: const BoxDecoration(gradient: MyColors.linearHor),
        child: Obx(() {
          if (bookDC.isLoading.value) {
            return const MyLoading();
          } else {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: Get.size.height * (68 / 100),
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: BookDetailImage(bookDC: bookDC),
                  ),
                ),
                SliverToBoxAdapter(child: BookDetailBody(bookDC: bookDC)),
              ],
            );
          }
        }),
      ),
    );
  }
}

class BookDetailBody extends StatelessWidget {
  const BookDetailBody({
    super.key,
    required this.bookDC,
  });

  final BookDetailController bookDC;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: Get.size.width,
        decoration: const BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadiusDirectional.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MyText(
                    text: bookDC.res[0].title,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: () => bookDC.setFavorite(resBook: bookDC.res[0]),
                  child: Obx(() => Image.asset(
                        (bookDC.res[0].favorite.value)
                            ? MyIcons.icBookmarkActive
                            : MyIcons.icBookmark2,
                        scale: 2.4,
                      )),
                )
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              children: List.generate(
                bookDC.res[0].authors.length,
                (index) => MyText(
                  text: bookDC.res[0].authors[index]["name"],
                  color: MyColors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.lightGrey),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.download_rounded,
                        color: MyColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      MyText(
                        text: MyUtility.formatNumberWithSuffix(
                            number: bookDC.res[0].downloadCount),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                MyText(
                  text:
                      "${MyUtility.formatWithDotSeparator(number: bookDC.res[0].downloadCount)} total downloads",
                  color: MyColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const MyText(
              text: "Subjects",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 8),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  MyText(text: "- ${bookDC.res[0].subjects[index]}"),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: bookDC.res[0].subjects.length,
            ),
            const SizedBox(height: 24),
            const MyText(
              text: "Available formats",
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 8),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var format = bookDC.res[0].formats.entries.elementAt(index);

                return Row(
                  children: [
                    const Icon(
                      Icons.download_rounded,
                      color: MyColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse(format.value)),
                      child: MyText(
                        text: format.key,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: bookDC.res[0].formats.length,
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailImage extends StatelessWidget {
  const BookDetailImage({
    super.key,
    required this.bookDC,
  });

  final BookDetailController bookDC;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width,
      child: (bookDC.res[0].mediaType == "Sound")
          ? const Icon(
              Icons.music_note_rounded,
              size: 50,
              color: MyColors.primary,
            )
          : Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: MyImage(
                image: "${bookDC.res[0].formats["image/jpeg"]}",
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
