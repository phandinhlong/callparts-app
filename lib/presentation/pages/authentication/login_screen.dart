import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/pages/authentication/AuthWidgets/auth_tab.dart';
import 'package:callparts/presentation/pages/authentication/forgot_password_screen.dart';
import 'package:callparts/presentation/pages/authentication/signup_screen.dart';
import 'package:callparts/presentation/pages/home/home_page.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_text_field.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/service/auth/auth_services.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final AuthService authService = AuthService();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String _errorMessage = '';
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
                height: MediaQuery.of(context).size.height * 0.72,
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
                          text1: 'Login',
                          size: 24,
                        ),if (_errorMessage.isNotEmpty)
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
                          controller: emailTextController,
                        ),
                        CustomTextField(
                          label: 'Password',
                          icon: Icons.lock,
                          icon2: Icons.visibility,
                          controller: passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value!;
                                    });
                                  },
                                  activeColor: const Color(0xFF008FD5),
                                ),
                                const Text('Remember me'),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const ForgotPasswordScreen()),
                                );
                              },
                              child: const Text1(
                                text1: 'Forgot the password?',
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                            text: 'Login',
                            onTap: () async {
                              setState(() {
                                _errorMessage = '';
                              });
                              bool success = await authService.login(
                                emailTextController.text,
                                passwordController.text,
                              );
                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                );
                              }else{
                                setState(() {
                                  _errorMessage = authService.message_error;
                                });
                              }
                            }),
                        const SizedBox(height: 20),
                        const Text('or continue with'),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            AuthTab(
                              image: 'images/icons8-facebook-48.png',
                              text: 'Facebook',
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            AuthTab(
                              image: 'images/icons8-google-48.png',
                              text: 'Google',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 300),
                                    pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const beginOffset = Offset(1.0, 0.0);
                                      const endOffset = Offset.zero;
                                      var tween = Tween(begin: beginOffset, end: endOffset).chain(CurveTween(curve: Curves.easeInOut));
                                      var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: FadeTransition(
                                          opacity: animation.drive(fadeTween),
                                          child: child,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color(0xFF1A73E8),
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
