import 'package:callparts/presentation/widgets/common/divider_car.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'tracking_details_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TrackingDetailsScreen(),
          ),
        );
      },
      child: Scaffold(
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
                        text1: 'Order Tracking',
                        size: 17,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            'images/c3.png',
                            width: 40,
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text1(
                                text1: 'Michael Johnson',
                                color: Colors.white,
                              ),
                              Text2(
                                text2: 'Delivery Man',
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.phone,
                              color: AppColors.text3Color,
                            ),
                            onPressed: () {
                              // Implement call functionality
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.message,
                              color: AppColors.text3Color,
                            ),
                            onPressed: () {
                              // Implement message functionality
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text1(
                        text1: 'Delivery Address',
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            'images/MapPin.png',
                            width: 15,
                            color: Colors.white,
                          ),
                          const Text2(
                            text2: ' 269 Loch Ness Road, Columbus, OH 43-9998',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const DividerCar(),
                      const SizedBox(height: 10),
                      const Text1(
                        text1: 'Delivery Time',
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            'images/MapPin.png',
                            width: 15,
                            color: Colors.white,
                          ),
                          const Text2(
                            text2:
                                ' Your order will be arriving at 4 PM today.',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const DividerCar(),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
