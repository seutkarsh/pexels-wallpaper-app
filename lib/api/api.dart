import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiOperations {
  String getImagesEndpoint =
      dotenv.env["API_URL"] ?? "https://api.pexels.com/v1";

  String authority = dotenv.env["API_AUTHORITY"] ?? "api.pexels.com";

  Future<List<String>> getTrendingWallpapers() async {
    var response = await http.get(Uri.parse("$getImagesEndpoint/curated"),
        headers: {"Authorization": dotenv.env["API_KEY"] ?? ""});

    Map<String, dynamic> data = jsonDecode(response.body);

    List<String> photoList = [];

    data['photos'].forEach((e) {
      var map = e["src"];
      photoList.add(map['portrait'].toString());
    });
    return photoList;
  }

  getSearchResults(String query) async {
    var response = await http.get(
        Uri.https(authority, "/v1/search", {"query": query, "per_page": "20"}),
        headers: {"Authorization": dotenv.env["API_KEY"] ?? ""});

    Map<String, dynamic> data = jsonDecode(response.body);

    List<String> photoList = [];

    data['photos'].forEach((e) {
      var map = e["src"];
      photoList.add(map['portrait'].toString());
    });
    return photoList;
  }
}
