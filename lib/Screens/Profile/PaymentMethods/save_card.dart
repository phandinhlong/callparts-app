import 'package:flutter/material.dart';

import '../../../Constants/colors.dart';
import '../../../Widgets/detailstext1.dart';

class SaveCards extends StatelessWidget {
  const SaveCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      child: const Icon(Icons.arrow_back, color: Colors.black54, size: 20),
                    ),
                  ),
                  const Text1(
                    text1: 'Save Cards',
                    size: 16,
                  ),
                  const Text1(text1: ''), // Placeholder for any action button
                ],
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image.asset('images/card1.png'),
                    const SizedBox(width: 8),
                    Image.asset('images/card2.png'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Your saved cards will appear here.'),
            ],
          ),
        ),
      ),
    );
  }
}
