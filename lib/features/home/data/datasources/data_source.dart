// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/recent_quiz_model.dart';
import '../models/leader_board_model.dart';

import '/features/quizzes/data/models/quiz_model.dart';
import '/shared/constants.dart';
import '/features/subjects/data/models/subject_model.dart';

/// This abstract class is like a "contract" for how to get user data from an API.
/// It says: "Any class that implements me MUST have a login method that returns a UserModel."
/// This keeps your code organized, easy to swap/replace, and testable.
abstract class DataSource {
  /// The login method will accept an email and password,
  /// contact the backend (usually using an HTTP request), and
  /// return a UserModel object if login is successful.

  Future<UserModel> getUserData(String userId);
  Future<List<QuizModel>> fetchTodayQuizzes(String userId);
  Future<List<RecentQuizModel>> fetchRecentQuiz(String userId);
  Future<List<SubjectModel>> fetchSubjects(String userId);
  Future<Map<String, List<LeaderboardEntryModel>>> fetchLeaderboardsForStudent(
    String userId,
  );

  // You can add more methods here, like:
  // Future<UserModel> register(...);
  // Future<UserModel> getUserById(int userId);
  // etc.
}

/// This class is the "actual worker" that will do the API call or fetch data from the server.
/// It implements (follows) the DataSource contract above.
///
/// For now, this is a SAMPLE version (it just pretends to log in).
/// In a real app, you'll add code here to call your real backend API using http/dio.
class DataSourceImpl implements DataSource {
  @override
  Future<UserModel> getUserData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.homeEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'action': "getUserData", 'user_id': userId},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final userJson = data['data'];
          return UserModel.fromJson(userJson);
        } else {
          throw Exception(data['message'] ?? AppConstants.errorGeneric);
        }
      } else {
        throw Exception("Server returned HTML instead of JSON.");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  @override
  Future<List<QuizModel>> fetchTodayQuizzes(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.homeEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'user_id': userId, 'action': "fetchTodayQuizzes"},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final List<dynamic> list = data['data'];
          return list.map((json) => QuizModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? AppConstants.errorGeneric);
        }
      } else {
        throw Exception("Server returned HTML instead of JSON.");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  @override
  Future<List<RecentQuizModel>> fetchRecentQuiz(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.homeEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'user_id': userId, 'action': "fetchRecentQuiz"},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final List<dynamic> list = data['data'];
          return list.map((json) => RecentQuizModel.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? AppConstants.errorGeneric);
        }
      } else {
        throw Exception("Server returned HTML instead of JSON.");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  @override
  Future<List<SubjectModel>> fetchSubjects(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.homeEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'user_id': userId, 'action': "fetchSubjects"},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final List<dynamic> subjectList = data['data'];
          return subjectList
              .map((json) => SubjectModel.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? AppConstants.errorGeneric);
        }
      } else {
        throw Exception("Server returned HTML instead of JSON.");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }

  @override
  Future<Map<String, List<LeaderboardEntryModel>>> fetchLeaderboardsForStudent(
    String userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.homeEndpoint),
        body: {'user_id': userId, 'action': "fetchLeaderboardsForStudent"},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);

        if (response.statusCode == 200 && data['error'] != true) {
          final raw = data['data'];

          if (raw is Map<String, dynamic>) {
            // ✅ Normal case (has leaderboards grouped by subject)
            return raw.map(
              (subject, entries) => MapEntry(
                subject,
                (entries as List)
                    .map((json) => LeaderboardEntryModel.fromJson(json))
                    .toList(),
              ),
            );
          } else if (raw is List && raw.isEmpty) {
            // ✅ No leaderboard data case
            return {};
          }

          throw Exception("Unexpected data format for leaderboard");
        } else {
          throw Exception(data['message'] ?? AppConstants.errorGeneric);
        }
      } else {
        throw Exception("Server returned HTML instead of JSON.");
      }
    } catch (e) {
      throw Exception("Exception: $e");
    }
  }
}
