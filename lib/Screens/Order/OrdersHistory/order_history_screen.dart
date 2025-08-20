import 'package:autopartsstoreapp/CommonWidgets/product_data.dart';
import 'package:flutter/material.dart';

import '../../../../Constants/colors.dart';
import '../../../../Widgets/custombtn.dart';
import '../../../../Widgets/detailstext1.dart';
import '../../../../Widgets/detailstext2.dart';
import '../../../../Widgets/text11.dart';
import '../../../Widgets/custom_outline_button.dart';
import '../../../Widgets/customapp_bar.dart';
import '../../../models/product_model.dart';
import '../order_tracking_screen/select_location_screeen.dart';
import 'active_orders.dart';
import 'cancelled_orders.dart';
import 'completed_orders.dart';

class OrdersHistory extends StatefulWidget {
  const OrdersHistory({super.key});

  @override
  OrdersHistoryState createState() => OrdersHistoryState();
}

class OrdersHistoryState extends State<OrdersHistory>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideFromLeftAnimation;
  late Animation<Offset> _slideFromRightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideFromLeftAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideFromRightAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  final List<Product> products = ProductData().products;
  final List<Product> products1 = ProductData().products;
  final List<Product> products3 = ProductData().products;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacityAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(text: 'Orders History', text1: ''),
                    const SizedBox(height: 34),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ActiveOrders()));
                      },
                      child: SlideTransition(
                        position: _slideFromLeftAnimation,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text1(
                              text1: 'Active Orders',
                              size: 14,
                            ),
                            Text11(
                              text2: 'See All',
                              color: AppColors.text3Color,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideTransition(
                      position: _slideFromLeftAnimation,
                      child: SizedBox(
                        height: 175,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 250,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          products[index].imagePath,
                                          width: 80,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text1(
                                                text1: products[index].name,
                                              ),
                                              const Text2(text2: 'May 23, 4.3PM Delivered'),
                                              Text1(
                                                text1: products[index].price,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: CustomOutlinedButton(
                                                text: 'Cancel Order', onTap: () {}),
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: CustomButton(
                                                text: 'Track Order', onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const SelectLocationScreen(),
                                                ),
                                              );

                                            }),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CompletedOrders()));
                      },
                      child: SlideTransition(
                        position: _slideFromRightAnimation,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text1(
                              text1: 'Completed Orders',
                              size: 14,
                            ),
                            Text11(
                              text2: 'See All',
                              color: AppColors.text3Color,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideTransition(
                      position: _slideFromRightAnimation,
                      child: SizedBox(
                        height: 175,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: products1.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 250,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          products1[index].imagePath,
                                          width: 80,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text1(
                                                text1: products1[index].name,
                                              ),
                                              const Text2(text2: 'May 23, 4.3PM Delivered'),
                                              Text1(
                                                text1: products1[index].price,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: CustomOutlinedButton(
                                                text: 'Cancel Order', onTap: () {}),
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: CustomButton(
                                                text: 'Track Order', onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const SelectLocationScreen(),
                                                ),
                                              );
                                            }),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CancelledOrders()));
                      },
                      child: SlideTransition(
                        position: _slideFromLeftAnimation,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text1(
                              text1: 'Cancelled Orders',
                              size: 14,
                            ),
                            Text11(
                              text2: 'See All',
                              color: AppColors.text3Color,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideTransition(
                      position: _slideFromLeftAnimation,
                      child: SizedBox(
                        height: 175,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: products3.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 250,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          products3[index].imagePath,
                                          width: 80,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text1(
                                                text1: products3[index].name,
                                              ),
                                              const Text2(text2: 'May 23, 4.3PM Delivered'),
                                              Text1(
                                                text1: products3[index].price,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: CustomOutlinedButton(
                                                text: 'Cancel Order', onTap: () {}),
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: CustomButton(
                                                text: 'Track Order', onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const SelectLocationScreen(),
                                                ),
                                              );
                                            }),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
