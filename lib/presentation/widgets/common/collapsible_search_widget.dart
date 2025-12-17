import 'package:flutter/material.dart';
import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/service/product/product_service.dart';
import 'package:callparts/service/maker/maker_service.dart';
import 'package:callparts/model/product.dart';
import 'package:callparts/data/models/maker.dart';
import 'package:callparts/data/models/car_class.dart';
import 'package:callparts/presentation/pages/search/search_results_page.dart';

class CollapsibleSearchWidget extends StatefulWidget {
  final TextEditingController codeController;
  final String? selectedBrand;
  final String? selectedType;
  final List<String> vehicleTypes;
  final ValueChanged<String?> onBrandChanged;
  final ValueChanged<String?> onTypeChanged;
  final Function(List<Product>, String)? onSearchResults;

  const CollapsibleSearchWidget({
    Key? key,
    required this.codeController,
    required this.selectedBrand,
    required this.selectedType,
    required this.vehicleTypes,
    required this.onBrandChanged,
    required this.onTypeChanged,
    this.onSearchResults,
  }) : super(key: key);

  @override
  State<CollapsibleSearchWidget> createState() => _CollapsibleSearchWidgetState();
}

class _CollapsibleSearchWidgetState extends State<CollapsibleSearchWidget> {
  bool _isExpanded = false;
  final MakerService _makerService = MakerService();
  List<Maker> _makers = [];
  Map<int, List<CarClass>> _carClassesMap = {};
  bool _isLoading = false;
  
  Maker? _selectedMakerObj;
  CarClass? _selectedCarClassObj;

  @override
  void initState() {
    super.initState();
    _loadMakersWithCarClasses();
  }

  Future<void> _loadMakersWithCarClasses() async {
    setState(() => _isLoading = true);
    try {
      final makers = await _makerService.getCarClass();
      makers.sort((a, b) => a.makerName.toLowerCase().compareTo(b.makerName.toLowerCase()));
      
      setState(() {
        _makers = makers;
        for (var maker in makers) {
          if (maker.carClasses != null) {
            final sortedCarClasses = List<CarClass>.from(maker.carClasses!);
            sortedCarClasses.sort((a, b) => a.className.toLowerCase().compareTo(b.className.toLowerCase()));
            _carClassesMap[maker.id] = sortedCarClasses;
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _applyFilter(BuildContext context) async {
    final code = widget.codeController.text.trim();
    
    if (code.isEmpty && _selectedMakerObj == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng nhập mã sản phẩm hoặc chọn hãng xe'),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final ProductService productService = ProductService();
      final List<Product> results = await productService.search(
        codes: code.isNotEmpty ? code : null,
        makerId: _selectedMakerObj?.id,
        classId: _selectedCarClassObj?.id,
      );

      final searchQuery = code.isNotEmpty ? code : 
                          '${_selectedMakerObj?.makerName ?? ''} ${_selectedCarClassObj?.className ?? ''}'.trim();

      if (context.mounted) {
        Navigator.pop(context);
        
        if (widget.onSearchResults != null) {
          // Keep expanded when updating results in same page
          widget.onSearchResults!(results, searchQuery);
        } else {
          // Collapse and navigate to new page
          setState(() {
            _isExpanded = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsPage(
                products: results,
                searchQuery: searchQuery,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: Colors.white,
      child: Column(
        children: [
          // Compact Header - Always visible
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.buttonHome,
                          AppColors.buttonHome.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Tìm kiếm phụ tùng',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Compact Expandable Search Form
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Code Input - Compact
                  TextField(
                    controller: widget.codeController,
                    decoration: InputDecoration(
                      hintText: 'Mã phụ tùng',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.qr_code_scanner,
                        color: AppColors.buttonHome,
                        size: 18,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.buttonHome, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  
                  // Maker and Car Class - Compact Row
                  Row(
                    children: [
                      // Maker Dropdown
                      Expanded(
                        child: _isLoading
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              )
                            : DropdownButtonFormField<Maker>(
                                value: _selectedMakerObj,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  isDense: true,
                                ),
                                hint: const Text('Hãng xe', style: TextStyle(fontSize: 12)),
                                isExpanded: true,
                                items: _makers.map((maker) {
                                  return DropdownMenuItem<Maker>(
                                    value: maker,
                                    child: Text(
                                      maker.makerName,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (maker) {
                                  setState(() {
                                    _selectedMakerObj = maker;
                                    _selectedCarClassObj = null;
                                  });
                                  widget.onBrandChanged(maker?.makerName);
                                },
                              ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Car Class Dropdown
                      Expanded(
                        child: DropdownButtonFormField<CarClass>(
                          value: _selectedCarClassObj,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _selectedMakerObj != null ? Colors.white : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            isDense: true,
                          ),
                          hint: const Text('Loại xe', style: TextStyle(fontSize: 12)),
                          isExpanded: true,
                          items: _selectedMakerObj != null
                              ? (_carClassesMap[_selectedMakerObj!.id] ?? []).map((carClass) {
                                  return DropdownMenuItem<CarClass>(
                                    value: carClass,
                                    child: Text(
                                      carClass.className,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList()
                              : [],
                          onChanged: _selectedMakerObj != null
                              ? (carClass) {
                                  setState(() {
                                    _selectedCarClassObj = carClass;
                                  });
                                  widget.onTypeChanged(carClass?.className);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Compact Search Button
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => _applyFilter(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonHome,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 16, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'TÌM KIẾM',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
