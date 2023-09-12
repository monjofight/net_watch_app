// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Project imports:
import '../models/episode.dart';
import '../models/season.dart';
import '../models/title.dart';

class ApiService {
  final String _baseUrl = dotenv.get('BACKEND_HOST');

  Uri _getUri(String path) => Uri.parse('$_baseUrl$path');

  _handleResponse(http.Response response, String errorMessage) {
    if (response.statusCode != 200) {
      throw Exception(errorMessage);
    }
  }

  // Title
  Future<List<NetflixTitle>> getTitles() async {
    final response = await http.get(_getUri('/titles'));

    _handleResponse(response, 'Failed to load titles');

    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((title) => NetflixTitle.fromJson(title)).toList();
  }

  Future<void> watchEpisodesOfTitle(int titleId) async {
    final response = await http.post(_getUri('/titles/$titleId/watch'));
    _handleResponse(response, 'Failed to mark all episodes as watched');
  }

  Future<void> unwatchEpisodesOfTitle(int titleId) async {
    final response = await http.post(_getUri('/titles/$titleId/unwatch'));
    _handleResponse(response, 'Failed to mark all episodes as unwatched');
  }

  // Season
  Future<List<Season>> getSeasons(int titleId) async {
    final response = await http.get(_getUri('/titles/$titleId/seasons'));
    _handleResponse(response, 'Failed to load seasons');

    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((season) => Season.fromJson(season)).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  Future<void> watchAllEpisodesOfSeason(int titleId, int seasonId) async {
    final response =
        await http.post(_getUri('/titles/$titleId/seasons/$seasonId/watch'));
    _handleResponse(response, 'Failed to mark all episodes as watched');
  }

  Future<void> unwatchAllEpisodesOfSeason(int titleId, int seasonId) async {
    final response =
        await http.post(_getUri('/titles/$titleId/seasons/$seasonId/unwatch'));
    _handleResponse(response, 'Failed to mark all episodes as unwatched');
  }

  // Episode
  Future<List<Episode>> getEpisodes(int titleId, int seasonId) async {
    final response =
        await http.get(_getUri('/titles/$titleId/seasons/$seasonId/episodes'));
    _handleResponse(response, 'Failed to load episodes');

    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((episode) => Episode.fromJson(episode)).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  Future<void> watchEpisode(int titleId, int seasonId, int episodeId) async {
    final response = await http.post(_getUri(
        '/titles/$titleId/seasons/$seasonId/episodes/$episodeId/watch'));
    _handleResponse(response, 'Failed to mark episode as watched');
  }

  Future<void> unwatchEpisode(int titleId, int seasonId, int episodeId) async {
    final response = await http.post(_getUri(
        '/titles/$titleId/seasons/$seasonId/episodes/$episodeId/unwatch'));
    _handleResponse(response, 'Failed to unmark episode as watched');
  }
}
