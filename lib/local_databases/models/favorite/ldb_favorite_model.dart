import '../../tables/favorite/ldb_favorite_table.dart';

// class LDBFavoriteModel {
//   dynamic id, thumbnail, title, authorsId, downloadCount;

//   LDBFavoriteModel({
//     this.id,
//     this.thumbnail,
//     this.title,
//     this.authorsId,
//     this.downloadCount,
//   });

//   LDBFavoriteModel.fromJson(Map<String, dynamic> json) {
//     id = json["id"];
//     thumbnail = json["thumbnail"];
//     title = json["title"];
//     authorsId = json["authors_id"];
//     downloadCount = json["download_count"];
//   }

//   Map<String, dynamic> toJson() => {
//         LDBFavoriteTable.id: id,
//         LDBFavoriteTable.thumbnail: thumbnail,
//         LDBFavoriteTable.title: title,
//         LDBFavoriteTable.authorsId: authorsId,
//         LDBFavoriteTable.downloadCount: downloadCount,
//       };
// }
class LDBFavoriteModel {
  dynamic id, bookId;

  LDBFavoriteModel({
    this.id,
    this.bookId,
  });

  LDBFavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    bookId = json["book_id"];
  }

  Map<String, dynamic> toJson() => {
        LDBFavoriteTable.id: id,
        LDBFavoriteTable.bookId: bookId,
      };
}
