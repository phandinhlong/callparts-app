import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/data/models/category.dart';
import 'package:callparts/service/category/category_services.dart';
import 'package:callparts/service/method_api.dart';
import 'package:callparts/service/open_shopee.dart';
import 'package:callparts/service/product/product_service.dart';
import 'package:callparts/presentation/widgets/common/product_card.dart';
import 'package:flutter/material.dart';
import 'package:callparts/model/product.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int _selectedImageIndex = 0;
  late TabController _tabController;
  late CategoryService cs = CategoryService();
  late ProductService _productService = ProductService();
  
  // Related products state
  List<Product> _relatedProducts = [];
  bool _isLoadingRelated = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getTabCount(), vsync: this);
    _loadRelatedProducts();
  }

  Future<void> _loadRelatedProducts() async {
    try {
      final relatedProducts = await _productService.getRelatedProducts(
        productId: widget.product.id,
        slug: widget.product.slug,
      );
      if (mounted) {
        setState(() {
          _relatedProducts = relatedProducts;
          _isLoadingRelated = false;
        });
      }
    } catch (e) {
      print('Error loading related products: $e');
      if (mounted) {
        setState(() {
          _isLoadingRelated = false;
        });
      }
    }
  }

  int _getTabCount() {
    int count = 0;
    if (widget.product.description != null &&
        widget.product.description!.isNotEmpty) count++;
    if (widget.product.oemCode != null && widget.product.oemCode!.isNotEmpty)
      count++;
    if (widget.product.afterMarketCode != null &&
        widget.product.afterMarketCode!.isNotEmpty) count++;
    if (widget.product.uses != null && widget.product.uses!.isNotEmpty) count++;
    return count > 0 ? count : 1;
  }

  List<Tab> _buildTabs() {
    List<Tab> tabs = [];
    if (widget.product.description != null &&
        widget.product.description!.isNotEmpty) {
      tabs.add(const Tab(text: 'MÔ TẢ'));
    }
    if (widget.product.oemCode != null && widget.product.oemCode!.isNotEmpty) {
      tabs.add(const Tab(text: 'MÃ CHÍNH HÃNG'));
    }
    if (widget.product.afterMarketCode != null &&
        widget.product.afterMarketCode!.isNotEmpty) {
      tabs.add(const Tab(text: 'MÃ THAY THẾ'));
    }
    if (widget.product.uses != null && widget.product.uses!.isNotEmpty) {
      tabs.add(const Tab(text: 'SỬ DỤNG'));
    }
    if (tabs.isEmpty) {
      tabs.add(const Tab(text: 'THÔNG TIN'));
    }
    return tabs;
  }

  List<Widget> _buildTabViews() {
    List<Widget> views = [];

    if (widget.product.description != null &&
        widget.product.description!.isNotEmpty) {
      views.add(
        Html(
          data: widget.product.description ?? 'Không có mô tả',
        ),
      );
    }

    if (widget.product.oemCode != null && widget.product.oemCode!.isNotEmpty) {
      views.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCodeTable(widget.product.oemCode!),
          ],
        ),
      );
    }

    if (widget.product.afterMarketCode != null &&
        widget.product.afterMarketCode!.isNotEmpty) {
      views.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCodeTable(widget.product.afterMarketCode!),
          ],
        ),
      );
    }

    if (widget.product.uses != null && widget.product.uses!.isNotEmpty) {
      views.add(
        Html(
          data: widget.product.uses ?? 'Không có thông tin sử dụng',
        ),
      );
    }

    if (views.isEmpty) {
      views.add(
        const Text(
          'Không có thông tin',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      );
    }

    return views;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price.toInt())}đ';
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
          widget.product.productName.toUpperCase(),
          style: const TextStyle(
            color: AppColors.buttonTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.buttonTextColor),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border,
                color: AppColors.buttonTextColor),
            onPressed: () {
              // TODO: Implement favorite functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Gallery Section
                  _buildImageGallery(),

                  const SizedBox(height: 16),

                  // Product Info Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          widget.product.productName.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3436),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'Mã SP: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.product.pCode.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007BFF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Product Code
                        Row(
                          children: [
                            const Text(
                              'Danh mục: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            FutureBuilder<Category?>(
                              future:
                                  cs.getCategoryById(widget.product.categoryId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                    snapshot.data!.categoryName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF007BFF),
                                    ),
                                  );
                                }
                                return const Text(
                                  'Đang tải...',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF007BFF),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Views
                        Row(
                          children: [
                            const Text(
                              'Lượt xem: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${widget.product.numberOfViewed ?? 0}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Brand
                        Row(
                          children: [
                            const Text(
                              'Thương hiệu: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.product.manufacturer?.manufacturerName ??
                                  'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        if (widget.product.shoppeLink != null &&
                            widget.product.shoppeLink!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              OpenShopee().openShopeeUrl(
                                  widget.product.shoppeLink.toString());
                              print(1);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEE4D2D).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFEE4D2D),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Mua trên Shopee',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFEE4D2D),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Shopee logo icon
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEE4D2D),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'S',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),

                        // Price
                        Text(
                          _formatPrice(widget.product.price),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD32F2F),
                          ),
                        ),
                        const SizedBox(height: 8),
                        widget.product.specifications != null &&
                                widget.product.specifications!.isNotEmpty
                            ? SingleChildScrollView(
                                child: Html(
                                  data: widget.product.specifications!,
                                ),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 2),
                        // Stock
                        Row(
                          children: [
                            const Text(
                              'Còn lại: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '${widget.product.stock} Sản phẩm',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1),

                  // Tabs Section
                  _buildTabSection(),

                  // Related Products Section
                  if (_relatedProducts.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    _buildRelatedProductsSection(),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Add to Cart Button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : ['assets/images/placeholder.png'];

    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          // Main Image
          SizedBox(
            height: 300,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: urlImg+images[_selectedImageIndex],
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // Thumbnail Navigation
          if (images.length > 1)
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedImageIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF007BFF)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: urlImg+images[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
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

  Widget _buildTabSection() {
    final tabs = _buildTabs();
    final tabViews = _buildTabViews();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF007BFF),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF007BFF),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          isScrollable: true,
          tabs: tabs,
          onTap: (index) {
            setState(() {
              // Rebuild to show selected tab content
            });
          },
        ),
        const SizedBox(height: 16),
        // Display the selected tab's content directly
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: tabViews[_tabController.index],
        ),
      ],
    );
  }

  Widget _buildCodeTable(String codeString) {
    final lines =
        codeString.split('\n').where((line) => line.trim().isNotEmpty).toList();

    if (lines.isEmpty) {
      return const Text(
        'Không có dữ liệu',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF007BFF).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nhà sản xuất',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007BFF),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Mã sản phẩm',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007BFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ...lines.asMap().entries.map((entry) {
            final index = entry.key;
            final line = entry.value;
            final parts = line.split(',').map((e) => e.trim()).toList();

            final manufacturer = parts.isNotEmpty ? parts[0] : '';
            final code = parts.length > 1 ? parts[1] : '';

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      manufacturer,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRelatedProductsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'SẢN PHẨM LIÊN QUAN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _isLoadingRelated
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _relatedProducts.length > 6 ? 6 : _relatedProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: _relatedProducts[index]);
                  },
                ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${widget.product.productName} đã thêm vào giỏ'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007BFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'THÊM VÀO GIỎ HÀNG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
