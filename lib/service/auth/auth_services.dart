import 'package:callparts/presentation/pages/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../data/models/users.dart';
import '../../presentation/pages/authentication/login_screen.dart';
import '../../presentation/providers/cart_provider.dart';
import '../../presentation/providers/favorite_provider.dart';
import '../method_api.dart';

class AuthService {
  late String message_error = '';
  static String? token_auth = null;
  static User? user;

  static const String _keyToken = 'auth_token';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';

  String? get message => message_error;

  String? get tokenAuth => token_auth;

  Future<void> _saveCredentials(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserEmail, user.email);
    if (user.phone.isNotEmpty) {
      await prefs.setString(_keyUserPhone, user.phone);
    }
  }

  Future<bool> loadCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_keyToken);
      final userName = prefs.getString(_keyUserName);
      final userEmail = prefs.getString(_keyUserEmail);
      final userPhone = prefs.getString(_keyUserPhone);

      if (token != null && userName != null && userEmail != null) {
        token_auth = token;
        user = User(
          name: userName,
          email: userEmail,
          phone: userPhone ?? '',
          avatar: '',
          gender: '',
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
  }

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
        await _saveCredentials(token_auth!, user!);
        message_error = "Đăng nhập thành công";
        return true;
      } else if (response.statusCode == 401) {
        message_error = response.data['error'];
        return false;
      } else if (response.statusCode == 422) {
        message_error = response.data['error'];
        return false;
      } else {
        message_error = "Server error: ${response.data['error']}";
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
    print(tmp);
    await _clearCredentials();
    user = null;
    token_auth = null;

    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
    } catch (e) {
      print('Google sign out error: $e');
    }

    try {
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print('Facebook sign out error: $e');
    }

    if (tmp != null) {
      try {
        await getRequest(
            url: urlAPI, endpoint: "logout", options: getApiHeaders(tmp));
      } catch (e) {
        print('Backend logout error: $e');
      }
    }

    if (context.mounted) {
      // Clear cart and favorites on logout
      try {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final favoriteProvider =
            Provider.of<FavoriteProvider>(context, listen: false);
        cartProvider.clearCart();
        favoriteProvider.clearFavorites();
      } catch (e) {
        print('Error clearing cart/favorites: $e');
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
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
      print(response.data);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 200) {
          token_auth = responseData['token'];
          print(token_auth);
          user = User.fromJson(responseData['user']);
          await _saveCredentials(token_auth!, user!);
          message_error = "Đăng nhập Google thành công";
          return true;
        } else {
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
        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData['status'] == 200) {
            token_auth = responseData['token'];
            user = User.fromJson(responseData['user']);
            // Auto-save credentials
            await _saveCredentials(token_auth!, user!);
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

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    message_error = '';

    try {
      // Validate inputs
      if (currentPassword.isEmpty) {
        message_error = 'Vui lòng nhập mật khẩu hiện tại';
        return false;
      }

      if (newPassword.isEmpty) {
        message_error = 'Vui lòng nhập mật khẩu mới';
        return false;
      }

      if (newPassword.length < 8) {
        message_error = 'Mật khẩu mới phải có ít nhất 8 ký tự';
        return false;
      }

      if (confirmPassword.isEmpty) {
        message_error = 'Vui lòng xác nhận mật khẩu mới';
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

      if (token_auth == null) {
        message_error = 'Vui lòng đăng nhập lại';
        return false;
      }

      final requestData = {
        'oldpass': currentPassword,
        'newpass': newPassword,
        'repass': confirmPassword,
      };

      final response = await postRequest(
        url: urlAPI,
        endpoint: 'change-pass',
        requestData: requestData,
        options: getApiHeaders(token_auth!),
      );

      if (response.statusCode == 200) {
        message_error = response.data['mes'] ??
            'Đổi mật khẩu thành công! Vui lòng đăng nhập lại.';
        return true;
      } else if (response.statusCode == 400) {
        // Handle validation errors
        if (response.data['error'] != null) {
          final errors = response.data['error'];
          if (errors is Map) {
            // Get first error message
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message_error = firstError.first;
            } else {
              message_error = firstError.toString();
            }
          } else {
            message_error =
                response.data['mes'] ?? 'Mật khẩu hiện tại không đúng';
          }
        } else {
          message_error =
              response.data['mes'] ?? 'Mật khẩu hiện tại không đúng';
        }
        return false;
      } else {
        message_error = 'Lỗi server: ${response.statusCode}';
        return false;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        message_error = 'Không thể kết nối đến máy chủ';
      } else if (e.response != null) {
        if (e.response!.statusCode == 400) {
          message_error =
              e.response!.data['mes'] ?? 'Mật khẩu hiện tại không đúng';
        } else {
          message_error = 'Lỗi server: ${e.response?.statusCode}';
        }
      } else {
        message_error = 'Không thể kết nối tới server';
      }
      return false;
    } catch (e) {
      message_error = 'Đã xảy ra lỗi: ${e.toString()}';
      return false;
    }
  }
}
