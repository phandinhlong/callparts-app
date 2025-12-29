import 'package:callparts/service/method_api.dart';
import 'package:flutter/material.dart';
import 'package:callparts/model/product.dart';
import 'package:callparts/presentation/pages/product/product_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:callparts/presentation/providers/cart_provider.dart';
import 'package:callparts/presentation/providers/favorite_provider.dart';
import 'package:callparts/presentation/widgets/animations/fly_to_cart_animation.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final GlobalKey? cartIconKey;

  const ProductCard({
    Key? key,
    required this.product,
    this.cartIconKey,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final GlobalKey _productImageKey = GlobalKey();
  bool _isAdding = false;

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price.toInt())}đ';
  }

  void _addToCart() async {
    if (_isAdding) return;

    setState(() {
      _isAdding = true;
    });

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    // Add to cart
    cartProvider.addItem(widget.product);

    // Trigger animation
    final imageUrl = widget.product.images.isNotEmpty 
        ? urlImg + widget.product.images.first 
        : '';
    
    // Find cart icon key - try widget's key first, then search for it
    final targetKey = widget.cartIconKey ?? _findCartIconKey();
    
    if (targetKey != null) {
      FlyToCartHelper.startAnimation(
        context: context,
        imageUrl: imageUrl,
        sourceKey: _productImageKey,
        targetKey: targetKey,
        isNetworkImage: true,
        onComplete: () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.product.productName} đã thêm vào giỏ'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
              ),
            );
            
            setState(() {
              _isAdding = false;
            });
          }
        },
      );
    } else {
      // Fallback if no cart icon found
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.product.productName} đã thêm vào giỏ'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
        
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  GlobalKey? _findCartIconKey() {
    // Try to find cart icon in the widget tree
    // This is a fallback - ideally the key should be passed from parent
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: widget.product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    Container(
                      key: _productImageKey,
                      color: const Color(0xFFF8F9FA),
                      child: widget.product.images.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: urlImg + widget.product.images.first,
                              fit: BoxFit.cover,
                              httpHeaders: const {
                                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                                'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                              },
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.image_not_supported, color: Colors.grey),
                            ),
                    ),
                    // Favorite Icon Button
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Consumer<FavoriteProvider>(
                        builder: (context, favoriteProvider, child) {
                          final isFavorite = favoriteProvider.isFavorite(widget.product.id);
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                favoriteProvider.toggleFavorite(widget.product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite 
                                          ? 'Đã xóa khỏi yêu thích' 
                                          : 'Đã thêm vào yêu thích',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: isFavorite ? Colors.grey : Colors.green,
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.productName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF2D3436),
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        const Text(
                          'Mã: ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.product.pCode.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE67E22),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    
                    // Brand
                    Row(
                      children: [
                        const Text(
                          'Hãng: ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Expanded(
                          child: Text(
                            widget.product.manufacturer?.manufacturerName ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    
                    // Views
                    Row(
                      children: [
                        const Icon(Icons.visibility_outlined, size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.product.numberOfViewed ?? 0}',
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Price
                    Text(
                      _formatPrice(widget.product.price),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: _isAdding ? null : _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          disabledBackgroundColor: Colors.grey[400],
                        ),
                        child: _isAdding
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Thêm vào giỏ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
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
