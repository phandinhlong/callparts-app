import 'package:callparts/data/models/product.dart';
import 'package:flutter/material.dart';

import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/drawer_widget.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text11.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'package:callparts/presentation/widgets/common/address_widget.dart';
import 'package:callparts/presentation/widgets/common/home_widget.dart';
import 'package:callparts/presentation/widgets/common/product_card.dart';
import 'package:callparts/presentation/widgets/common/product_data.dart';
import 'package:callparts/presentation/widgets/common/categories_widget.dart';
import 'package:callparts/presentation/pages/settings/Views/grocery_notifications.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Product> products = ProductData().products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adding a background container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.buttonColor, // Background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeWidgte(),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text2(
                                    text2: 'Your Location',
                                    color: Colors.white,
                                  ),
                                  AddressWidget(),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GroceryNotifications()),
                                  );
                                },
                                child: Container(
                                  height: 42,
                                  width: 42,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.notification_important_rounded,
                                    color: AppColors.buttonColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 9),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'images/b1.png',
                        height: 150,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'images/b3.png',
                        height: 150,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'images/b2.png',
                        height: 150,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              InkWell(
                onTap: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text1(text1: 'Categories', size: 18),
                    Text11(
                      text2: 'See All',
                      color: AppColors.buttonColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 9),
              const CategoriesWidget(),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text1(text1: 'Popular Parts ', size: 19),
                    Text11(
                      text2: '',
                      color: AppColors.buttonColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 3,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      imagePath: products[index].imagePath,
                      name: products[index].name,
                      price: products[index].price,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
