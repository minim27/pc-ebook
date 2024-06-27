import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_icons.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_utility.dart';

import '../utils/my_colors.dart';
import 'my_image.dart';
import 'my_text.dart';

class MyContent extends StatelessWidget {
  const MyContent({
    super.key,
    required this.title,
    required this.mediaType,
    required this.formats,
    required this.isFav,
    required this.authors,
    required this.downloadCount,
    required this.onTap,
    required this.onFav,
  });

  final String title, mediaType;
  final Map<String, dynamic> formats;
  final Rx<bool> isFav;
  final dynamic authors;
  final int downloadCount;
  final VoidCallback onTap, onFav;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 180,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: Get.size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: MyColors.linearHor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: (mediaType == "Sound")
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.primary.withOpacity(0.1),
                            ),
                            child: const Icon(
                              Icons.music_note_rounded,
                              size: 50,
                              color: MyColors.primary,
                            ),
                          )
                        : MyImage(
                            image: "${formats["image/jpeg"]}",
                            fit: BoxFit.contain,
                          ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(top: 12),
                      width: Get.size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                MyText(
                                  text: MyUtility.formatNumberWithSuffix(
                                      number: downloadCount),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: MyText(
                              text: title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Wrap(
                            children: List.generate(
                              authors.length,
                              (index) => MyText(
                                text: authors[index]["name"],
                                color: MyColors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 6,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onFav,
              child: Obx(() => Image.asset(
                    (isFav.value)
                        ? MyIcons.icBookmarkActive
                        : MyIcons.icBookmark2,
                    scale: 2.6,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
