import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:callparts/core/constants/app_colors.dart';
import 'package:callparts/model/cart_item.dart';
import 'package:callparts/presentation/providers/cart_provider.dart';
import 'package:callparts/presentation/pages/checkout/shipping_address_screen.dart';
import 'package:callparts/presentation/pages/product/product_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:callparts/service/method_api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.buttonColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        titleSpacing: 0,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(0, 1),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            height: 1,
          ),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final cartItems = cart.items;
          final selectedCount = cart.selectedItemsCount;
          
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? _buildEmptyCart(context)
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            return _CartItemCard(
                              item: cartItems[index],
                              onRemove: () => cart.removeItem(cartItems[index].productId),
                              onQuantityChanged: (value) => cart.updateQuantity(
                                cartItems[index].productId,
                                value,
                              ),
                              onSelectedChanged: (selected) =>
                                  cart.toggleSelection(cartItems[index].productId, selected),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemCount: cartItems.length,
                        ),
                ),

                if (cartItems.isNotEmpty)
                  _CartBottomBar(
                    subtotal: cart.subtotal,
                    shippingFee: cart.shippingFee,
                    tax: cart.tax,
                    total: cart.total,
                    discount: cart.discount,
                    itemCount: selectedCount,
                    onCheckout: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShippingAddressScreen(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.buttonColor,
                  AppColors.text3Color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.tabColor.withOpacity(0.6),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.gears,
                  size: 40,
                  color: Colors.white70,
                ),
                Positioned(
                  bottom: 32,
                  right: 30,
                  child: Icon(
                    FontAwesomeIcons.carOn,
                    size: 26,
                    color: AppColors.buttonColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Giỏ hàng của bạn đang trống',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text1Color,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hãy thêm phụ tùng, linh kiện để bắt đầu bảo dưỡng chiếc xe của bạn.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.text2Color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(FontAwesomeIcons.wrench),
            label: const Text('Tiếp tục mua phụ tùng'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.text3Color,
              foregroundColor: AppColors.buttonTextColor,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartColors {
  static const card = Colors.white;
  static const border = AppColors.strokeColor;
  static const accent = AppColors.text3Color;
  static const textPrimary = AppColors.text1Color;
  static const textSecondary = AppColors.text2Color;
  static const badgeBackground = Color(0xFFF5F5F5);
  static const quantityBg = Colors.white;
  static const bottomBar = Colors.white;
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
    required this.onSelectedChanged,
  });

  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<bool> onSelectedChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to product detail page
        if (item.product != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: item.product!),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: _CartColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _CartColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: item.selected,
                activeColor: AppColors.buttonColor,
                onChanged: (v) => onSelectedChanged(v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),

              // ẢNH SẢN PHẨM
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.imagePath.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: urlImg + item.imagePath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
              ),

              const SizedBox(width: 12),

              // NỘI DUNG
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // TÊN + NÚT XOÁ
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _CartColors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: _CartColors.textSecondary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 32, minHeight: 32),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // BRAND
                    Text(
                      item.brand.isNotEmpty ? item.brand : 'Garage AutoCare',
                      style: const TextStyle(
                        fontSize: 11,
                        color: _CartColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // PART INFO
                    if (item.partNumber != null ||
                        item.oemCode != null ||
                        item.compatibility != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.partNumber != null)
                            Text(
                              'Mã SP: ${item.partNumber}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: _CartColors.textSecondary,
                              ),
                            ),
                          if (item.oemCode != null)
                            Text(
                              'OEM: ${item.oemCode}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: _CartColors.textSecondary,
                              ),
                            ),
                          if (item.compatibility != null)
                            Text(
                              'Dòng xe: ${item.compatibility}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: _CartColors.textSecondary,
                              ),
                            ),
                        ],
                      ),

                    const SizedBox(height: 10),

                    // GIÁ + QUANTITY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thành tiền',
                              style: TextStyle(
                                fontSize: 11,
                                color: _CartColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatStaticCurrency(item.totalPrice),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text3Color,
                              ),
                            ),
                          ],
                        ),

                        _QuantityControl(
                          quantity: item.quantity,
                          onChanged: onQuantityChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }

  String _formatStaticCurrency(double amount) {
    final formatted = amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted đ';
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _CartColors.quantityBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.strokeColor.withOpacity(0.6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          _buildIconButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: AppColors.text1Color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildIconButton(
            icon: Icons.add,
            onTap: quantity < 99 ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: enabled ? Colors.white : Colors.transparent,
          border: Border.all(color: AppColors.strokeColor),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.text1Color : _CartColors.textSecondary,
        ),
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({
    required this.subtotal,
    required this.shippingFee,
    required this.tax,
    required this.total,
    required this.discount,
    required this.itemCount,
    required this.onCheckout,
  });

  final double subtotal;
  final double shippingFee;
  final double tax;
  final double total;
  final double discount;
  final int itemCount;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _CartColors.bottomBar,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- NHẬP MÃ GIẢM GIÁ ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFF8E1),
                    const Color(0xFFFFECB3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFD54F).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD54F).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.ticket,
                    size: 14,
                    color: Color(0xFFF57C00),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mã giảm giá',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFFE65100),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Nhập mã ưu đãi dành riêng cho garage / shop',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF6D4C41),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF9800),
                          const Color(0xFFFB8C00),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9800).withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Nhập mã',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- TÓM TẮT CHI PHÍ ---
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: AppColors.strokeColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tóm tắt chi phí',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.buttonTextColor,
                ),
              ),

              const SizedBox(height: 14),

              _buildCostRow('Tạm tính', _formatTotal(subtotal)),
              const SizedBox(height: 8),

              _buildCostRow('Giảm giá', '- 0 đ'),
              const SizedBox(height: 8),

              _buildCostRow('Phí vận chuyển', _formatTotal(shippingFee)),
              const SizedBox(height: 8),

              _buildCostRow('Thuế VAT (8%)', _formatTotal(tax)),

              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.strokeColor),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng thanh toán',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.buttonTextColor,
                    ),
                  ),
                  Text(
                    _formatTotal(total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text3Color,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$itemCount sản phẩm',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: _CartColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

            // --- BUTTON CHECKOUT ---
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF4CAF50).withOpacity(0.4),
                ),
                onPressed: onCheckout,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_bag_outlined, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Thanh toán ngay',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
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

  Widget _buildCostRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: _CartColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.text1Color,
          ),
        ),
      ],
    );
  }
  static String _formatTotal(double amount) {
    final formatted = amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted đ';
  }
}
