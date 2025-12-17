import 'package:callparts/service/auth/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_text_field.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _keyController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    try {
      bool success = await _authService.resetPassword(
        email: widget.email,
        key: _keyController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đặt lại mật khẩu thành công! Vui lòng đăng nhập.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } else {
        setState(() {
          _errorMessage = _authService.message_error;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color with App text
          Container(
            width: double.infinity,
            color: AppColors.buttonColor,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Text1(
                  text1: 'Auto Parts App',
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),
          // Main content
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text1(
                          text1: 'Reset Password',
                          size: 24,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Nhập mã xác thực đã được gửi đến ${widget.email}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Mã xác thực',
                          icon: Icons.vpn_key,
                          controller: _keyController,
                        ),
                        CustomTextField(
                          label: 'Mật khẩu mới',
                          icon: Icons.lock,
                          icon2: Icons.visibility,
                          controller: _newPasswordController,
                          obscureText: true,
                        ),
                        CustomTextField(
                          label: 'Xác nhận mật khẩu',
                          icon: Icons.lock,
                          icon2: Icons.visibility,
                          controller: _confirmPasswordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: 'Đặt lại mật khẩu',
                                onTap: _handleResetPassword,
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Nhớ mật khẩu? '),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Đăng nhập',
                                style: TextStyle(
                                  color: AppColors.buttonColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
