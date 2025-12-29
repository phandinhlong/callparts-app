import 'package:callparts/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Settings values
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _orderUpdates = true;
  bool _promotionalOffers = true;
  bool _darkMode = false;
  bool _showPrices = true;
  String _language = 'vi'; // vi, en

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? false;
      _orderUpdates = prefs.getBool('order_updates') ?? true;
      _promotionalOffers = prefs.getBool('promotional_offers') ?? true;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _showPrices = prefs.getBool('show_prices') ?? true;
      _language = prefs.getString('language') ?? 'vi';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black87,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.buttonColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black87,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ngôn ngữ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Tiếng Việt'),
              value: 'vi',
              groupValue: _language,
              activeColor: AppColors.buttonColor,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  _saveSetting('language', value);
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _language,
              activeColor: AppColors.buttonColor,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                  _saveSetting('language', value);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.buttonColor),
            SizedBox(width: 12),
            Text('Về ứng dụng'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Callparts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Phiên bản: 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ứng dụng bán phụ tùng ô tô chính hãng, chất lượng cao với giá cả hợp lý.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 Callparts. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.buttonColor,
            ),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications Section
              _buildSectionHeader('THÔNG BÁO'),
              _buildSwitchTile(
                title: 'Thông báo đẩy',
                subtitle: 'Nhận thông báo trên thiết bị',
                value: _pushNotifications,
                icon: Icons.notifications_outlined,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                    _saveSetting('push_notifications', value);
                  });
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildSwitchTile(
                title: 'Thông báo email',
                subtitle: 'Nhận thông báo qua email',
                value: _emailNotifications,
                icon: Icons.email_outlined,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                    _saveSetting('email_notifications', value);
                  });
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildSwitchTile(
                title: 'Cập nhật đơn hàng',
                subtitle: 'Thông báo về trạng thái đơn hàng',
                value: _orderUpdates,
                icon: Icons.shopping_bag_outlined,
                onChanged: (value) {
                  setState(() {
                    _orderUpdates = value;
                    _saveSetting('order_updates', value);
                  });
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildSwitchTile(
                title: 'Ưu đãi & Khuyến mãi',
                subtitle: 'Nhận thông báo về chương trình khuyến mãi',
                value: _promotionalOffers,
                icon: Icons.local_offer_outlined,
                onChanged: (value) {
                  setState(() {
                    _promotionalOffers = value;
                    _saveSetting('promotional_offers', value);
                  });
                },
              ),

              // Display Section
              _buildSectionHeader('HIỂN THỊ'),
              _buildSwitchTile(
                title: 'Chế độ tối',
                subtitle: 'Sử dụng giao diện tối',
                value: _darkMode,
                icon: Icons.dark_mode_outlined,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                    _saveSetting('dark_mode', value);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chế độ tối sẽ được cập nhật trong phiên bản tiếp theo'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildSwitchTile(
                title: 'Hiển thị giá',
                subtitle: 'Hiển thị giá sản phẩm trên danh sách',
                value: _showPrices,
                icon: Icons.attach_money,
                onChanged: (value) {
                  setState(() {
                    _showPrices = value;
                    _saveSetting('show_prices', value);
                  });
                },
              ),

              // App Settings Section
              _buildSectionHeader('CÀI ĐẶT ỨNG DỤNG'),
              _buildNavigationTile(
                title: 'Ngôn ngữ',
                subtitle: _language == 'vi' ? 'Tiếng Việt' : 'English',
                icon: Icons.language,
                onTap: _showLanguageDialog,
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildNavigationTile(
                title: 'Xóa bộ nhớ cache',
                subtitle: 'Xóa dữ liệu tạm thời',
                icon: Icons.cleaning_services_outlined,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xóa bộ nhớ cache'),
                      content: const Text('Bạn có chắc muốn xóa bộ nhớ cache không?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            // Clear image cache
                            await CachedNetworkImage.evictFromCache('');
                            imageCache.clear();
                            imageCache.clearLiveImages();
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã xóa bộ nhớ cache'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Xóa'),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // About Section
              _buildSectionHeader('VỀ ỨNG DỤNG'),
              _buildNavigationTile(
                title: 'Về Callparts',
                subtitle: 'Phiên bản 1.0.0',
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildNavigationTile(
                title: 'Chính sách bảo mật',
                subtitle: 'Xem chính sách bảo mật',
                icon: Icons.privacy_tip_outlined,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Chính sách bảo mật'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Callparts cam kết bảo vệ quyền riêng tư của bạn. Chúng tôi thu thập và sử dụng thông tin cá nhân của bạn một cách có trách nhiệm.',
                              style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '• Thông tin được mã hóa và bảo mật\n• Không chia sẻ với bên thứ ba\n• Tuân thủ luật bảo vệ dữ liệu',
                              style: TextStyle(fontSize: 14, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildNavigationTile(
                title: 'Điều khoản dịch vụ',
                subtitle: 'Xem điều khoản sử dụng',
                icon: Icons.article_outlined,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Điều khoản dịch vụ'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Bằng cách sử dụng ứng dụng Callparts, bạn đồng ý với các điều khoản sau:',
                              style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '• Sử dụng dịch vụ hợp pháp\n• Không sao chép nội dung\n• Tuân thủ quy định thanh toán\n• Chấp nhận chính sách đổi trả',
                              style: TextStyle(fontSize: 14, height: 1.6),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đóng'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildNavigationTile(
                title: 'Liên hệ hỗ trợ',
                subtitle: 'Gửi phản hồi hoặc báo lỗi',
                icon: Icons.support_agent_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
