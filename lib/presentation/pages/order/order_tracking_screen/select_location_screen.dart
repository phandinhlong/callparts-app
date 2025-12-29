import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/custom_button.dart';
import 'package:callparts/presentation/widgets/text1.dart';
import 'package:callparts/presentation/widgets/text2.dart';
import 'package:callparts/presentation/widgets/common/divider_car.dart';
import 'package:callparts/presentation/pages/order/order_tracking_screen/order_tracking_screen.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

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
        title: const Text(
          'Chọn vị trí giao hàng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Bản đồ toàn màn hình có thể di chuyển / phóng to
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(10.777, 106.695), // ví dụ: HCM
                  zoom: 14,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  // nếu sau này bạn muốn lưu controller thì khai báo biến và gán ở đây
                },
                markers: {
                  Marker(
                    markerId: MarkerId('delivery'),
                    position: LatLng(10.777, 106.695),
                  ),
                },
              ),
            ),
            // Gradient mờ phía dưới
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
            // Bottom sheet chọn địa chỉ
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
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
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.strokeColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const Text1(
                      text1: 'Chọn địa chỉ giao hàng',
                      size: 17,
                      color: AppColors.text1Color,
                    ),
                    const SizedBox(height: 8),
                    const Text2(
                      text2: 'Xác nhận vị trí để tài xế giao đúng địa chỉ của bạn',
                      color: AppColors.text2Color,
                    ),
                    const SizedBox(height: 14),
                    const Text1(
                      text1: 'Địa chỉ hiện tại',
                      color: AppColors.text1Color,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/MapPin.png',
                          width: 20,
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
                    const SizedBox(height: 10),
                    const DividerCar(),
                    const SizedBox(height: 8),
                    const Text2(
                      text2: 'Lưu địa chỉ dưới dạng',
                      color: AppColors.text2Color,
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Tabbbbbb(
                          icon: Icons.home,
                          text: 'Nhà',
                        ),
                        Tabbbbbb(
                          icon: Icons.meeting_room_rounded,
                          text: 'Cơ quan',
                        ),
                        Tabbbbbb(
                          icon: Icons.room,
                          text: 'Khác',
                        )
                      ],
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      text: 'Lưu địa chỉ & theo dõi đơn',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderTrackingScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tabbbbbb extends StatelessWidget {
  final String text;
  final IconData icon;

  const Tabbbbbb({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
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
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.buttonColor,
          ),
          const SizedBox(width: 3),
          Text1(text1: text)
        ],
      ),
    );
  }
}
