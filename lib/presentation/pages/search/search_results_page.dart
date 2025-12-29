import 'package:flutter/material.dart';
import 'package:callparts/model/product.dart';
import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/presentation/widgets/common/product_card.dart';
import 'package:callparts/presentation/widgets/common/collapsible_search_widget.dart';
import 'package:callparts/presentation/widgets/common/cart_icon_with_badge.dart';

enum SortOption {
  nameAZ('Tên A đến Z'),
  nameZA('Tên Z đến A'),
  priceAsc('Giá tăng dần'),
  priceDesc('Giá giảm dần');

  final String label;
  const SortOption(this.label);
}

class SearchResultsPage extends StatefulWidget {
  final List<Product> products;
  final String? searchQuery;

  const SearchResultsPage({
    super.key,
    required this.products,
    this.searchQuery,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
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

  late List<Product> _currentProducts;
  late String? _currentSearchQuery;
  SortOption? _selectedSort;

  @override
  void initState() {
    super.initState();
    _currentProducts = List.from(widget.products); // Create a copy
    _currentSearchQuery = widget.searchQuery;
  }

  void _updateSearchResults(List<Product> products, String searchQuery) {
    setState(() {
      _currentProducts = List.from(products); // Create a copy
      _currentSearchQuery = searchQuery;
      _selectedSort = null; // Reset sort when new search
    });
  }

  void _sortProducts(SortOption? option) {
    if (option == null) return;
    
    setState(() {
      _selectedSort = option;
      List<Product> sortedList = List.from(_currentProducts);
      
      switch (option) {
        case SortOption.nameAZ:
          sortedList.sort((a, b) => 
            a.productName.toLowerCase().compareTo(b.productName.toLowerCase())
          );
          break;
        case SortOption.nameZA:
          sortedList.sort((a, b) => 
            b.productName.toLowerCase().compareTo(a.productName.toLowerCase())
          );
          break;
        case SortOption.priceAsc:
          sortedList.sort((a, b) {
            final priceA = a.discountPrice ?? a.price;
            final priceB = b.discountPrice ?? b.price;
            return priceA.compareTo(priceB);
          });
          break;
        case SortOption.priceDesc:
          sortedList.sort((a, b) {
            final priceA = a.discountPrice ?? a.price;
            final priceB = b.discountPrice ?? b.price;
            return priceB.compareTo(priceA);
          });
          break;
      }
      
      _currentProducts = sortedList;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.sort, color: AppColors.buttonColor, size: 22),
                    const SizedBox(width: 8),
                    const Text(
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
                    _sortProducts(option);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.buttonColor.withAlpha(13) : null,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade100, width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? AppColors.buttonColor : Colors.black87,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kết quả tìm kiếm:  ${_currentSearchQuery!}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            // if (_currentSearchQuery != null && _currentSearchQuery!.isNotEmpty)
            //   Text(
            //     _currentSearchQuery!,
            //     style: const TextStyle(
            //       color: Colors.white70,
            //       fontSize: 12,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     maxLines: 1,
            //     overflow: TextOverflow.ellipsis,
            //   ),
          ],
        ),
        centerTitle: false,
        actions: [
          CartIconWithBadge(
            iconColor: AppColors.buttonTextColor,
            badgeColor: AppColors.text3Color,
          ),
        ],
      ),
      body: Column(
        children: [
          // Collapsible Search Widget
          CollapsibleSearchWidget(
            codeController: _codeController,
            selectedBrand: _selectedBrand,
            selectedType: _selectedType,
            vehicleTypes: vehicleTypes,
            onBrandChanged: (value) => setState(() => _selectedBrand = value),
            onTypeChanged: (value) => setState(() => _selectedType = value),
            onSearchResults: _updateSearchResults,
          ),
          // Product Count and Sort
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Tìm thấy ${_currentProducts.length} sản phẩm',
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
          ),
          Expanded(
            child: _currentProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.search_off,
                            size: 48,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Không tìm thấy sản phẩm',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Hãy thử từ khóa khác hoặc điều chỉnh bộ lọc tìm kiếm',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Quay lại tìm kiếm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: _currentProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: _currentProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
