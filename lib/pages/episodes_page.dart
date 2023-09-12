// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../models/episode.dart';
import '../services/api_service.dart';

class EpisodesPage extends StatefulWidget {
  final int titleId;
  final int seasonId;

  const EpisodesPage({Key? key, required this.titleId, required this.seasonId})
      : super(key: key);

  @override
  EpisodesPageState createState() => EpisodesPageState();
}

class EpisodesPageState extends State<EpisodesPage> {
  late Future<List<Episode>> episodes;
  final ApiService apiService = ApiService();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _getEpisodes();
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }

  Future<void> _getEpisodes() async {
    episodes = apiService.getEpisodes(widget.titleId, widget.seasonId);
  }

  Future<void> _toggleEpisodeWatchedStatus(
      Episode episode, bool? newValue) async {
    if (newValue != null) {
      try {
        if (newValue) {
          await apiService.watchEpisode(
              episode.titleId, episode.seasonId, episode.id);
        } else {
          await apiService.unwatchEpisode(
              episode.titleId, episode.seasonId, episode.id);
        }

        // 現在のエピソードリストのコピーを作成します。
        var updatedEpisodes = (await episodes).map((e) {
          if (e.id == episode.id) {
            // エピソードのwatchedステータスを更新します。
            return e.copyWith(watched: newValue);
          }
          return e;
        }).toList();

        if (_isDisposed) {
          return;
        }
        setState(() {
          episodes = Future.value(updatedEpisodes);
        });
      } catch (error) {
        print("エピソードの状態を切り替えるエラー: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Episodes')),
      body: FutureBuilder<List<Episode>>(
        future: episodes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Episode episode = snapshot.data![index];
                return ListTile(
                  leading: Checkbox(
                    value: episode.watched,
                    onChanged: (newValue) {
                      _toggleEpisodeWatchedStatus(episode, newValue);
                    },
                  ),
                  title: Text(episode.name),
                  trailing: Image.network(episode.image),
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
