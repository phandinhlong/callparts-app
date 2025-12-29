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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Image with back button
              Stack(
                children: [
                  Image.asset(
                    'images/starterbattery.png',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 50,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Favorite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Premium Starter Battery',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.red, size: 30),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Rating and Stock
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            )),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '(4.8)',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Còn hàng',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Price
                      const Text(
                        '120.000 đ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Brand
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'BOSCH',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Description
                      const Text(
                        'Mô tả sản phẩm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ắc quy khởi động cao cấp đảm bảo hiệu suất đáng tin cậy cho xe của bạn, cung cấp nguồn điện ổn định để khởi động động cơ ngay cả trong điều kiện thời tiết khắc nghiệt. Hoàn hảo cho ô tô, xe tải và SUV.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Key Features
                      const Text(
                        'Tính năng chính',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          _buildFeatureItem('• Dung lượng cao (CCA) để khởi động đáng tin cậy'),
                          _buildFeatureItem('• Thiết kế không cần bảo dưỡng'),
                          _buildFeatureItem('• Tuổi thọ lâu với cấu trúc bền vững'),
                          _buildFeatureItem('• Kháng nước và bụi chuẩn IP65'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Compatibility
                      const Text(
                        'Tương thích',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Phù hợp với hầu hết các dòng xe Toyota, Honda, Hyundai',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Usage Guidelines
                      const Text(
                        'Hướng dẫn sử dụng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          _buildFeatureItem('• Đảm bảo lắp đặt bởi chuyên gia'),
                          _buildFeatureItem('• Bảo quản ở nơi khô ráo, mát'),
                          _buildFeatureItem('• Kiểm tra định kỳ các đầu cực'),
                          _buildFeatureItem('• Thay thế sau 3-5 năm sử dụng'),
                        ],
                      ),
                      const SizedBox(height: 100), // Space for sticky CTA
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Sticky CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Thêm vào giỏ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
          height: 1.4,
        ),
      ),
    );
  }
}
