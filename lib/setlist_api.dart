import 'dart:convert';
import 'package:http/http.dart' as http;

class SetlistApi {
  static const String baseUrl = 'https://api.setlist.fm/rest/1.0';
  static const String apiKey = 'iIAuOo4gJJn46KzOK78kIjrSC3b0huxJ--VR';

  // MusicBrainz API でアーティストID（MBID）を取得
  Future<String?> fetchArtistId(String artist) async {
    final encoded = Uri.encodeQueryComponent(artist);
    final url = Uri.parse(
      'https://musicbrainz.org/ws/2/artist?query=artist:$encoded&fmt=json',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'SetlistApp/1.0 (tamaki.maf1018@gmail.com)'},
    );

    print("MB response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final artists = json['artists'] as List<dynamic>?;

      if (artists != null && artists.isNotEmpty) {
        return artists[0]['id']; // MBID
      }
    }
    return null;
  }

  // アーティスト名から公演一覧を取得
  Future<List<dynamic>> fetchSetlistsById(String mbid) async {
    final url = Uri.parse('$baseUrl/search/setlists?artistMbid=$mbid&p=1');

    final response = await http.get(
      url,
      headers: {
        'x-api-key': apiKey,
        'Accept': 'application/json',
        'User-Agent': 'SetlistApp/1.0',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['setlist'] ?? [];
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }

  // セトリ詳細を取得
  Future<List<dynamic>> fetchSongs(String setlistId) async {
    final url = Uri.parse('$baseUrl/setlist/$setlistId');

    final response = await http.get(
      url,
      headers: {
        'x-api-key': apiKey,
        'Accept': 'application/json',
        'User-Agent': 'SetlistApp/1.0',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['sets']?['set']?[0]?['song'] ?? [];
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }

    Future<List<String>> fetchArtistSuggestions(String query) async {
    if (query.isEmpty) return [];

    final encoded = Uri.encodeQueryComponent(query);
    final url = Uri.parse(
      'https://musicbrainz.org/ws/2/artist?query=artist:$encoded&fmt=json',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'SetlistApp/1.0'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final artists = json['artists'] as List<dynamic>? ?? [];

      // アーティスト名だけを抽出して重複を削除
      return artists
          .map((a) => a['name'] as String)
          .toSet()
          .take(10)
          .toList();
    }

    return [];
  }
}
