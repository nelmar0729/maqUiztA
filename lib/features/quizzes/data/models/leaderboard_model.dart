class LeaderboardUser {
  final int userId;
  final String firstName;
  final String lastName;
  final int score;
  final int totalAnswered;
  final String avatar;

  LeaderboardUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.score,
    required this.totalAnswered,
    required this.avatar,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      score: json['score'],
      totalAnswered: json['total_answered'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'score': score,
      'total_answered': totalAnswered,
      'avatar': avatar,
    };
  }

  String get fullName => '$firstName $lastName';
}
