import 'package:flutter/material.dart';


import '../../../CommonWidgets/product_data.dart';
import '../../../Widgets/custom_outline_button.dart';
import '../../../Widgets/customapp_bar.dart';
import '../../../Widgets/custombtn.dart';
import '../../../Widgets/detailstext1.dart';
import '../../../Widgets/detailstext2.dart';
import '../../../models/product_model.dart';
import '../order_tracking_screen/select_location_screeen.dart';






class ActiveOrders extends StatefulWidget {
  const ActiveOrders({super.key});

  @override
  ActiveOrdersState createState() => ActiveOrdersState();
}

class ActiveOrdersState extends State<ActiveOrders> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideFromTopAnimation;

  final List<Product> products = ProductData().products;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _slideFromTopAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(text: 'Active Orders', text1: ''),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return SlideTransition(
                          position: _slideFromTopAnimation,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Card(
                              color: Colors.white,

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                              text: 'Cancel Order',
                                              onTap: () {},
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: CustomButton(
                                              text: 'Track Order',
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const SelectLocationScreen(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
