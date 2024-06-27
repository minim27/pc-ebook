import 'package:get/get.dart';
import 'package:pc_book_dika_desandra_ardiansyah/controllers/home/home_controller.dart';

import '../../local_databases/models/favorite/ldb_favorite_model.dart';
import '../../local_databases/sql/ldb_sql_query.dart';
import '../../local_databases/tables/favorite/ldb_favorite_table.dart';
import '../../models/books_model.dart';
import '../../repositories/book/books_repository.dart';
import '../favorite/favorite_controller.dart';

class BookDetailController extends GetxController {
  final homeC = Get.find<HomeController>();
  final favC = Get.find<FavoriteController>();

  var favData = <LDBFavoriteModel>[].obs;
  var res = <BooksModel>[].obs;
  var isLoading = false.obs;

  fetchApi({required dynamic id}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    var data = await getBooks(ids: "$id");
    res.assignAll(data[2]);

    var resFav = await LDBSQLQuery.sqlQuery(
        query: '''select * from ${LDBFavoriteTable.tableName}''');
    for (var val in resFav) {
      favData.add(LDBFavoriteModel.fromJson(val));
    }

    for (var local in favData) {
      if (local.bookId == res[0].id) res[0].favorite.value = true;
    }

    isLoading.value = false;
  }

  setFavorite({required BooksModel resBook}) async {
    _setFavoriteInList(res: res, id: resBook.id);
    _setFavoriteInList(res: homeC.resRec, id: resBook.id);
    _setFavoriteInList(res: homeC.resOthers, id: resBook.id);

    var data = await LDBSQLQuery.sqlQuery(
      query:
          '''select * from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.bookId} = ${resBook.id}''',
    );

    if (data.isEmpty) {
      await LDBSQLQuery.sqlQuery(
        query:
            '''insert into ${LDBFavoriteTable.tableName} (${LDBFavoriteTable.bookId}) values(${resBook.id})''',
      );
      favC.res.add(resBook);
    } else {
      await LDBSQLQuery.sqlQuery(
        query:
            '''delete from ${LDBFavoriteTable.tableName} where ${LDBFavoriteTable.bookId} = ${resBook.id}''',
      );
      favC.res.removeWhere((item) => item.id == resBook.id);
    }
  }

  _setFavoriteInList({required RxList<BooksModel> res, required int id}) async {
    BooksModel? book = res.firstWhereOrNull((book) => book.id == id);
    if (book != null) {
      book.favorite.value = !book.favorite.value;
    }
  }
}
