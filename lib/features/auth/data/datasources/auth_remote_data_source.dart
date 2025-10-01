// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/program_model.dart';
import '/shared/constants.dart';
import '/shared/response.dart';

/// This abstract class is like a "contract" for how to get user data from an API.
/// It says: "Any class that implements me MUST have a login method that returns a UserModel."
/// This keeps your code organized, easy to swap/replace, and testable.
abstract class AuthRemoteDataSource {
  /// The login method will accept an email and password,
  /// contact the backend (usually using an HTTP request), and
  /// return a UserModel object if login is successful.
  Future<ResponseResult> login(String email, String password);
  Future<ResponseResult> register(
    String firstname,
    String lastname,
    String studentId,
    String email,
    String password,
  );

  Future<ResponseResult> verifyEmail(String email, String token);
  Future<ResponseResult> resendCode(String email);
  Future<List<ProgramModel>> getPrograms();
  Future<ResponseResult> isEnrolled(String userId);

  Future<ResponseResult> enrollStudent(
    String userId,
    int programId,
    String yearLevel,
    String section,
  );
  Future<ResponseResult> sendPasswordResetLink(String email);

  // You can add more methods here, like:
  // Future<UserModel> register(...);
  // Future<UserModel> getUserById(int userId);
  // etc.
}

/// This class is the "actual worker" that will do the API call or fetch data from the server.
/// It implements (follows) the AuthRemoteDataSource contract above.
///
/// For now, this is a SAMPLE version (it just pretends to log in).
/// In a real app, you'll add code here to call your real backend API using http/dio.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<ResponseResult> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'email': email, 'password': password, 'action': 'login'},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        final isSuccess = response.statusCode == 200 && data['error'] != true;
        final message = data['message'] ?? AppConstants.errorGeneric;
        return ResponseResult(
          success: isSuccess,
          message: message,
          data: data['data'], // keep this
          statusCode: data['statusCode'], // <-- include status code
        );
      } else {
        return ResponseResult(
          success: false,
          message: "Server returned HTML instead of JSON.",
        );
      }
    } catch (e) {
      return ResponseResult(
        success: false,
        message:
            "Something went wrong. Please try again. Kindly contact support if the issue persists.",
      );
    }
  }

  @override
  Future<ResponseResult> enrollStudent(
    String userId,
    int programId,
    String yearLevel,
    String section,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {
          'user_id': userId,
          'program_id': programId.toString(),
          'year_level': yearLevel,
          'section': section,
          'action': "enrollStudent",
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
  Future<ResponseResult> register(
    String firstname,
    String lastname,
    String studentId,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {
          'first_name': firstname,
          'last_name': lastname,
          'student_id': studentId,
          'email': email,
          'password': password,
          'action': "register",
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
      return ResponseResult(
        success: false,
        message:
            "Something went wrong. Please try again. Kindly contact support if the issue persists.",
      );
    }
  }

  @override
  Future<ResponseResult> verifyEmail(String email, String token) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
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
  Future<ResponseResult> resendCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'email': email, 'action': "resendCode"},
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
  Future<List<ProgramModel>> getPrograms() async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'action': "getPrograms"},
      );

      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);
        if (response.statusCode == 200 && data['error'] != true) {
          final List<dynamic> programList = data['data'];
          return programList
              .map((json) => ProgramModel.fromJson(json))
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
  Future<ResponseResult> isEnrolled(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "User-Agent":
              "Mozilla/5.0 (compatible; FlutterApp/1.0)", // 👈 important for InfinityFree
        },
        body: {'user_id': userId, 'action': "isEnrolled"},
      );

      // Quick check: does response look like JSON or HTML?
      if (response.body.trim().startsWith("{") ||
          response.body.trim().startsWith("[")) {
        final data = json.decode(response.body);

        final isSuccess = response.statusCode == 200 && data['error'] != true;
        final message = data['message'] ?? AppConstants.errorGeneric;

        return ResponseResult(success: isSuccess, message: message);
      } else {
        // Server returned HTML (InfinityFree block page)
        return ResponseResult(
          success: false,
          message:
              "Server returned HTML instead of JSON. Likely blocked by hosting.",
        );
      }
    } catch (e) {
      return ResponseResult(success: false, message: "Exception: $e");
    }
  }

  @override
  Future<ResponseResult> sendPasswordResetLink(String email) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.authEndpoint),
        headers: AppConstants.defaultHeaders, // <-- use shared headers
        body: {'email': email, 'action': "sendPasswordResetLink"},
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
}
