import 'package:pc_book_dika_desandra_ardiansyah/services/my_local_db.dart';

class LDBSQLQuery {
  static Future<dynamic> sqlQuery({required String query}) async {
    final db = await MyLocalDB.instance.database;

    return await db.rawQuery(query);
  }
}
