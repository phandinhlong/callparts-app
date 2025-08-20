import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Screens/Authentication/signup_sreeen.dart';
import 'package:autopartsstoreapp/Screens/Home/home_screen.dart';


import '../../Constants/colors.dart';
import '../../Widgets/custombtn.dart';
import '../../Widgets/customtextfield.dart';
import '../../Widgets/detailstext1.dart';
import 'AuthWidgets/auth_tab.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color with News Wave text and image
          Container(
            width: double.infinity,
            color: AppColors.buttonColor, // Replace with your specific color
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 100), // Add some spacing from the top

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
                          text1: 'Login',
                          size: 24,
                        ),
                        const SizedBox(height: 20),
                        const CustomTextField(
                          label: 'Username',
                          icon: Icons.person,
                        ),
                        const CustomTextField(
                          label: 'Password',
                          icon: Icons.lock,
                          icon2: Icons.visibility,
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
                                  MaterialPageRoute(builder: (context) =>  const ForgotPasswordScreen()),
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
                        CustomButton(text: 'Login', onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
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
                            SizedBox(width: 12,),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                );
                                // Navigate to signup screen
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color(
                                      0xFF1A73E8), // Replace with your specific color
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

