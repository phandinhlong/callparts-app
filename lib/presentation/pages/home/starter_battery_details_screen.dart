import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'package:callparts/presentation/pages/cartScreen/cart_screen.dart';

class StarterBatteryDetailsScreen extends StatelessWidget {
  const StarterBatteryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Starter Battery Image
          Stack(
            children: [
              Image.asset(
                'images/starterbattery.png', // Starter Battery image path
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Starter Battery Name and Favorite Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text1(
                          text1: 'Premium Starter Battery',
                          size: 20,
                        ),
                        Icon(Icons.favorite_border,
                            color: Colors.red, size: 30),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 20, color: AppColors.tabColor),
                        SizedBox(width: 8),
                        Text2(
                          text2: 'Auto Parts Warehouse, Texas',
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Price
                    Text(
                      '\$120.00',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonColor,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Starter Battery Description
                    Text1(
                      text1: 'About Starter Battery',
                      size: 18,
                    ),
                    SizedBox(height: 10),
                    Text2(
                      text2:
                          'This premium starter battery ensures reliable performance for your vehicle, providing consistent power to start your engine even in extreme weather conditions. Perfect for cars, trucks, and SUVs.',
                    ),
                    SizedBox(height: 20),

                    // Key Features
                    Text1(
                      text1: 'Key Features',
                      size: 18,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• High Cold Cranking Amps (CCA) for reliable starts\n'
                      '• Maintenance-free design\n'
                      '• Long lifespan with durable construction',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),

                    // Usage Guidelines
                    Text1(
                      text1: 'Usage Guidelines',
                      size: 18,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Compatible with most vehicles\n'
                      '• Ensure proper installation by a professional\n'
                      '• Store in a dry, cool place when not in use',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),

                    // Additional Tips
                    Text1(
                      text1: 'Additional Tips',
                      size: 18,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Regularly check the battery terminals for corrosion\n'
                      '• Keep the battery fully charged for optimal performance\n'
                      '• Replace the battery every 3-5 years for best results',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CustomButton(
              text: 'Add to Cart',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
