class Episode {
  final int titleId;
  final int seasonId;
  final int id;
  final String name;
  final String image;
  final bool watched;

  Episode(
      {required this.id,
      required this.titleId,
      required this.seasonId,
      required this.name,
      required this.image,
      required this.watched});

  Episode copyWith({
    int? id,
    int? titleId,
    int? seasonId,
    String? name,
    String? image,
    bool? watched,
  }) {
    return Episode(
      id: id ?? this.id,
      titleId: titleId ?? this.titleId,
      seasonId: seasonId ?? this.seasonId,
      name: name ?? this.name,
      image: image ?? this.image,
      watched: watched ?? this.watched,
    );
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['ID'],
      titleId: json['TitleID'],
      seasonId: json['SeasonID'],
      name: json['Name'],
      image: json['Image'],
      watched: json['Watched'],
    );
  }
}
