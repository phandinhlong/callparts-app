import 'package:callparts/presentation/widgets/common/divider_car.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'tracking_details_screen.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Bản đồ toàn màn hình
            Positioned.fill(
              child: Image.asset(
                'images/mapppp.PNG',
                fit: BoxFit.cover,
              ),
            ),
            // Gradient mờ phía dưới để nổi bottom sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.32),
                        Colors.black.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Nội dung bottom sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackingDetailsScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.strokeColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const Text1(
                        text1: 'Theo dõi đơn hàng',
                        size: 17,
                        color: AppColors.text1Color,
                      ),
                      const SizedBox(height: 4),
                      const Text2(
                        text2: 'Đơn #CP-2025-001 · Dự kiến giao trước 16:00',
                        color: AppColors.text2Color,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: Image.asset(
                              'images/c3.png',
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text1(
                                  text1: 'Nguyễn Văn Tài',
                                  color: AppColors.text1Color,
                                ),
                                SizedBox(height: 2),
                                Text2(
                                  text2: 'Tài xế giao hàng · 4.8 ★',
                                  color: AppColors.text2Color,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.phone,
                                size: 18,
                                color: AppColors.text3Color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.bgColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.message,
                                size: 18,
                                color: AppColors.text3Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const DividerCar(),
                      const SizedBox(height: 10),
                      const Text1(
                        text1: 'Trạng thái vận chuyển',
                        color: AppColors.text1Color,
                      ),
                      const SizedBox(height: 10),
                      _TrackingStep(
                        isActive: true,
                        title: 'Đã tiếp nhận đơn',
                        subtitle: 'Kho phụ tùng xác nhận vào 14:05',
                      ),
                      _TrackingStep(
                        isActive: true,
                        title: 'Đang giao hàng',
                        subtitle: 'Tài xế đang di chuyển tới địa chỉ của bạn',
                      ),
                      _TrackingStep(
                        isActive: false,
                        title: 'Giao hàng thành công',
                        subtitle: 'Dự kiến trước 16:00 hôm nay',
                      ),
                      const SizedBox(height: 12),
                      const DividerCar(),
                      const SizedBox(height: 8),
                      const Text1(
                        text1: 'Địa chỉ giao hàng',
                        color: AppColors.text1Color,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'images/MapPin.png',
                            width: 16,
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text2(
                              text2:
                                  '269 Lý Thường Kiệt, P.6, Q.Tân Bình, TP. Hồ Chí Minh',
                              color: AppColors.text2Color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text2(
                        text2: 'Lưu ý: Kiểm tra phụ tùng trước khi ký nhận.',
                        color: AppColors.text2Color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingStep extends StatelessWidget {
  const _TrackingStep({
    required this.isActive,
    required this.title,
    required this.subtitle,
  });

  final bool isActive;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final Color dotColor =
        isActive ? AppColors.text3Color : AppColors.strokeColor;
    final Color textColor =
        isActive ? AppColors.text1Color : AppColors.text2Color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 26,
              color: AppColors.strokeColor,
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text1(
                  text1: title,
                  color: textColor,
                ),
                const SizedBox(height: 2),
                Text2(
                  text2: subtitle,
                  color: AppColors.text2Color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
