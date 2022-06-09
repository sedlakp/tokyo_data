import 'CulturalSite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// String baseURL = "https://api.data.metro.tokyo.lg.jp/v1/";
// enum Paths { CulturalSite }
// enum QueryParams { ID, limit, cursor}

class APIService {

  static const int apiItemLimit = 20;

  static Future<CulturalSite> fetchCulturalSite({required String id}) async {
    final response = await http.get(Uri.parse('https://api.data.metro.tokyo.lg.jp/v1/CulturalProperty?ID=$id'));
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      Map<String, dynamic> jsonSite = list[0][0];
      return CulturalSite.fromJson(jsonSite);
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<List<CulturalSite>> fetchCulturalSites({int limit = apiItemLimit, String? cursor = ""}) async {

    //var uri = Uri.http('example.org', '/path', { 'q' : 'dart' });
    final response = await http.get(Uri.parse('https://api.data.metro.tokyo.lg.jp/v1/CulturalProperty?limit=$limit&cursor=$cursor'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> bodyList = jsonDecode(response.body);
      List<dynamic> list = bodyList[0];
      print(list);
      List<CulturalSite> posts = List<CulturalSite>.from(list.map((model)=> CulturalSite.fromJson(model)));
      return posts;
    } else {
      throw Exception('Failed to load');
    }
  }

  static Future<CulturalSiteList> fetchCulturalSites2({int limit = apiItemLimit, String? cursor = ""}) async {

    //var uri = Uri.http('example.org', '/path', { 'q' : 'dart' });
    final response = await http.get(Uri.parse('https://api.data.metro.tokyo.lg.jp/v1/CulturalProperty?limit=$limit&cursor=$cursor'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> bodyList = jsonDecode(response.body);
      //List<dynamic> list = bodyList[0];
      //print(list);
      //List<CulturalSite> posts = List<CulturalSite>.from(list.map((model)=> CulturalSite.fromJson(model)));
      print("Hello");
      CulturalSiteList posts = CulturalSiteList.fromJson(bodyList);
      return posts;
    } else {
      throw Exception('Failed to load');
    }
  }

}