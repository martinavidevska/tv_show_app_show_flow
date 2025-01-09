import 'dart:convert';
import 'package:group_project/models/actor_model.dart';
import 'package:group_project/models/episode_model.dart';
import 'package:group_project/models/tv_show_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "https://api.tvmaze.com";

 static Future<List<ShowDetails>> searchShow(String query) async {
  final response = await http.get(Uri.parse("$_baseUrl/search/shows?q=$query"));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => ShowDetails.fromJson(json['show'])).toList(); // Returns ShowDetails
  } else {
    throw Exception("Failed to fetch shows by query");
  }
}

  static Future<ShowDetails> getShowDetails(int id) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/shows/$id?embed=cast"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ShowDetails.fromJson(data);
    } else {
      throw Exception("Failed to fetch show details");
    }
  }

  static Future<List<Episode>> getShowEpisodes(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl/shows/$id/episodes"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch episodes");
    }
  }

  static Future<List<Actor>> getShowCast(int id) async {
    final response = await http.get(Uri.parse("$_baseUrl/shows/$id/cast"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Actor.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch cast");
    }
  }

  static Future<List<ShowDetails>> getShowByIndex(int? index) async {
    final response = await http.get(Uri.parse("$_baseUrl/shows?page=$index"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ShowDetails.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch shows by page index");
    }
  }

}
