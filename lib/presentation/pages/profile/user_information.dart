import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_text_field.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/pages/profile/edit_profile.dart'; // Import the EditProfile screen

class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.text3Color),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.black54, size: 20),
                      ),
                    ),
                    const Text1(
                      text1: 'User Info',
                      size: 16,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const EditProfile())); // Navigate to EditProfile screen
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.buttonColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                            'images/c3.png'), // Example profile picture
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'John Doe', // Example username
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text1Color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'john.doe@example.com', // Example email
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.text2Color,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const CustomTextField(
                        icon: Icons.person_outline, label: 'First Name'),
                    const CustomTextField(
                        icon: Icons.person_outline, label: 'Last Name'),
                    const CustomTextField(
                        icon: Icons.email, label: 'Email Address'),
                    const CustomTextField(
                        icon: Icons.phone, label: 'Phone Number'),
                    const CustomTextField(
                        icon: Icons.home, label: 'Street Address'),
                    const CustomTextField(
                        icon: Icons.location_city, label: 'City'),
                    const CustomTextField(
                        icon: Icons.location_on, label: 'State'),
                    const CustomTextField(
                        icon: Icons.markunread_mailbox, label: 'Zip Code'),
                    const CustomTextField(icon: Icons.flag, label: 'Country'),
                    const SizedBox(height: 15),
                    CustomButton(
                        text: 'Save Information',
                        onTap: () {
                          // Handle save information action
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
