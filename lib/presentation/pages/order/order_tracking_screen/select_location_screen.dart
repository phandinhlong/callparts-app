import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'package:callparts/presentation/widgets/common/divider_car.dart';
import 'package:callparts/presentation/pages/order/order_tracking_screen/order_tracking_screen.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen image
            Positioned.fill(
              child: Image.asset(
                'images/mapppp.PNG',
                fit: BoxFit.cover,
              ),
            ),
            // Bottom sheet content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.text1Color,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text1(
                      text1: 'Select Your Location',
                      size: 17,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text1(
                      text1: 'Your Location',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'images/MapPin.png',
                          width: 20,
                          color: Colors.white,
                        ),
                        const Text2(
                          text2: ' 269 Loch Ness Road, Columbus, OH 43-9998',
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const DividerCar(),
                    const SizedBox(height: 8),
                    const Text2(
                      text2: 'Save As',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Tabbbbbb(
                          icon: Icons.meeting_room_rounded,
                          text: 'Office',
                        ),
                        Tabbbbbb(
                          icon: Icons.home,
                          text: 'Home',
                        ),
                        Tabbbbbb(
                          icon: Icons.room,
                          text: 'Other',
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                        text: 'Save Address',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderTrackingScreen(),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tabbbbbb extends StatelessWidget {
  final String text;
  final IconData icon;

  const Tabbbbbb({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.buttonColor,
          ),
          const SizedBox(width: 3),
          Text1(text1: text)
        ],
      ),
    );
  }
}
