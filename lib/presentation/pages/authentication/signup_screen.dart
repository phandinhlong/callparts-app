import 'package:callparts/presentation/pages/home/home_page.dart';
import 'package:callparts/service/auth/auth_services.dart';
import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_text_field.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'AuthWidgets/auth_tab.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _rememberMe = false;
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();
  final TextEditingController _confirmText = TextEditingController();
  final TextEditingController _nameText = TextEditingController();
  final TextEditingController _phoneText = TextEditingController();
  late AuthService auth = AuthService();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
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
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text1(
                            text1: 'SignUp',
                            size: 24,
                            color: AppColors.buttonColor,
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
                            controller: _emailText,
                          ),
                          CustomTextField(
                            label: 'Name',
                            icon: Icons.person,
                            controller: _nameText,
                          ),
                          CustomTextField(
                            label: 'Phone (tùy chọn)',
                            icon: Icons.phone,
                            controller: _phoneText,
                          ),
                          CustomTextField(
                            label: 'Password',
                            icon: Icons.lock,
                            icon2: Icons.visibility,
                            controller: _passwordText,
                            obscureText: true,
                          ),
                          CustomTextField(
                            label: 'Confirm Password',
                            icon: Icons.lock,
                            icon2: Icons.visibility,
                            controller: _confirmText,
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
                            ],
                          ),
                          const SizedBox(height: 20),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : CustomButton(
                              text: 'Signup',
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = '';
                                });
                                try {
                                  bool success = await auth.register(
                                    email: _emailText.text,
                                    password: _passwordText.text,
                                    repass: _confirmText.text,
                                    name: _nameText.text,
                                    phone: _phoneText.text,
                                  );
                                  if (success) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Đăng ký thành công. Vui lòng kiểm tra email để kích hoạt tài khoản.'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const LoginScreen()),
                                    );
                                  } else {
                                    setState(() {
                                      _errorMessage = auth.message_error;
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    _errorMessage = auth.message_error;
                                  });
                                } finally {
                                  setState(() {
                                    _isLoading = false;
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
                                      transitionDuration:
                                      const Duration(milliseconds: 300),
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const LoginScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const beginOffset = Offset(-1.0, 0.0);
                                        const endOffset = Offset.zero;
                                        var tween = Tween(
                                            begin: beginOffset,
                                            end: endOffset)
                                            .chain(CurveTween(
                                            curve: Curves.easeInOut));
                                        var fadeTween =
                                        Tween<double>(begin: 0.0, end: 1.0);
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
                                  'Login',
                                  style: TextStyle(
                                    color: Color(0xFF1A73E8),
                                    // Replace with your specific color
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
