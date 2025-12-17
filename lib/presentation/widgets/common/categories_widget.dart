import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/service/method_api.dart';
import 'package:flutter/material.dart';
import 'package:callparts/presentation/pages/category/category_products_page.dart';
import 'package:callparts/service/category/category_services.dart';
import 'package:callparts/data/models/category.dart';
import 'categories_column.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  final ScrollController _scrollController = ScrollController();
  double _currentScrollPosition = 0.0;
  int _currentPage = 0;

  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final allCategories = await _categoryService.getParentCategories();
      setState(() {
        _categories = allCategories;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    setState(() {
      _currentScrollPosition = _scrollController.position.pixels;
      final maxScroll = _scrollController.position.maxScrollExtent;

      if (maxScroll > 0) {
        final scrollPercentage = _currentScrollPosition / maxScroll;
        _currentPage = (scrollPercentage * (_totalPages - 1)).round();
      } else {
        _currentPage = 0;
      }
    });
  }

  int get _totalPages {
    if (_categories.isEmpty) return 1;
    final itemsPerPage = 9;
    return ((_categories.length / itemsPerPage).ceil()).clamp(1, 3);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
         decoration: const BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.all(Radius.circular(10))
         ),
          height: 480,
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.buttonHome,
            ),
          )
              : _errorMessage != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Lỗi tải danh mục',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadCategories,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonHome,
                  ),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          )
              : _categories.isEmpty
              ? const Center(
            child: Text(
              'Không có danh mục',
              style: TextStyle(color: Colors.grey),
            ),
          )
              : GridView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 10,
                childAspectRatio: 0.85,
                mainAxisExtent:150
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryItem(
                imagePath: urlImg +
                    (category.image ??
                        '/data/categories/default.jpg'),
                text: category.categoryName,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryProductsPage(
                            categoryId: category.id,
                            categoryName: category.categoryName,
                            categoryImage: category.image ??
                                '/data/categories/default.jpg',
                            allProducts: const [],
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Page Indicators
        if (!_isLoading && _categories.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_totalPages, (index) {
              final isActive = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.buttonHome
                      : AppColors.buttonHome.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
