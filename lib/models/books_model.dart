import 'package:get/get.dart';

class BooksModel {
  dynamic id,
      title,
      authors,
      translators,
      subjects,
      bookshelves,
      languages,
      copyright,
      mediaType,
      formats,
      downloadCount;

  var favorite = false.obs;

  BooksModel({
    this.id,
    this.title,
    this.authors,
    this.translators,
    this.subjects,
    this.bookshelves,
    this.languages,
    this.copyright,
    this.mediaType,
    this.formats,
    this.downloadCount,
  });

  BooksModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    authors = json["authors"];
    translators = json["translators"];
    subjects = json["subjects"];
    bookshelves = json["bookshelves"];
    languages = json["languages"];
    copyright = json["copyright"];
    mediaType = json["media_type"];
    formats = json["formats"];
    downloadCount = json["download_count"];
  }
}
