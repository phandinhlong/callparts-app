

import 'package:flutter/material.dart';
import 'package:autopartsstoreapp/Widgets/customapp_bar.dart';


import '../../CommonWidgets/product_data.dart';
import '../../Constants/colors.dart';
import '../../Widgets/detailstext1.dart';
import '../../Widgets/text11.dart';
import '../../models/product_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideFromLeftAnimation;

  final List<Product> products = ProductData().products;

  List<bool> isSelected = List<bool>.generate(16, (index) => false);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideFromLeftAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      backgroundColor: AppColors.bgColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.5,
              maxChildSize: 0.75,
              minChildSize: 0.3,
              builder: (context, scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text1(
                            text1: 'Filter',
                            size: 17,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color:Colors.black54,),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = false;
                            }
                            isSelected[index - 1] = true;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text11(text2: products[index - 1].name,color: Colors.white,),
                              Icon(Icons.check, color: isSelected[index - 1] ? Colors.white : Colors.transparent),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        backgroundColor: AppColors.text3Color,
        child: const Icon(Icons.filter_list,color: Colors.white,),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(text: 'Favorite Products', text1: ''),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return SlideTransition(
                          position: _slideFromLeftAnimation,
                          child: Card(
                            color: Colors.white,
                            elevation: 3,

                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        products[index].imagePath,
                                        width: 80,
                                      ),
                                      const SizedBox(width: 14),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text1(
                                            text1: products[index].name,
                                          ),
                                          Text1(
                                                  text1: products[index].price,
                                                ),
                                          // Row(
                                          //   children: [
                                          //     Text1(
                                          //       text1: products[index].price,
                                          //     ),
                                          //
                                          //   ],
                                          // ),
                                          // const Row(
                                          //   children: [
                                          //     Icon(
                                          //       Icons.star,
                                          //       color: AppColors.text3Color,
                                          //       size: 20,
                                          //     ),
                                          //     Icon(
                                          //       Icons.star,
                                          //       color: AppColors.text3Color,
                                          //       size: 20,
                                          //     ),
                                          //     Icon(
                                          //       Icons.star,
                                          //       color: AppColors.text3Color,
                                          //       size: 20,
                                          //     ),
                                          //     Icon(
                                          //       Icons.star,
                                          //       color: AppColors.text3Color,
                                          //       size: 20,
                                          //     ),
                                          //     Text1(text1: ' 4.3')
                                          //   ],
                                          // )
                                        ],
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.favorite, color: Colors.red),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }
}