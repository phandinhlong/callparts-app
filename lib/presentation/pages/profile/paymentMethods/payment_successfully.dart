import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';

class PaymentSuccessfully extends StatelessWidget {
  const PaymentSuccessfully({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(text: 'Payment Successful', text1: ''),
              const SizedBox(height: 30),
              const Center(
                child: Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.buttonColor,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text1(text1: 'Payment Successful', size: 24),
                    SizedBox(height: 5),
                    Text2(text2: 'Thank you for your payment!'),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Back to Home',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
