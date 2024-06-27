import '../../tables/history/ldb_history_table.dart';

class LDBHistoryModel {
  dynamic id, bookId, topic;

  LDBHistoryModel({
    this.id,
    this.bookId,
    this.topic,
  });

  LDBHistoryModel.fromJson(Map<String, dynamic> json) {
    bookId = json["book_id"];
    topic = json["topic"];
  }

  Map<String, dynamic> toJson() => {
        LDBHistoryTable.id: id,
        LDBHistoryTable.bookId: bookId,
        LDBHistoryTable.topic: topic,
      };
}
