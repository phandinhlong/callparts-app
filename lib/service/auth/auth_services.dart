import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../data/models/users.dart';
import '../../presentation/pages/authentication/login_screen.dart';
import '../method_api.dart';

class AuthService {
  late String message_error = '';
  static String? token_auth = null;
  static User? user;

  String? get message => message_error;

  String? get tokenAuth => token_auth;

  Future<bool> login(String email, String password) async {
    message_error = '';
    String? validationError =
        validateInput({'email': email, 'password': password});
    if (validationError != null) {
      message_error = validationError;
      return false;
    }

    if (!await checkNetworkConnection()) {
      message_error = "Kết nối mạng thất bại";
      return false;
    }
    try {
      final requestData = {'email': email, 'password': password};
      final response = await postRequest(
          url: urlAPI,
          endpoint: "login",
          requestData: requestData,
          options: defaultHeaders(),
          timeout: const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final responseData = response.data;
        token_auth = responseData['token'];
        user = User.fromJson(responseData['user']);
        message_error = "Đăng nhập thành công";
        return true;
      } else if (response.statusCode == 401) {
        message_error = "Invalid credentials";
        return false;
      } else if (response.statusCode == 422) {
        final errorData = response.data;
        message_error = errorData['message'] ?? 'Validation failed';
        return false;
      } else {
        message_error = "Server error: ${response.statusCode}";
        return false;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        message_error =
            "Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng của bạn và đảm bảo máy chủ đang chạy.";
      } else if (e.response != null) {
        message_error = "Server error: ${e.response?.statusCode}";
      } else {
        message_error = "Không thể kết nối tới server: $e";
      }
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String repass,
    required String name,
    String? phone,
  }) async {
    message_error = '';
    try {
      String? validationError = validateInput({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      });

      if (validationError != null) {
        message_error = validationError;
        return false;
      }
      if (repass.isEmpty) {
        message_error = 'Vui lòng xác nhận mật khẩu';
        return false;
      }
      if (password != repass) {
        message_error = "Mật khẩu không khớp";
        return false;
      }

      if (!await checkNetworkConnection()) {
        message_error = "Không có kết nối mạng";
        return false;
      }

      final requestData = {
        'email': email,
        'password': password,
        'repass': repass,
        'name': name,
        if (phone != null) 'phone': phone,
      };

      final response = await postRequest(
        url: urlAPI,
        endpoint: "register",
        requestData: requestData,
        options: defaultHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        message_error = response.data['mes'] ?? 'Đăng ký thành công';
        return true;
      } else {
        return false;
      }
    } catch (e) {
      message_error = "Email đã tồn tại";
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    String? tmp = token_auth;
    user = null;
    token_auth = null;
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    await getRequest(
        url: urlAPI, endpoint: "logout", options: getApiHeaders(tmp));
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
    message_error = "Logout successful";
  }

  Future<bool> forgotPassword(String email) async {
    message_error = '';
    try {
      String? validationError = validateInput({'email': email});
      if (validationError != null) {
        message_error = validationError;
        return false;
      }

      if (!await checkNetworkConnection()) {
        message_error = 'Không có kết nối mạng';
        return false;
      }

      final requestData = {'email': email};
      final response = await postRequest(
        url: urlAPI,
        endpoint: "forget-pass",
        requestData: requestData,
        options: defaultHeaders(),
      );

      if (response.statusCode == 200) {
        message_error = 'Email lấy lại mật khẩu đã được gửi';
        return true;
      } else if (response.statusCode == 404) {
        message_error = 'Email không tồn tại';
        return false;
      } else if (response.statusCode == 429) {
        message_error = 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
        return false;
      } else if (response.statusCode == 400) {
        message_error = response.data['mes'] ?? 'Yêu cầu không hợp lệ';
        return false;
      } else {
        message_error = 'Lỗi server: ${response.statusCode}';
        return false;
      }
    } catch (e, st) {
      message_error = 'Đã xảy ra lỗi, vui lòng thử lại';
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String key,
    required String newPassword,
    required String confirmPassword,
  }) async {
    message_error = '';
    try {
      // Validate inputs
      String? validationError = validateInput({
        'email': email,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });
      if (validationError != null) {
        message_error = validationError;
        return false;
      }

      if (key.isEmpty) {
        message_error = 'Vui lòng nhập mã xác thực';
        return false;
      }

      if (newPassword != confirmPassword) {
        message_error = 'Mật khẩu xác nhận không khớp';
        return false;
      }

      if (!await checkNetworkConnection()) {
        message_error = 'Không có kết nối mạng';
        return false;
      }

      // Call reset-pass endpoint
      final requestData = {
        'password': newPassword,
        'repass': confirmPassword,
      };
      
      final response = await postRequest(
        url: urlAPI,
        endpoint: "reset-pass/$email/$key",
        requestData: requestData,
        options: defaultHeaders(),
      );

      if (response.statusCode == 200) {
        message_error = 'Đặt lại mật khẩu thành công';
        return true;
      } else if (response.statusCode == 404) {
        message_error = 'Mã xác thực không hợp lệ hoặc đã hết hạn';
        return false;
      } else if (response.statusCode == 400) {
        message_error = response.data['mes'] ?? 'Yêu cầu không hợp lệ';
        return false;
      } else {
        message_error = 'Lỗi server: ${response.statusCode}';
        return false;
      }
    } catch (e) {
      message_error = 'Đã xảy ra lỗi, vui lòng thử lại';
      return false;
    }
  }

  String? validateInput(Map<String, dynamic> data) {
    if (data['email'] != null) {
      final email = data['email'].toString();
      if (email.isEmpty) return 'Vui lòng nhập email';

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) return 'Email không hợp lệ';
    }

    if (data['password'] != null) {
      final password = data['password'].toString();
      if (password.isEmpty) return 'Vui lòng nhập mật khẩu';
      if (password.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
    }

    if (data['name'] != null) {
      final name = data['name'].toString();
      if (name.isEmpty) return 'Vui lòng nhập tên';
      if (name.length < 2) return 'Tên phải có ít nhất 2 ký tự';
    }

    if (data['phone'] != null) {
      final phone = data['phone']?.toString() ?? '';
      if (phone.isNotEmpty && phone.length != 10) {
        return 'Số điện thoại không hợp lệ';
      }
    }

    if (data['code'] != null) {
      final code = data['code'].toString();
      if (code.isEmpty) return 'Vui lòng nhập mã';
      if (code.length != 6) return 'Mã phải có 6 ký tự';
    }

    if (data['currentPassword'] != null) {
      final currentPassword = data['currentPassword'].toString();
      if (currentPassword.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại';
      if (currentPassword.length < 8) {
        return 'Mật khẩu hiện tại phải có ít nhất 8 ký tự';
      }
    }

    if (data['newPassword'] != null) {
      final newPassword = data['newPassword'].toString();
      if (newPassword.isEmpty) return 'Vui lòng nhập mật khẩu mới';
      if (newPassword.length < 8) {
        return 'Mật khẩu mới phải có ít nhất 8 ký tự';
      }
    }

    if (data['confirmPassword'] != null) {
      final confirmPassword = data['confirmPassword'].toString();
      if (confirmPassword.isEmpty) return 'Vui lòng xác nhận mật khẩu mới';
      if (confirmPassword.length < 8) {
        return 'Mật khẩu xác nhận phải có ít nhất 8 ký tự';
      }
    }

    return null;
  }

  Future<bool> checkNetworkConnection() async {
    try {
      final response = await Dio()
          .get('https://www.google.com')
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginGoogle() async {
    message_error = '';
    final googleSignIn = GoogleSignIn.instance;

    try {
      if (!await checkNetworkConnection()) {
        message_error = "Kết nối mạng thất bại";
        return false;
      }
      await googleSignIn.initialize();

      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        message_error = "Không thể lấy thông tin xác thực từ Google";
        return false;
      }

      final response = await putRequest(
        url: urlAPI,
        endpoint: "login/google",
        requestData: {'token': idToken},
        timeout: const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 200) {
          token_auth = responseData['token'];
          user = User.fromJson(responseData['user']);
          message_error = "Đăng nhập Google thành công";
          return true;
        }else{
          return false;
        }
      } else if (response.statusCode == 401) {
        message_error = "Xác thực Google thất bại";
        await googleSignIn.signOut();
        return false;
      } else if (response.statusCode == 422) {
        final errorData = response.data;
        message_error = errorData['message'] ?? 'Validation failed';
        await googleSignIn.signOut();
        return false;
      } else {
        message_error = "Server error: ${response.statusCode}";
        await googleSignIn.signOut();
        return false;
      }
    } on DioException catch (e) {
      await googleSignIn.signOut();
      if (e.type == DioExceptionType.connectionError) {
        message_error =
            "Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng của bạn.";
      } else if (e.response != null) {
        message_error = "Server error: ${e.response?.statusCode}";
      } else {
        message_error = "Không thể kết nối tới server";
      }
      return false;
    } catch (e) {
      if (e.toString().contains('cancel') || e.toString().contains('CANCEL')) {
        message_error = '';
        return false;
      }
      await googleSignIn.signOut();
      message_error = "Đăng nhập Google thất bại: ${e.toString()}";
      return false;
    }
  }
  Future<bool> loginFacebook() async {
    message_error = '';
    
    try {
      if (!await checkNetworkConnection()) {
        message_error = "Kết nối mạng thất bại";
        return false;
      }

      // Login with Facebook
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken?.tokenString;
        
        if (accessToken == null) {
          message_error = "Không thể lấy thông tin xác thực từ Facebook";
          return false;
        }

        final response = await putRequest(
          url: urlAPI,
          endpoint: "login/facebook",
          requestData: {'token': accessToken},
          timeout: const Duration(seconds: 10),
        );
        print(accessToken);
        print(response.statusCode);
        print(response.data);

        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData['status'] == 200) {
            token_auth = responseData['token'];
            user = User.fromJson(responseData['user']);
            message_error = "Đăng nhập Facebook thành công";
            return true;
          } else {
            message_error = responseData['message'] ?? "Đăng nhập thất bại";
            await FacebookAuth.instance.logOut();
            return false;
          }
        } else if (response.statusCode == 401) {
          message_error = "Xác thực Facebook thất bại";
          await FacebookAuth.instance.logOut();
          return false;
        } else if (response.statusCode == 422) {
          final errorData = response.data;
          message_error = errorData['message'] ?? 'Validation failed';
          await FacebookAuth.instance.logOut();
          return false;
        } else {
          message_error = "Server error: ${response.statusCode}";
          await FacebookAuth.instance.logOut();
          return false;
        }
      } else if (result.status == LoginStatus.cancelled) {
        message_error = '';
        return false;
      } else {
        message_error = "Đăng nhập Facebook thất bại";
        return false;
      }
    } on DioException catch (e) {
      await FacebookAuth.instance.logOut();
      if (e.type == DioExceptionType.connectionError) {
        message_error =
            "Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng của bạn.";
      } else if (e.response != null) {
        message_error = "Server error: ${e.response?.statusCode}";
      } else {
        message_error = "Không thể kết nối tới server";
      }
      return false;
    } catch (e) {
      if (e.toString().contains('cancel') || e.toString().contains('CANCEL')) {
        message_error = '';
        return false;
      }
      await FacebookAuth.instance.logOut();
      message_error = "Đăng nhập Facebook thất bại: ${e.toString()}";
      return false;
    }
  }
}
