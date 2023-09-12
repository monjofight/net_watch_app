class Season {
  final int id;
  final int titleId;
  final String name;
  bool allWatched;

  Season(
      {required this.id,
      required this.titleId,
      required this.name,
      required this.allWatched});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['ID'],
      titleId: json['TitleID'],
      name: json['Name'],
      allWatched: json['AllWatched'],
    );
  }
}
