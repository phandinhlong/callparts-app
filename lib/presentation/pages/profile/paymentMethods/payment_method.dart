import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'add_card.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  PaymentMethodState createState() => PaymentMethodState();
}

class PaymentMethodState extends State<PaymentMethod> {
  int _selectedPaymentIndex = -1; // Initialize with no selection

  void _selectPayment(int index) {
    setState(() {
      _selectedPaymentIndex = index;
    });
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
              const CustomAppBar(text: 'Payment Methods', text1: ''),
              const SizedBox(
                height: 30,
              ),
              const Text1(
                text1: 'Credit Cards',
                size: 21,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _selectPayment(0); // Select the first payment method
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.tabColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.text3Color),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'images/debitcard.png',
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text2(text2: 'Add New Card'),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: _selectedPaymentIndex == 0
                              ? AppColors.buttonColor // Selected color
                              : Colors.transparent,
                          // Transparent if not selected
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: _selectedPaymentIndex == 0
                                  ? AppColors.buttonColor // Selected color
                                  : Colors
                                      .transparent, // Transparent if not selected
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text1(
                text1: 'More payment Options',
                size: 20,
              ),
              const SizedBox(
                height: 4,
              ),
              GestureDetector(
                onTap: () {
                  _selectPayment(1); // Select the second payment method
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.tabColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.text3Color),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Image.asset(
                          'images/card.png',
                          width: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text2(text2: 'Master Card'),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: _selectedPaymentIndex == 1
                              ? AppColors.buttonColor // Selected color
                              : Colors.transparent,
                          // Transparent if not selected
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: _selectedPaymentIndex == 1
                                  ? AppColors.buttonColor // Selected color
                                  : Colors
                                      .transparent, // Transparent if not selected
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _selectPayment(2); // Select the third payment method
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.tabColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.text3Color),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Image.asset(
                          'images/icons8-apple-logo-50.png',
                          width: 24,
                          color: AppColors.buttonColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text2(text2: 'Apple Pay'),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: _selectedPaymentIndex == 2
                              ? AppColors.buttonColor // Selected color
                              : Colors.transparent,
                          // Transparent if not selected
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: _selectedPaymentIndex == 2
                                  ? AppColors.buttonColor // Selected color
                                  : Colors
                                      .transparent, // Transparent if not selected
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Spacer(),
              CustomButton(
                text: 'Next',
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddCard()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
