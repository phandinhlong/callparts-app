import 'package:callparts/presentation/widgets/common/product_data.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/product.dart';
import 'package:callparts/presentation/widgets/custom_app_bar.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/custom_outlined_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text11.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'package:callparts/presentation/pages/order/order_tracking_screen/select_location_screen.dart';
import 'active_orders.dart';
import 'cancelled_orders.dart';
import 'completed_orders.dart';

class OrdersHistory extends StatefulWidget {
  const OrdersHistory({super.key});

  @override
  OrdersHistoryState createState() => OrdersHistoryState();
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isActive ? AppColors.text3Color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive ? AppColors.text3Color : AppColors.strokeColor,
          ),
        ),
        child: Text2(
          text2: label,
          color: isActive ? AppColors.text3Color : AppColors.text1Color,
        ),
      ),
    );
  }
}

class OrdersHistoryState extends State<OrdersHistory>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideFromLeftAnimation;
  late Animation<Offset> _slideFromRightAnimation;

  String _selectedFilter =
      'processing'; // processing, delivering, completed, cancelled

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
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đơn hàng',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
                    Row(
                      children: [
                        _StatusFilterChip(
                          label: 'Đang xử lý',
                          isActive: _selectedFilter == 'processing',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'processing';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _StatusFilterChip(
                          label: 'Đang giao',
                          isActive: _selectedFilter == 'delivering',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'delivering';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _StatusFilterChip(
                          label: 'Đã giao',
                          isActive: _selectedFilter == 'completed',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'completed';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _StatusFilterChip(
                          label: 'Đã huỷ',
                          isActive: _selectedFilter == 'cancelled',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'cancelled';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedFilter == 'processing' ||
                                _selectedFilter == 'delivering') ...[
                              SlideTransition(
                                position: _slideFromLeftAnimation,
                                child: _buildSectionHeader(
                                  context,
                                  title: _selectedFilter == 'processing'
                                      ? 'Đang xử lý'
                                      : 'Đang giao',
                                  onTapSeeAll: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ActiveOrders(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SlideTransition(
                                position: _slideFromLeftAnimation,
                                child: Column(
                                  children: List.generate(2, (index) {
                                    final product = products[index];
                                    return _OrderCard(
                                      statusLabel:
                                          _selectedFilter == 'processing'
                                              ? 'Đang xử lý'
                                              : 'Đang giao',
                                      statusColor: AppColors.text3Color,
                                      dateTimeText:
                                          _selectedFilter == 'processing'
                                              ? '23 May, 14:05'
                                              : '23 May, 16:30',
                                      product: product,
                                      totalText: '1.250.000 đ',
                                      primaryButtonText: 'Theo dõi đơn',
                                      secondaryButtonText: 'Huỷ đơn',
                                      onPrimaryTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SelectLocationScreen(),
                                          ),
                                        );
                                      },
                                      onSecondaryTap: () {},
                                    );
                                  }),
                                ),
                              ),
                            ] else if (_selectedFilter == 'completed') ...[
                              SlideTransition(
                                position: _slideFromRightAnimation,
                                child: _buildSectionHeader(
                                  context,
                                  title: 'Đã giao',
                                  onTapSeeAll: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CompletedOrders(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SlideTransition(
                                position: _slideFromRightAnimation,
                                child: Column(
                                  children: List.generate(2, (index) {
                                    final product = products1[index];
                                    return _OrderCard(
                                      statusLabel: 'Đã giao',
                                      statusColor: AppColors.text3Color,
                                      dateTimeText: '23 May, 09:15',
                                      product: product,
                                      totalText: '980.000 đ',
                                      primaryButtonText: 'Mua lại',
                                      secondaryButtonText: 'Đánh giá',
                                      onPrimaryTap: () {},
                                      onSecondaryTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SelectLocationScreen(),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ] else if (_selectedFilter == 'cancelled') ...[
                              SlideTransition(
                                position: _slideFromLeftAnimation,
                                child: _buildSectionHeader(
                                  context,
                                  title: 'Đã huỷ',
                                  onTapSeeAll: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CancelledOrders(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              SlideTransition(
                                position: _slideFromLeftAnimation,
                                child: Column(
                                  children: List.generate(2, (index) {
                                    final product = products3[index];
                                    return _OrderCard(
                                      statusLabel: 'Đã huỷ',
                                      statusColor: AppColors.text3Color,
                                      dateTimeText: '23 May, 11:20',
                                      product: product,
                                      totalText: '560.000 đ',
                                      primaryButtonText: 'Mua lại',
                                      secondaryButtonText: 'Lý do huỷ',
                                      onPrimaryTap: () {},
                                      onSecondaryTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SelectLocationScreen(),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                          ],
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

Widget _buildSectionHeader(
  BuildContext context, {
  required String title,
  required VoidCallback onTapSeeAll,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text1(
        text1: title,
        size: 15,
      ),
      GestureDetector(
        onTap: onTapSeeAll,
        child: const Text11(
          text2: 'Xem tất cả',
          color: AppColors.text3Color,
        ),
      ),
    ],
  );
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.statusLabel,
    required this.statusColor,
    required this.dateTimeText,
    required this.product,
    required this.totalText,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  final String statusLabel;
  final Color statusColor;
  final String dateTimeText;
  final Product product;
  final String totalText;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.strokeColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text2(
                      text2: dateTimeText,
                      color: AppColors.text2Color,
                    ),
                    const SizedBox(height: 2),
                    Text2(
                      text2: 'Mã đơn: CP-2025-001',
                      color: AppColors.text2Color,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text2(
                  text2: statusLabel,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  product.images.first,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text1(
                      text1: product.productName,
                    ),
                    const SizedBox(height: 4),
                    const Text2(
                      text2: '1 sản phẩm',
                      color: AppColors.text2Color,
                    ),
                    const SizedBox(height: 4),
                    Text1(
                      text1: 'Tổng: $totalText',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CustomOutlinedButton(
                  text: secondaryButtonText,
                  onTap: onSecondaryTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  text: primaryButtonText,
                  onTap: onPrimaryTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
