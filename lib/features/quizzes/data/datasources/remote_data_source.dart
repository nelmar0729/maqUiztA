// lib/features/auth/data/RemoteDataSources/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/shared/constants.dart';
import '/shared/response.dart';
import '/features/quizzes/data/models/quiz_model.dart';
import '/features/quizzes/data/models/question_model.dart';
import '/features/quizzes/data/models/leaderboard_model.dart';

/// This abstract class is like a "contract" for how to get user data from an API.
/// It says: "Any class that implements me MUST have a login method that returns a UserModel."
/// This keeps your code organized, easy to swap/replace, and testable.
abstract class RemoteDataSource {
  /// The login method will accept an email and password,
  /// contact the backend (usually using an HTTP request), and
  /// return a UserModel object if login is successful.

  Future<ResponseResult> joinSubject(String userId, String code);

  Future<List<QuizModel>> fetchQuizzes(String userId);
  Future<ResponseResult> studentAnswer(
    String userId,
    int quizId,
    int questionId,
    int choiceId,
  );
  Future<List<LeaderboardUser>> leaderboardByQuiz(int quizId, String userId);
  Future<List<QuestionModel>> fetchQuestions(int quizId, String userId);
  // You can add more methods here, like:
  // Future<UserModel> register(...);
  // Future<UserModel> getUserById(int userId);
  // etc.
}

/// This class is the "actual worker" that will do the API call or fetch data from the server.
/// It implements (follows) the RemoteDataSource contract above.
///
/// For now, this is a SAMPLE version (it just pretends to log in).
/// In a real app, you'll add code here to call your real backend API using http/dio.
class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<ResponseResult> joinSubject(String userId, String code) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.subjectEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {
          'user_id': userId,
          'access_token': code,
          'action': "joinSubject",
        },
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        final isSuccess = response.statusCode == 200 && data['error'] != true;
        final message = data['message'] ?? AppConstants.errorGeneric;
        return ResponseResult(success: isSuccess, message: message);
      } else {
        return ResponseResult(
          success: false,
          message: "Server returned HTML instead of JSON.",
        );
      }
    } catch (e) {
      return ResponseResult(success: false, message: "Exception: $e");
    }
  }

  @override
  Future<List<QuizModel>> fetchQuizzes(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.quizzesEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'user_id': userId, 'action': "fetchQuizzes"},
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
  Future<List<QuestionModel>> fetchQuestions(int quizId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.quizzesEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {
          'quiz_id': quizId.toString(),
          'userId': userId,
          'action': "fetchQuestions",
        },
      );
     

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final List<dynamic> list = data['data'];
          return list.map((json) => QuestionModel.fromJson(json)).toList();
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
  Future<ResponseResult> studentAnswer(
    String userId,
    int quizId,
    int questionId,
    int choiceId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.quizzesEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {
          'user_id': userId,
          'quiz_id': quizId.toString(),
          'question_id': questionId.toString(),
          'choice_id': choiceId.toString(),
          'action': "studentAnswer",
        },
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        final isSuccess = response.statusCode == 200 && data['error'] != true;
        final message = data['message'] ?? AppConstants.errorGeneric;
        return ResponseResult(success: isSuccess, message: message);
      } else {
        return ResponseResult(
          success: false,
          message: "Server returned HTML instead of JSON.",
        );
      }
    } catch (e) {
      return ResponseResult(success: false, message: "Exception: $e");
    }
  }

  @override
  Future<List<LeaderboardUser>> leaderboardByQuiz(
    int quizId,
    String userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.quizzesEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {
          'quiz_id': quizId.toString(),
          'user_id': userId,
          'action': "leaderboardByQuiz",
        },
      );
      // print(response.body);
      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final List<dynamic> list = data['data'];
          return list.map((json) => LeaderboardUser.fromJson(json)).toList();
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
