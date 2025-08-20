import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Screens/Authentication/reset_password.dart';

import '../../Constants/colors.dart';
import '../../Widgets/custombtn.dart';
import '../../Widgets/customtextfield.dart';
import '../../Widgets/detailstext1.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color with News Wave text
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
                    topRight: Radius.circular(30),                  ),
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
                        const SizedBox(height: 20),
                        const CustomTextField(
                          label: 'Email',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Reset Password',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Remembered your password? '),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Go back to login screen
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColors.buttonColor, // Replace with your specific color
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
