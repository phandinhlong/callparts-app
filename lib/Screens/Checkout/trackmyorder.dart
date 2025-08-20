import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

import '../../Widgets/customapp_bar.dart';
import '../../Widgets/custombtn.dart';
import '../../Widgets/detailstext1.dart';
import '../../Widgets/detailstext2.dart';
import 'order_status_screen.dart';

class TrackMyOrderScreen extends StatelessWidget {
  const TrackMyOrderScreen({super.key});

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
                text: 'Track My Order',
                text1: '',
              ),
              const SizedBox(height: 20),
              _buildOrderTrackingDetails(),
              const SizedBox(height: 20),
              _buildTrackingSteps(),
              CustomButton(text: 'Next', onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderStatusScreen(

                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderTrackingDetails() {
    return Container(
      width: double.infinity,
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text1(
            text1: 'Order ID: 123456',
            size: 18,
          ),
          SizedBox(height: 10),
          Text2(
            text2: 'Estimated Delivery: July 5, 2024',
          ),
          SizedBox(height: 10),
          Text2(
            text2: 'Shipping Address:',
          ),
          Text2(
            text2: '123 Main St, Springfield, USA',
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingSteps() {
    return Expanded(
      child: ListView(
        children: [
          _buildTrackingStep(
            step: 'Order received',
            date: '12/09/22',
            time: '9:30 AM',
            icon: Icons.check_circle,
            isCompleted: true,
          ),
          _buildTrackingStep(
            step: 'Order packed',
            date: '12/09/22',
            time: '10:00 AM',
            icon: Icons.inventory,
            isCompleted: true,
          ),
          _buildTrackingStep(
            step: 'Order dispatched',
            date: '12/09/22',
            time: '10:15 AM',
            icon: Icons.local_shipping,
            isCompleted: true,
          ),
          _buildTrackingStep(
            step: 'Out for delivery',
            date: '12/09/22',
            time: '10:20 AM',
            icon: Icons.delivery_dining,
            isCompleted: false,
          ),
          _buildTrackingStep(
            step: 'Delivered',
            date: '',
            time: '',
            icon: Icons.home,
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep({
    required String step,
    required String date,
    required String time,
    required IconData icon,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
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
                text1: step,
                size: 16,
                color: isCompleted ? Colors.white : Colors.grey,
              ),
              if (date.isNotEmpty && time.isNotEmpty)
                Text2(
                  text2: '$date $time',
                  color: isCompleted ? Colors.white : Colors.grey,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
