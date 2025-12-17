import 'package:callparts/presentation/pages/profile/paymentMethods/payment_successfully.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text11.dart';
import 'package:callparts/presentation/widgets/text2.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(text: 'Payment Summary', text1: ''),
            const SizedBox(height: 23),
            Card(
              color: Colors.white,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ClipOval(
                        child: Image.asset(
                          'images/apple.png',
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 17),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Text1(text1: 'Fresh Apple'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2, top: 4),
                          child: Text2(text2: 'Fruit & Vegetables'),
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 17,
                            ),
                            SizedBox(width: 3),
                            Text2(text2: 'New York, USA'),
                            SizedBox(width: 4),
                            Padding(
                              padding: EdgeInsets.only(top: 7),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text2(text2: 'Date & Hour'),
                          Text1(text1: 'August 24, 2024 | 10:00 AM'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text2(text2: 'Category'),
                          Text1(text1: 'Fruit & Vegetables'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text2(text2: 'Quantity'),
                          Text1(text1: '3 kg'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text2(text2: 'Price per kg'),
                          Text1(text1: '\$3.00'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text2(text2: 'Total Amount'),
                          Text1(text1: '\$9.00'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.payment, color: Colors.deepOrange, size: 20),
                SizedBox(width: 5),
                Text2(text2: 'Cash'),
                Spacer(),
                Text11(text2: 'Change', color: AppColors.text3Color),
              ],
            ),
            const Spacer(),
            CustomButton(
              text: 'Pay Now',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PaymentSuccessfully()));
              },
            ),
          ],
        ),
      )),
    );
  }
}
