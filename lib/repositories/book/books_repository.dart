import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/books_model.dart';
import '../../services/my_config.dart';

Future<dynamic> getBooks({
  dynamic page,
  dynamic ids,
  dynamic copyright,
  dynamic languages,
  dynamic topic,
  String? search,
}) async {
  final body = {
    if (page != null) "page": "$page",
    if (ids != null) "ids": ids,
    if (topic != null) "topic": topic,
    if (languages != null) "languages": languages,
    if (copyright != null) "copyright": "$copyright",
    if (search != "" && search != null) "search": search,
  };

  Uri uri = Uri.parse("${MyConfig.apiURL}/books");
  final newUri = uri.replace(queryParameters: body);

  final response = await http.get(newUri).timeout(
        const Duration(minutes: 5),
        onTimeout: () => http.Response("Error Connection", 408),
      );

  if (response.statusCode == 200) {
    dynamic responseData = json.decode(response.body);

    List<BooksModel> res = [];

    for (Map<String, dynamic> data in responseData["results"]) {
      res.add(BooksModel.fromJson(data));
    }

    return [response.statusCode, "success", res];
  } else if (response.statusCode == 408) {
    return [response.statusCode, "Connection error", []];
  } else {
    return [response.statusCode, "error", []];
  }
}
