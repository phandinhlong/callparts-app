import 'dart:async';

import 'package:flutter/material.dart';
import 'package:callparts/service/slider/slider_service.dart';
import 'package:callparts/service/method_api.dart';
import 'package:callparts/core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:callparts/model/product.dart';
import 'package:callparts/presentation/widgets/common/categories_widget.dart';
import 'package:callparts/presentation/widgets/common/compact_search_widget.dart';
import 'package:callparts/presentation/pages/settings/Views/grocery_notifications.dart';
import 'package:callparts/presentation/pages/cartScreen/cart_screen.dart';
import 'package:callparts/presentation/pages/search/banner_search_screen.dart';
import 'package:callparts/presentation/pages/profile/profile_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> filteredProducts = [];
  String? _selectedBrand;
  String? _selectedType;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedVehicleType;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  List<String> _banners = [];
  bool _isLoadingBanners = true;
  final List<String> vehicleTypes = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBanners();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_banners.isEmpty) return;
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadBanners() async {
    try {
      final images = await SliderService().getImg();
      final validImages = images.where((img) => img != null).cast<String>().toList();

      if (mounted) {
        setState(() {
          _banners = validImages;
          _isLoadingBanners = false;
        });
      }
    } catch (e) {
      print('Error loading banners: $e');
      if (mounted) {
        setState(() {
          _isLoadingBanners = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }


  void _resetFilter() {
    _codeController.clear();
    _searchController.clear();
    setState(() {
      _selectedVehicleType = 'Tất cả';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: AppColors.buttonColor,
              title: const Text(
                'Callpart',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                      Icons.shopping_cart_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GroceryNotifications()),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 400));
                  _resetFilter();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: _isLoadingBanners
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : _banners.isEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Không có banner',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      )
                                    : PageView.builder(
                                        controller: _pageController,
                                        itemCount: _banners.length,
                                        onPageChanged: (index) {
                                          setState(() => _currentPage = index);
                                        },
                                        itemBuilder: (context, index) {
                                          return _buildBanner(_banners[index]);
                                        },
                                      ),
                          ),
                          const SizedBox(height: 8),
                          if (!_isLoadingBanners && _banners.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_banners.length, (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  width: _currentPage == index ? 10 : 6,
                                  height: _currentPage == index ? 10 : 6,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? AppColors.buttonColor
                                        : Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CompactSearchWidget(
                        codeController: _codeController,
                        selectedBrand: _selectedBrand,
                        selectedType: _selectedType,
                        vehicleTypes: vehicleTypes,
                        onBrandChanged: (value) => setState(() => _selectedBrand = value),
                        onTypeChanged: (value) => setState(() => _selectedType = value),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Danh mục sản phẩm",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const CategoriesWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home, size: 24),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined, size: 24),
              activeIcon: Icon(Icons.search, size: 24),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 24),
              activeIcon: Icon(Icons.shopping_cart, size: 24),
              label: 'Giỏ hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person, size: 24),
              label: 'Tài khoản',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.buttonColor,
          unselectedItemColor: Colors.grey.shade500,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildBanner(String path) {
    final imageUrl = urlImg + path;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SearchScreen(),
          ),
        );
      },
      child: SizedBox(
        width: 270,
        height: 270,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.25),
                colorBlendMode: BlendMode.darken,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Lỗi tải ảnh',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
