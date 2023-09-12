// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../models/season.dart';
import '../services/api_service.dart';
import 'episodes_page.dart';

class SeasonsPage extends StatefulWidget {
  final int titleId;

  const SeasonsPage({Key? key, required this.titleId}) : super(key: key);

  @override
  SeasonsPageState createState() => SeasonsPageState();
}

class SeasonsPageState extends State<SeasonsPage> {
  late Future<List<Season>> seasons;
  final ApiService apiService = ApiService();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _getSeasons();
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  Future<void> _getSeasons() async {
    seasons = apiService.getSeasons(widget.titleId);
  }

  Future<void> _markAllEpisodesAsWatched(Season season) async {
    await apiService.watchAllEpisodesOfSeason(widget.titleId, season.id);
    if (_isDisposed) {
      return;
    }
    setState(() {
      season.allWatched = true;
    });
  }

  Future<void> _unmarkAllEpisodesAsWatched(Season season) async {
    await apiService.unwatchAllEpisodesOfSeason(widget.titleId, season.id);
    if (_isDisposed) {
      return;
    }
    if (!_isDisposed) {
      setState(() {
        season.allWatched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seasons')),
      body: FutureBuilder<List<Season>>(
        future: seasons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Season season = snapshot.data![index];
                return ListTile(
                  leading: Checkbox(
                    value: season.allWatched == true,
                    onChanged: (bool? newValue) async {
                      if (newValue != null) {
                        if (newValue) {
                          await _markAllEpisodesAsWatched(season);
                        } else {
                          await _unmarkAllEpisodesAsWatched(season);
                        }
                      }
                    },
                  ),
                  title: Text(season.name),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EpisodesPage(
                            titleId: widget.titleId, seasonId: season.id),
                      ),
                    );
                    _getSeasons();
                    setState(() {});
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
