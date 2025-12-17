import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_outlined_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';

class WishlistDetailsScreen extends StatelessWidget {
  const WishlistDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(text: 'WishList Details', text1: ''),
            const SizedBox(
              height: 30,
            ),
            Center(child: Image.asset('images/flywheel.png')),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text1(
                  text1: 'FlyWheel',
                  size: 17,
                ),
                Text2(text2: '\$45.00')
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text1(
              text1: '1 KG',
              size: 17,
            ),
            const Spacer(),
            CustomButton(
              text: 'Edit Info',
              onTap: () {},
            ),
            CustomOutlinedButton(text: 'Delete this', onTap: () {})
          ],
        ),
      )),
    );
  }
}
