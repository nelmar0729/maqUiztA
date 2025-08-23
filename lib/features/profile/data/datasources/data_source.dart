// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/quiz_history_model.dart';
import '/shared/constants.dart';
import '/shared/response.dart';
import 'dart:io';

/// This abstract class is like a "contract" for how to get user data from an API.
/// It says: "Any class that implements me MUST have a login method that returns a UserModel."
/// This keeps your code organized, easy to swap/replace, and testable.
abstract class DataSource {
  /// The login method will accept an email and password,
  /// contact the backend (usually using an HTTP request), and
  /// return a UserModel object if login is successful.

  Future<ResponseResult> updateUserData(
    String firstname,
    String lastname,
    String studentId,
    String email,
    File? avatar, // <-- File type for image, nullable if not changed
    int programId,
    String yearLevel,
    String section,
    String userId,
  );
  Future<UserModel> getUserData(String userId);

  Future<ResponseResult> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    String userId,
  );
  Future<ResponseResult> verifyEmail(String email, String token);
  Future<List<QuizHistoryModel>> getQuizHistory(String userId);
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
  Future<ResponseResult> updateUserData(
    String firstname,
    String lastname,
    String studentId,
    String email,
    File? avatar,
    int programId,
    String yearLevel,
    String section,
    String userId,
  ) async {
    try {
      final uri = Uri.parse(AppConstants.profileEndpoint);

      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          "User-Agent": "Mozilla/5.0 (compatible; FlutterApp/1.0)",
        })
        ..fields['first_name'] = firstname
        ..fields['last_name'] = lastname
        ..fields['student_id'] = studentId
        ..fields['email'] = email
        ..fields['program_id'] = programId.toString()
        ..fields['year_level'] = yearLevel
        ..fields['section'] = section
        ..fields['user_id'] = userId
        ..fields['action'] = "updateUserData";

      if (avatar != null) {
        request.files.add(
          await http.MultipartFile.fromPath('avatar', avatar.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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
      return ResponseResult(success: false, message: "Update failed: $e");
    }
  }

  @override
  Future<UserModel> getUserData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.profileEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'action': "getUserData", 'user_id': userId},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          return UserModel.fromJson(data['data']);
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
  Future<ResponseResult> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    String userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.profileEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {
          'action': "changePassword",
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
          'user_id': userId,
        },
      );

      if (response.body.isEmpty) {
        return ResponseResult(
          success: false,
          message: "Server returned empty response.",
        );
      }

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
  Future<ResponseResult> verifyEmail(String email, String token) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.profileEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'email': email, 'token': token, 'action': "verifyEmail"},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        final isSuccess = response.statusCode == 200 && data['error'] != true;
        final message = data['message'] ?? AppConstants.errorGeneric;
        return ResponseResult(
          success: isSuccess,
          message: message,
          data: data['data'],
        );
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
  Future<List<QuizHistoryModel>> getQuizHistory(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.profileEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'user_id': userId, 'action': "getQuizHistory"},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final List<dynamic> list = data['data'];
          return list.map((json) => QuizHistoryModel.fromJson(json)).toList();
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
