import 'package:callparts/presentation/pages/authentication/login_screen.dart';
import 'package:callparts/presentation/pages/cartScreen/cart_screen.dart';
import 'package:callparts/presentation/pages/home/home_page.dart';
import 'package:callparts/presentation/pages/settings/settings.dart';
import 'package:callparts/presentation/pages/favorite/favorite_screen.dart';
import 'package:callparts/presentation/pages/messagesFlow/direct_messages.dart';
import 'package:callparts/presentation/pages/order/OrdersHistory/orders_history.dart';
import 'package:callparts/presentation/pages/profile/profile_screen.dart';
import 'package:callparts/presentation/pages/search/banner_search_screen.dart';
import 'package:callparts/service/auth/auth_services.dart';
import 'package:callparts/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String selectedMenuItem = '';
  AuthService auth = AuthService();
  bool isVietnamese = true;

  Map<String, String> get translations => isVietnamese ? {
    'hey': 'Chào!',
    'name': 'James Powell',
    'homepage': 'Trang chủ',
    'cart': 'Giỏ hàng',
    'favorite': 'Yêu thích',
    'orders': 'Đơn hàng',
    'messages': 'Tin nhắn',
    'profile': 'Hồ sơ',
    'settings': 'Cài đặt',
    'logout': 'Đăng xuất',
    'login': 'Đăng nhập',
    'language': 'Ngôn ngữ',
  } : {
    'hey': 'Hey!',
    'name': 'James Powell',
    'homepage': 'Homepage',
    'cart': 'Cart',
    'favorite': 'Favorite',
    'orders': 'Orders',
    'messages': 'Messages',
    'profile': 'Profile',
    'settings': 'Settings',
    'logout': 'Logout',
    'login': 'Login',
    'language': 'Language',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(2, 0),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(1, 0),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey.shade50.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.buttonColor.withOpacity(0.95),
                    AppColors.button2Color.withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // App Logo/Brand
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.cogs,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isVietnamese ? 'Phụ Tùng Xe' : 'Auto Parts',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isVietnamese ? 'Chất lượng cao' : 'Premium Quality',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // User Profile Section (only if logged in)
                  if (auth.tokenAuth != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage('images/c3.png'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translations['hey']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  translations['name']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Main Navigation Menu
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shopping Section
                    _buildSectionHeader(isVietnamese ? 'Mua sắm' : 'Shopping'),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      title: translations['homepage']!,
                      icon: FontAwesomeIcons.house,
                      color: AppColors.buttonColor,
                      onTap: () => navigateTo(HomePage()),
                    ),
                    _buildMenuItem(
                      title: translations['cart']!,
                      icon: FontAwesomeIcons.cartShopping,
                      color: AppColors.text3Color,
                      onTap: () => navigateTo(const CartScreen()),
                    ),
                    _buildMenuItem(
                      title: translations['favorite']!,
                      icon: FontAwesomeIcons.solidHeart,
                      color: Colors.red,
                      onTap: () => navigateTo(const FavoriteScreen()),
                    ),

                    const SizedBox(height: 24),

                    // Orders & Support Section
                    _buildSectionHeader(isVietnamese ? 'Đơn hàng & Hỗ trợ' : 'Orders & Support'),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      title: translations['orders']!,
                      icon: FontAwesomeIcons.clipboardList,
                      color: AppColors.button2Color,
                      onTap: () => navigateTo(const OrdersHistory()),
                    ),
                    _buildMenuItem(
                      title: translations['messages']!,
                      icon: FontAwesomeIcons.comments,
                      color: AppColors.buttonColor,
                      onTap: () => navigateTo(const DirectMessages()),
                    ),
                    const SizedBox(height: 24),

                    // Account Section
                    _buildSectionHeader(isVietnamese ? 'Tài khoản' : 'Account'),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      title: translations['profile']!,
                      icon: FontAwesomeIcons.user,
                      color: AppColors.text1Color,
                      onTap: () => navigateTo(const ProfileScreen()),
                    ),
                    _buildMenuItem(
                      title: translations['settings']!,
                      icon: FontAwesomeIcons.gear,
                      color: AppColors.text2Color,
                      onTap: () => navigateTo(const Settings()),
                    ),

                    // Language Selector
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.strokeColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.language, color: AppColors.button2Color),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              translations['language']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isVietnamese ? AppColors.buttonColor : AppColors.button2Color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isVietnamese ? 'VI' : 'EN',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: isVietnamese,
                            onChanged: (value) => setState(() => isVietnamese = value),
                            activeColor: AppColors.buttonColor,
                            activeTrackColor: AppColors.button2Color.withOpacity(0.3),
                            inactiveThumbColor: AppColors.buttonColor,
                            inactiveTrackColor: AppColors.strokeColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Auth Section
            Container(
              padding: const EdgeInsets.all(20),
              child: auth.tokenAuth != null
                  ? ElevatedButton.icon(
                      onPressed: () async => await auth.logout(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(translations['logout']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => navigateTo(const LoginScreen()),
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: Text(translations['login']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.text2Color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.text2Color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    bool isSelected = title == selectedMenuItem;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(right: 30, top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.buttonColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppColors.buttonColor : AppColors.strokeColor.withOpacity(0.5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: AppColors.buttonColor.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ] : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            selectedMenuItem = title;
          });
          onTap();
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : AppColors.text1Color,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : AppColors.text1Color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 22,
              color: isSelected ? Colors.white : AppColors.text2Color,
            ),
          ],
        ),
      ),
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
