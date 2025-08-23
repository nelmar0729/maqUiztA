// lib/features/auth/data/RemoteDataSources/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/shared/constants.dart';
import '/shared/response.dart';
import '/features/subjects/data/models/subject_model.dart';

/// This abstract class is like a "contract" for how to get user data from an API.
/// It says: "Any class that implements me MUST have a login method that returns a UserModel."
/// This keeps your code organized, easy to swap/replace, and testable.
abstract class RemoteDataSource {
  /// The login method will accept an email and password,
  /// contact the backend (usually using an HTTP request), and
  /// return a UserModel object if login is successful.

  Future<ResponseResult> joinSubject(String userId, String code);

  Future<List<SubjectModel>> fetchSubjects(String userId);
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
  Future<List<SubjectModel>> fetchSubjects(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.subjectEndpoint),
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
}
