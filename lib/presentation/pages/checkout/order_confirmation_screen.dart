import 'package:callparts/presentation/pages/checkout/order_confirmed_screen.dart';
import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  text: 'Order Confirmation',
                  text1: '',
                ),
                const SizedBox(height: 20),
                _buildOrderDetails(),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Track My Order',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderConfirmedScreen(),
                      ),
                    );
                    // Navigate to track order screen
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text1(
            text1: 'Order ID: #123456',
            size: 18,
          ),
          const SizedBox(height: 12),
          const Text1(
            text1: 'Delivery Address:',
            size: 16,
          ),
          const SizedBox(height: 8),
          const Text(
            'Floor 4, Kartini Tower No 43\nLumajang, Jawa Timur',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text1(
            text1: 'Payment Method:',
            size: 16,
          ),
          const SizedBox(height: 8),
          const Text1(
            text1: 'Pay with PayPal',
            size: 16,
            color: AppColors.text3Color,
          ),
          const SizedBox(height: 16),
          const Text1(
            text1: 'Order Summary:',
            size: 16,
          ),
          const SizedBox(height: 8),
          _buildOrderSummaryItem('Subtotal', '\$1720'),
          _buildOrderSummaryItem('Delivery Fee', '\$24'),
          const Divider(),
          _buildOrderSummaryItem('Total', '\$1960', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryItem(String title, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text1(text1: title),
          Text1(
            text1: value,
            size: isTotal ? 18 : 16,
            color: isTotal ? Colors.white : Colors.grey,
          ),
        ],
      ),
    );
  }
}
