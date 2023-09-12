class NetflixTitle {
  final int id;
  final String name;
  bool allWatched;

  NetflixTitle(
      {required this.id, required this.name, required this.allWatched});

  factory NetflixTitle.fromJson(Map<String, dynamic> json) {
    return NetflixTitle(
      id: json['ID'],
      name: json['Name'],
      allWatched: json['AllWatched'],
    );
  }
}
