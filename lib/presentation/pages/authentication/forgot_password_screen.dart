import 'package:callparts/presentation/pages/authentication/reset_password_screen.dart';
import 'package:callparts/service/auth/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_text_field.dart';
import 'package:callparts/presentation/widgets/text1.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthService auth = AuthService();
  TextEditingController _emailTextController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                          text1: 'Forgot Password',
                          size: 24,
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: 'Email',
                          icon: Icons.email,
                          controller: _emailTextController,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Reset Password',
                          onTap: () async {
                            setState(() {
                              _errorMessage = '';
                            });
                            bool success = await auth
                                .forgotPassword(_emailTextController.text);
                            setState(() {
                              _errorMessage = auth.message_error; // ← cập nhật lỗi
                            });
                            if (success) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  ResetPasswordScreen(email: _emailTextController.text),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Remembered your password? '),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Login',
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
