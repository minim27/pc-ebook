import 'package:path/path.dart';
import 'package:pc_book_dika_desandra_ardiansyah/local_databases/tables/config/ldb_config_table.dart';
import 'package:pc_book_dika_desandra_ardiansyah/local_databases/tables/history/ldb_history_table.dart';
import 'package:pc_book_dika_desandra_ardiansyah/services/my_config.dart';
import 'package:sqflite/sqflite.dart';

import '../local_databases/tables/favorite/ldb_favorite_table.dart';

class MyLocalDB {
  static final MyLocalDB instance = MyLocalDB._init();
  MyLocalDB._init();

  static Database? db;

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initLocalDB();

    return db!;
  }

  static Future initLocalDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, MyConfig.localDBName);

    return openDatabase(
      path,
      version: MyConfig.localDBVer,
      onCreate: onCreate,
    );
  }

  static Future onCreate(Database db, int version) async {
//     await db.execute('''
// CREATE TABLE ${LDBFavoriteTable.tableName} (
//   ${LDBFavoriteTable.id} INTEGER,
//   ${LDBFavoriteTable.thumbnail} TEXT,
//   ${LDBFavoriteTable.title} TEXT,
//   ${LDBFavoriteTable.authorsId} INTEGER,
//   ${LDBFavoriteTable.downloadCount} INTEGER
// )
// ''');
    await db.execute('''
CREATE TABLE ${LDBFavoriteTable.tableName} (
  ${LDBFavoriteTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${LDBFavoriteTable.bookId} INTEGER
 )
''');

    await db.execute('''
CREATE TABLE ${LDBHistoryTable.tableName} (
  ${LDBHistoryTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${LDBHistoryTable.bookId} INTEGER,
  ${LDBHistoryTable.topic} TEXT
)
''');

    await db.execute('''
CREATE TABLE ${LDBConfigTable.tableName} (
  ${LDBConfigTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${LDBConfigTable.name} TEXT,
  ${LDBConfigTable.value} TEXT
)
''');
  }
}
