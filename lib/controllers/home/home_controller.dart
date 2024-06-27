import 'dart:math';

import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/controllers/favorite/favorite_controller.dart';
import 'package:pc_book_dika_desandra_ardiansyah/local_databases/tables/history/ldb_history_table.dart';
import 'package:pc_book_dika_desandra_ardiansyah/models/books_model.dart';
import 'package:pc_book_dika_desandra_ardiansyah/views/book/book_detail_page.dart';
import 'package:pc_book_dika_desandra_ardiansyah/views/book/book_page.dart';

import '../../local_databases/models/favorite/ldb_favorite_model.dart';
import '../../local_databases/sql/ldb_sql_query.dart';
import '../../local_databases/tables/favorite/ldb_favorite_table.dart';
import '../../repositories/book/books_repository.dart';

class HomeController extends GetxController {
  List<Map<String, dynamic>> topCategory = [
    {"name": "Adventure"},
    {"name": "Children"},
    {"name": "Comedy"},
    {"name": "Fantasy"},
    {"name": "Horor"},
    {"name": "Romance"},
  ];

  var resRec = <BooksModel>[].obs;
  var resHis = <BooksModel>[].obs;
  var resOthers = <BooksModel>[].obs;
  var favData = <LDBFavoriteModel>[].obs;

  var isLoadingRFY = false.obs;
  var isLoadingHis = false.obs;
  var isLoadingOther = false.obs;

  var topic = Rxn<String>();
  var ids = Rxn<String>();

  @override
  void onInit() {
    getRecBook();
    getHis();
    getOther();
    super.onInit();
  }

  getRecBook() async {
    if (isLoadingRFY.value) return;

    isLoadingRFY.value = true;

    var dataTopic = await LDBSQLQuery.sqlQuery(
        query:
            '''select topic, count(topic) as cnt from ${LDBHistoryTable.tableName} where topic is not null group by topic order by cnt desc limit 1''');

    List<BooksModel> res = [];
    if (dataTopic.isEmpty) {
      var data = await getBooks();
      res.assignAll(data[2]);
    } else {
      topic.value = dataTopic[0]["topic"];

      var data = await getBooks(topic: topic.value);
      res.assignAll(data[2]);
    }

    var resFav = await LDBSQLQuery.sqlQuery(
        query: '''select * from ${LDBFavoriteTable.tableName}''');

    for (var val in resFav) {
      favData.add(LDBFavoriteModel.fromJson(val));
    }

    List<BooksModel> copyBooks = List.from(res);
    copyBooks.shuffle();
    resRec.value = copyBooks.sublist(0, min(3, copyBooks.length));

    for (var api in resRec) {
      for (var local in favData) {
        if (local.bookId == api.id) api.favorite.value = true;
      }
    }

    isLoadingRFY.value = false;
  }

  getHis() async {
    if (isLoadingHis.value) return;

    isLoadingHis.value = true;

    var dataId = await LDBSQLQuery.sqlQuery(
        query:
            '''select MAX(id) as id, book_id from ${LDBHistoryTable.tableName} group by book_id order by id desc limit 3''');

    if (dataId.isNotEmpty) {
      List<int> bookIds = dataId
          .map((item) => item['book_id'])
          .where((bookId) => bookId != null)
          .cast<int>()
          .toList();

      ids.value = bookIds.join(',');

      var data = await getBooks(ids: ids.value);
      resHis.assignAll(data[2]);

      favData.clear();
      var resFav = await LDBSQLQuery.sqlQuery(
          query: '''select * from ${LDBFavoriteTable.tableName}''');

      for (var val in resFav) {
        favData.add(LDBFavoriteModel.fromJson(val));
      }

      for (var api in resHis) {
        for (var local in favData) {
          if (local.bookId == api.id) api.favorite.value = true;
        }
      }
    }

    isLoadingHis.value = false;
  }

  getOther() async {
    if (isLoadingOther.value) return;

    isLoadingOther.value = true;

    List<BooksModel> res = [];
    var data = await getBooks();
    res.assignAll(data[2]);

    var resFav = await LDBSQLQuery.sqlQuery(
        query: '''select * from ${LDBFavoriteTable.tableName}''');

    for (var val in resFav) {
      favData.add(LDBFavoriteModel.fromJson(val));
    }

    List<BooksModel> copyBooks = List.from(res);
    copyBooks.shuffle();
    resOthers.value = copyBooks.sublist(0, min(8, copyBooks.length));

    for (var api in resOthers) {
      for (var local in favData) {
        if (local.bookId == api.id) api.favorite.value = true;
      }
    }

    isLoadingOther.value = false;
  }

  checkHist() {
    resHis.clear();
    getHis();
  }

  Future openBookPage({
    dynamic valIds,
    dynamic valTopic,
    bool? isSearch,
  }) async {
    if (valTopic != null) {
      await LDBSQLQuery.sqlQuery(
        query:
            '''insert into ${LDBHistoryTable.tableName} (${LDBHistoryTable.topic}) values("$valTopic")''',
      );
    }

    await Get.to(BookPage(
      ids: valIds,
      topic: valTopic,
      isSearch: isSearch ?? false,
    ));
  }

  Future openBookDetail({required dynamic id}) async {
    await LDBSQLQuery.sqlQuery(
      query:
          '''insert into ${LDBHistoryTable.tableName} (${LDBHistoryTable.bookId}) values($id)''',
    );

    await Get.to(BookDetailPage(id: id));
  }

  setFavorite({
    required FavoriteController favC,
    required BooksModel res,
  }) async {
    _setFavoriteInList(res: resRec, id: res.id);
    _setFavoriteInList(res: resHis, id: res.id);
    _setFavoriteInList(res: resOthers, id: res.id);

    var data = await LDBSQLQuery.sqlQuery(
      query:
          '''select * from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.bookId} = ${res.id}''',
    );

    if (data.isEmpty) {
      await LDBSQLQuery.sqlQuery(
        query:
            '''insert into ${LDBFavoriteTable.tableName} (${LDBFavoriteTable.bookId}) values(${res.id})''',
      );
      // favC.res.add(res);
    } else {
      await LDBSQLQuery.sqlQuery(
        query:
            '''delete from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.bookId} = ${res.id}''',
      );
      // favC.res.removeWhere((item) => item.id == res.id);
    }
    favC.fetchApi(isRefresh: true);
  }

  _setFavoriteInList({required RxList<BooksModel> res, required int id}) async {
    BooksModel? book = res.firstWhereOrNull((book) => book.id == id);
    if (book != null) {
      book.favorite.value = !book.favorite.value;
    }
  }
}
