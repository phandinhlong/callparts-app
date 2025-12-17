import 'package:callparts/presentation/pages/checkout/track_my_order_screen.dart';
import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomAppBar(
                text: 'Order Confirmation',
                text1: '',
              ),
              const Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.buttonColor,
                      child: Icon(Icons.check, color: Colors.white, size: 70),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text1(
                        text1: 'Order Successful',
                        size: 30,
                      ),
                    ),
                    Text2(text2: 'Thank you for your order! Your order will'),
                    Text2(text2: 'be prepared and shipped by courier within'),
                    Text2(text2: '1-2 days.'),
                  ],
                ),
              ),
              CustomButton(
                text: 'Track My Order',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackMyOrderScreen(),
                    ),
                  );
                  // Navigate to track order screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
