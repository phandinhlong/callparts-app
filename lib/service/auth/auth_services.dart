import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../model/users.dart';
import '../method_api.dart';

class AuthService {
  late String message_error = '';
  late String token_auth = '';

  String? get message => message_error;

  Future<bool> login(String email, String password) async {
    if (!validateInput({'email': email, 'password': password})) {
      message_error = "Tài khoảng hoặc mật khẩu chưa đúng";
      print(message_error);
      return false;
    }

    if (!await checkNetworkConnection()) {
      message_error = "Kết nối mạng thất bại";
      print(message_error);
      return false;
    }
    try {
      final requestData = {'email': email, 'password': password};
      final response = await postRequest(
        url: urlAPI,
        endpoint: "login",
        requestData: requestData,
        headers: defaultHeaders(),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        token_auth = responseData['token'];
        User.fromJson(responseData['user']);
        message_error = "Đăng nhập thành công";
        print(message_error);
        return true;
      } else if (response.statusCode == 401) {
        message_error = "Invalid credentials";
        print(message_error);
        return false;
      } else if (response.statusCode == 422) {
        final errorData = jsonDecode(response.body);
        message_error = errorData['message'] ?? 'Validation failed';
        print(message_error);
        return false;
      } else {
        message_error = "Server error: ${response.statusCode}";
        print(message_error);
        return false;
      }
    } catch (e) {
      message_error = "Không thể kết nối tới server: $e";
      print(message_error);
      return false;
    }
  }

  bool validateInput(Map<String, dynamic> data) {
    if (data['email'] != null) {
      final email = data['email'].toString();
      if (email.isEmpty) return false;

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) return false;
    }

    if (data['password'] != null) {
      final password = data['password'].toString();
      if (password.isEmpty || password.length < 8) return false;
    }

    if (data['name'] != null) {
      final name = data['name'].toString();
      if (name.isEmpty || name.length < 2) return false;
    }

    if (data['code'] != null) {
      final code = data['code'].toString();
      if (code.isEmpty || code.length != 6) return false;
    }

    if (data['currentPassword'] != null) {
      final currentPassword = data['currentPassword'].toString();
      if (currentPassword.isEmpty || currentPassword.length < 8) return false;
    }

    if (data['newPassword'] != null) {
      final newPassword = data['newPassword'].toString();
      if (newPassword.isEmpty || newPassword.length < 8) return false;
    }

    if (data['confirmPassword'] != null) {
      final confirmPassword = data['confirmPassword'].toString();
      if (confirmPassword.isEmpty || confirmPassword.length < 8) return false;
    }

    return true;
  }

  Future<bool> checkNetworkConnection() async {
    final response = await http
        .get(Uri.parse('https://www.google.com'))
        .timeout(const Duration(seconds: 5));
    return response.statusCode == 200;
  }
}
