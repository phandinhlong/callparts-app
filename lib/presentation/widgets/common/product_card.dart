import 'package:callparts/service/method_api.dart';
import 'package:flutter/material.dart';
import 'package:callparts/model/product.dart';
import 'package:callparts/presentation/pages/product/product_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  String _formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(price.toInt())}đ';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
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
              child: Container(
                color: const Color(0xFFF8F9FA),
                child: product.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: urlImg+product.images.first,
                        fit: BoxFit.cover,
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
            ),
          ),
          
          // Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.productName.toUpperCase(),
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
                            product.pCode.toString(),
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
                          product.manufacturer?.manufacturerName ?? 'N/A',
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
                        '${product.numberOfViewed ?? 0}',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Price
                  Text(
                    _formatPrice(product.price),
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
                      onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.productName} đã thêm vào giỏ'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
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
