import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/service/method_api.dart';
import 'package:flutter/material.dart';
import 'package:callparts/model/product.dart';
import 'package:callparts/data/models/category.dart';
import 'package:callparts/service/category/category_services.dart';
import 'package:callparts/presentation/widgets/common/product_card.dart';
import 'package:callparts/presentation/widgets/common/collapsible_search_widget.dart';

enum SortOption {
  nameAZ('Tên A đến Z'),
  nameZA('Tên Z đến A'),
  priceAsc('Giá tăng dần'),
  priceDesc('Giá giảm dần');

  final String label;

  const SortOption(this.label);
}

class CategoryProductsPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String categoryImage;
  final List<Product> allProducts;

  const CategoryProductsPage({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.allProducts,
  }) : super(key: key);

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final CategoryService _categoryService = CategoryService();
  List<Category> _subcategories = [];
  bool _isLoadingSubcategories = true;
  int _selectedSubcategoryIndex = 0;
  SortOption? _selectedSort;

  List<Product> _products = [];

  bool _isLoadingProducts = true;

  // Search widget state
  String? _selectedBrand;
  String? _selectedType;
  final TextEditingController _codeController = TextEditingController();
  final List<String> vehicleTypes = [
    'Tất cả',
    'Toyota',
    'Honda',
    'Hyundai',
    'Mazda',
    'Kia',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingSubcategories = true;
      _isLoadingProducts = true;
    });
    try {
      final category =
          await _categoryService.getCategoryById(widget.categoryId);

      if (category != null) {
        final products =
            await _categoryService.getProductsByCategorySlug(category.slug);
        if (mounted) {
          setState(() {
            _subcategories = category.children;
            _products = products;
            _isLoadingSubcategories = false;
            _isLoadingProducts = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingSubcategories = false;
            _isLoadingProducts = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSubcategories = false;
          _isLoadingProducts = false;
        });
      }
    }
  }

  List<Product> get filteredProducts {
    List<Product> filtered = List.from(_products);

    if (_selectedSort != null) {
      switch (_selectedSort!) {
        case SortOption.nameAZ:
          filtered.sort((a, b) => a.productName
              .toLowerCase()
              .compareTo(b.productName.toLowerCase()));
          break;
        case SortOption.nameZA:
          filtered.sort((a, b) => b.productName
              .toLowerCase()
              .compareTo(a.productName.toLowerCase()));
          break;
        case SortOption.priceAsc:
          filtered.sort((a, b) {
            final priceA = a.discountPrice ?? a.price;
            final priceB = b.discountPrice ?? b.price;
            return priceA.compareTo(priceB);
          });
          break;
        case SortOption.priceDesc:
          filtered.sort((a, b) {
            final priceA = a.discountPrice ?? a.price;
            final priceB = b.discountPrice ?? b.price;
            return priceB.compareTo(priceA);
          });
          break;
      }
    }

    return filtered;
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.sort, color: AppColors.buttonColor, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Sắp xếp theo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Sort options
              ...SortOption.values.map((option) {
                final isSelected = _selectedSort == option;
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedSort = option;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.buttonColor.withAlpha(13)
                          : null,
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.grey.shade100, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.buttonColor
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.buttonColor,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.buttonTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName.toUpperCase(),
          style: const TextStyle(
            color: AppColors.buttonTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CollapsibleSearchWidget(
            codeController: _codeController,
            selectedBrand: _selectedBrand,
            selectedType: _selectedType,
            vehicleTypes: vehicleTypes,
            onBrandChanged: (value) => setState(() => _selectedBrand = value),
            onTypeChanged: (value) => setState(() => _selectedType = value),
          ),
          _buildSubcategorySelector(),
          const SizedBox(height: 12),
          _buildSortOptions(),
          const Divider(height: 1),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      'Không có sản phẩm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategorySelector() {
    if (_isLoadingSubcategories) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          color: AppColors.buttonHome,
        ),
      );
    }

    if (_subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = _subcategories[index];
          final isSelected = index == _selectedSubcategoryIndex;
          final imagePath =
              urlImg + (subcategory.image ?? '/data/categories/default.jpg');
          final imageUrl = imagePath.startsWith('/')
              ? 'https://callparts.vn$imagePath'
              : imagePath;
          final isNetworkImage = imagePath.startsWith('http://') ||
              imagePath.startsWith('https://') ||
              imagePath.startsWith('/');

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProductsPage(
                    categoryId: subcategory.id,
                    categoryName: subcategory.categoryName,
                    categoryImage:
                        subcategory.image ?? '/data/categories/default.jpg',
                    allProducts: widget.allProducts,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.buttonHome.withAlpha(26)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.buttonHome
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: isNetworkImage
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.category, size: 30),
                          )
                        : Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.category, size: 30),
                          ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 70,
                    child: Text(
                      subcategory.categoryName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? AppColors.buttonHome
                            : Colors.grey.shade700,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            'Tìm thấy ${filteredProducts.length} sản phẩm',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Sort Button
          InkWell(
            onTap: _showSortOptions,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sort, size: 18, color: Colors.grey.shade700),
                  const SizedBox(width: 6),
                  Text(
                    _selectedSort?.label ?? 'Sắp xếp',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
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
}
