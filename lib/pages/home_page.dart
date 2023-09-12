// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../models/title.dart';
import 'seasons_page.dart';
import '../services/api_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<NetflixTitle>> titles;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _getTitles();
  }

  Future<void> _getTitles() async {
    titles = apiService.getTitles();
  }

  Future<void> markAllEpisodesAsWatched(int titleId) async {
    await apiService.watchEpisodesOfTitle(titleId);
  }

  Future<void> unmarkAllEpisodesAsWatched(int titleId) async {
    await apiService.unwatchEpisodesOfTitle(titleId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<NetflixTitle>>(
          future: titles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    NetflixTitle title = snapshot.data![index];
                    return ListTile(
                      leading: Checkbox(
                          value: title.allWatched == true,
                          onChanged: (bool? newValue) async {
                            if (newValue != null) {
                              if (newValue) {
                                await markAllEpisodesAsWatched(title.id);
                              } else {
                                await unmarkAllEpisodesAsWatched(title.id);
                              }
                              setState(() {
                                title.allWatched = newValue;
                              });
                            }
                          }),
                      title: Text(snapshot.data![index].name),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SeasonsPage(titleId: snapshot.data![index].id),
                          ),
                        );
                        _getTitles();
                        setState(() {});
                      },
                    );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
