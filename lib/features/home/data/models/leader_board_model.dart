class LeaderboardEntryModel {
  final String name;
  final int score;
  final int rank;

  LeaderboardEntryModel({
    required this.name,
    required this.score,
    required this.rank,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      name: json['name'],
      score: int.parse(json['score'].toString()),
      rank: int.parse(json['rank'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'rank': rank,
    };
  }
}
