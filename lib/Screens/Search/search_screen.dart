import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Screens/Search/search_typing.dart';
import 'package:autopartsstoreapp/models/product_model.dart';

import '../../../Constants/colors.dart';
import '../../../Widgets/custombtn.dart';
import '../../../Widgets/detailstext1.dart';
import '../../../Widgets/detailstext2.dart';
import '../../CommonWidgets/product_data.dart';
import '../../Widgets/custom_outline_button.dart';
import '../../Widgets/customapp_bar.dart';
import '../../Widgets/customtextfield.dart';
import '../Checkout/shipping_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
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
              const CustomAppBar(text: 'Search', text1: ''),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Search Fruits',
                icon: Icons.search,
              ),
              const SizedBox(height: 10),
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
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 23),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            products[index].imagePath,
                                            width: 80,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 17),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text1(
                                                    text1: products[index].name,
                                                  ),
                                                  Text1(
                                                    text1:
                                                    products[index].price,
                                                  ),
                                                ],
                                              ),
                                              const Text2(text2: '2'),
                                              const Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.star,size: 19,color: AppColors.buttonColor,),
                                                  Icon(Icons.star,size: 19,color: AppColors.buttonColor,),
                                                  Icon(Icons.star,size: 19,color: AppColors.buttonColor,),
                                                  Icon(Icons.star,size: 19,color: AppColors.buttonColor,),
                                                  Icon(Icons.star,size: 19,color: AppColors.buttonColor,),
                                                  Icon(Icons.star,size: 19,color: AppColors.buttonColor,),
                                                  Text2(text2: ' (4.5)')






                                                ],

                                              )
                                            ],
                                          ),
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
                                            text: 'Cancel',
                                            onTap: () {},
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: CustomButton(
                                            text: 'Add To Cart',
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                  const ShippingAddressScreen(),
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
                        );
                      },
                    );
                  },
                ),
              ),
              CustomButton(text: 'Next',onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchTyping()),
                );
              },),
            ],
          ),
        ),
      ),

    );
  }
}
