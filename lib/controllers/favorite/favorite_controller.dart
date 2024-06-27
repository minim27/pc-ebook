import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/controllers/home/home_controller.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_colors.dart';
import 'package:pc_book_dika_desandra_ardiansyah/utils/my_utility.dart';

import '../../local_databases/models/favorite/ldb_favorite_model.dart';
import '../../local_databases/sql/ldb_sql_query.dart';
import '../../local_databases/tables/favorite/ldb_favorite_table.dart';
import '../../local_databases/tables/history/ldb_history_table.dart';
import '../../models/books_model.dart';
import '../../repositories/book/books_repository.dart';
import '../../views/book/book_detail_page.dart';
import '../../widgets/my_text.dart';

class FavoriteController extends GetxController {
  final GlobalKey<ScaffoldState> sKey = GlobalKey();

  final homeC = Get.find<HomeController>();

  List<Map<String, dynamic>> filCategory = [
    {"name": "Adventure"},
    {"name": "Children"},
    {"name": "Comedy"},
    {"name": "Fantasy"},
    {"name": "Horor"},
    {"name": "Romance"},
  ];

  List<Map<String, dynamic>> filLanguages = [
    {
      "name": "English",
      "value": "en",
    },
    {
      "name": "French",
      "value": "fr",
    },
    {
      "name": "Finnish",
      "value": "fi",
    },
  ];

  List<Map<String, dynamic>> filCR = [
    {
      "name": "With Copyright",
      "value": true,
    },
    {
      "name": "Without Copyright",
      "value": false,
    },
  ];

  var txtSearch = TextEditingController();

  var catDumSelected = Rxn<dynamic>();
  var langDumSelected = <String>[].obs;
  var crDumSelected = Rxn<bool>();

  var catSelected = Rxn<dynamic>();
  var langSelected = <String>[].obs;
  var crSelected = Rxn<bool>();

  var favData = <LDBFavoriteModel>[].obs;
  var res = <BooksModel>[].obs;
  var isLoading = false.obs;
  var page = 1.obs;
  var hasMore = true.obs;

  var ids = Rxn<String>();

  @override
  void onInit() {
    fetchApi();
    super.onInit();
  }

  fetchApi({
    dynamic valTopic,
    dynamic valCopyright,
    dynamic valLanguages,
    dynamic search,
    bool isRefresh = false,
  }) async {
    if (isLoading.value) return;

    if (isRefresh) {
      res.clear();

      page.value = 1;
      hasMore.value = true;
    }

    isLoading.value = true;

    var dataId = await LDBSQLQuery.sqlQuery(
        query:
            '''select * from ${LDBFavoriteTable.tableName} order by id desc''');

    if (dataId.isNotEmpty) {
      List<int> bookIds = dataId
          .map((item) => item['book_id'])
          .where((bookId) => bookId != null)
          .cast<int>()
          .toList();

      ids.value = bookIds.join(',');

      var data = await getBooks(
        page: page.value,
        ids: ids.value,
        topic: valTopic,
        copyright: valCopyright,
        languages: valLanguages,
        search: search,
      );
      if (data[2].isEmpty) {
        hasMore.value = false;
      } else {
        if (isRefresh) {
          res.assignAll(data[2]);
        } else {
          res.addAll(data[2]);
        }
        page.value++;
      }

      var resFav = await LDBSQLQuery.sqlQuery(
          query: '''select * from ${LDBFavoriteTable.tableName}''');

      for (var val in resFav) {
        favData.add(LDBFavoriteModel.fromJson(val));
      }

      for (var api in res) {
        for (var local in favData) {
          if (local.bookId == api.id) api.favorite.value = true;
        }
      }
    }

    isLoading.value = false;
  }

  changeSelected({required Rxn<dynamic> variable, required dynamic val}) {
    if (val == variable.value) {
      variable.value = null;
    } else {
      variable.value = val;
    }
  }

  changeLangSelected({required String val}) {
    if (langDumSelected.contains(val)) {
      langDumSelected.remove(val);
    } else {
      langDumSelected.add(val);
    }
  }

  setFavorite({required int id}) async {
    var data = await LDBSQLQuery.sqlQuery(
      query:
          '''select * from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.bookId} = $id''',
    );

    if (data.isEmpty) {
      await LDBSQLQuery.sqlQuery(
        query:
            '''insert into ${LDBFavoriteTable.tableName} (${LDBFavoriteTable.bookId}) values($id)''',
      );
    } else {
      await MyUtility.showMyDialog(
        barrierDismissible: true,
        title: const MyText(
          text: "Delete Favorite",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        content: const MyText(text: "Do you want to delete this favorite?"),
        actions: [
          MyUtility.myAdaptiveAction(
            child: const MyText(text: "Cancel", fontWeight: FontWeight.w600),
            onPressed: () => Get.back(),
          ),
          MyUtility.myAdaptiveAction(
              child: const MyText(
                text: "Delete",
                color: MyColors.red,
                fontWeight: FontWeight.w600,
              ),
              onPressed: () async {
                await LDBSQLQuery.sqlQuery(
                  query:
                      '''delete from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.bookId} = $id''',
                );

                res.removeWhere((item) => item.id == id);

                _setFavoriteInList(res: res, id: id);
                _setFavoriteInList(res: homeC.resRec, id: id);
                _setFavoriteInList(res: homeC.resHis, id: id);
                _setFavoriteInList(res: homeC.resOthers, id: id);

                Get.back();
              }),
        ],
      );
    }
  }

  _setFavoriteInList({required RxList<BooksModel> res, required int id}) async {
    BooksModel? book = res.firstWhereOrNull((book) => book.id == id);
    if (book != null) {
      book.favorite.value = !book.favorite.value;
    }
  }

  Future openBookDetail({required dynamic id}) async {
    await LDBSQLQuery.sqlQuery(
      query:
          '''insert into ${LDBHistoryTable.tableName} (${LDBHistoryTable.bookId}) values($id)''',
    );

    await Get.to(BookDetailPage(id: id));
  }

  resetFilter() {
    catDumSelected.value = null;
    langDumSelected.clear();
    crDumSelected.value = null;

    catSelected.value = null;
    langSelected.clear();
    crSelected.value = null;

    fetchApi(isRefresh: true);

    Get.back();
  }

  addFilter() {
    catSelected.value = catDumSelected.value;
    langSelected.assignAll(langDumSelected);
    crSelected.value = crDumSelected.value;

    dynamic lang;
    if (langSelected.isNotEmpty) {
      List<dynamic> langSel = langSelected.map((item) => item).toList();

      lang = langSel.join(',');
    }

    fetchApi(
      isRefresh: true,
      valTopic: catSelected.value,
      valLanguages: lang,
      valCopyright: crSelected.value,
    );

    Get.back();
  }
}
