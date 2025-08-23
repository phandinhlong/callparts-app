import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:callparts/presentation/widgets/text1.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                text: 'Order Status',
                text1: '',
              ),
              const SizedBox(height: 20),
              _buildOrderStatus('Order Placed', Icons.check_circle_outline,
                  '12/09/22 9:30 AM', true),
              _buildOrderStatus('Order Confirmed', Icons.check_circle_outline,
                  '12/09/22 10:00 AM', true),
              _buildOrderStatus('Preparing for Shipping', Icons.inventory,
                  '12/09/22 10:15 AM', true),
              _buildOrderStatus(
                  'Out for Delivery', Icons.local_shipping, '', false),
              _buildOrderStatus('Delivered', Icons.home, '', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatus(
      String status, IconData icon, String time, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.buttonColor : Colors.white,
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
            color: isCompleted ? Colors.white : Colors.grey,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text1(
                text1: status,
                size: 16,
                color: isCompleted ? Colors.white : Colors.grey,
              ),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: TextStyle(
                    color: isCompleted ? Colors.white : Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
