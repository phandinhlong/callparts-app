import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';

class TrackingDetailsScreen extends StatelessWidget {
  const TrackingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.tabColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
                    text1: 'Tracking Details',
                    size: 17,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        'images/c3.png',
                        width: 38,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text1(
                            text1: 'Alen Benjumen',
                            color: Colors.white,
                          ),
                          Text2(
                            text2: 'Products Courier',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Implement call functionality
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Implement message functionality
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text1(
                    text1: 'Delivery Status',
                    color: Colors.white,
                  ),
                  const Text2(
                    text2: 'Delivery man is on the way.',
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(text: 'Track Order', onTap: () {})
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
