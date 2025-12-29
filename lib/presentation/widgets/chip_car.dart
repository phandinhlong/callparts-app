import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'text1.dart';

class ChipCar extends StatelessWidget {
  final String text;
  final Color color;

  const ChipCar({
    super.key,
    required this.text,
    this.color = AppColors.tabColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
      ),
      label: Text1(text1: text),
      backgroundColor: color,
    );
  }
}
