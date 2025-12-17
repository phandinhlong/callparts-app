import 'package:callparts/data/models/product.dart';
import 'package:callparts/presentation/pages/home/starter_battery_details_screen.dart';
import 'package:callparts/presentation/widgets/common/product_data.dart';
import 'package:flutter/material.dart';
import 'package:callparts/core/constants/app_colors.dart';

import '../../widgets/common/product_search_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final List<Product> allProducts = ProductData().products;
  List<Product> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  
  final TextEditingController _codeController = TextEditingController();
  String? _selectedBrand;
  String? _selectedType;
  final List<String> vehicleTypes = [
    'Tất cả',
    'Toyota',
    'Honda',
    'Hyundai',
    'Mazda',
    'Kia',
  ];

  String? selectedBrand;
  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 1000000);
  bool showFilters = false;

  final List<String> brands = ['Tất cả', 'BOSCH', 'NGK', 'DENSO', 'TOYOTA'];
  final List<String> categories = ['Tất cả', 'Ắc quy', 'Bugi', 'Dầu máy', 'Lọc gió'];

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts;
  }

  void _applyFilters() {
    setState(() {
      filteredProducts = allProducts.where((product) {
        final matchesSearch = _searchController.text.isEmpty ||
            product.productName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            product.manufacturerId.toString().toLowerCase().contains(_searchController.text.toLowerCase());//chờ sửa
        final matchesBrand = selectedBrand == null || selectedBrand == 'Tất cả' ||
            product.manufacturerId.toString().toLowerCase() == selectedBrand!.toLowerCase();//chờ sửa
        return matchesSearch && matchesBrand ;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      selectedBrand = null;
      selectedCategory = null;
      priceRange = const RangeValues(0, 1000000);
      filteredProducts = allProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        elevation: 0,
        title: const Text(
          'Tìm kiếm',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: showFilters ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                showFilters ? Icons.filter_list_off : Icons.filter_list,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  showFilters = !showFilters;
                });
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(0, 1),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: ProductSearchWidget(
              codeController: _codeController,
              selectedBrand: _selectedBrand,
              selectedType: _selectedType,
              vehicleTypes: vehicleTypes,
              onBrandChanged: (value) => setState(() => _selectedBrand = value),
              onTypeChanged: (value) => setState(() => _selectedType = value),
            ),
          ),

          // Filters Panel
          if (showFilters)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: _resetFilters,
                        child: const Text(
                          'Đặt lại',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Brand Filter
                  const Text(
                    'Hãng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: brands.map((brand) {
                      final isSelected = selectedBrand == brand;
                      return FilterChip(
                        label: Text(brand),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedBrand = selected ? brand : null;
                          });
                          _applyFilters();
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.blue.shade100,
                        checkmarkColor: Colors.blue,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Price Range
                  const Text(
                    'Khoảng giá',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  RangeSlider(
                    values: priceRange,
                    min: 0,
                    max: 1000000,
                    divisions: 100,
                    labels: RangeLabels(
                      '${priceRange.start.toInt()}đ',
                      '${priceRange.end.toInt()}đ',
                    ),
                    onChanged: (values) {
                      setState(() {
                        priceRange = values;
                      });
                      _applyFilters();
                    },
                    activeColor: Colors.blue,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${priceRange.start.toInt()}đ'),
                      Text('${priceRange.end.toInt()}đ'),
                    ],
                  ),
                ],
              ),
            ),

          // Results
          Expanded(
            child: filteredProducts.isEmpty
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
                        Text(
                          'Hãy thử từ khóa khác hoặc điều chỉnh bộ lọc',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _resetFilters,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Đặt lại bộ lọc'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
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
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StarterBatteryDetailsScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Image.asset(
                                    product.images.first,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  product.manufacturerId.toString().toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${product.price}đ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
