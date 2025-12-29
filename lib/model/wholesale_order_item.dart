import 'wholesale_order.dart';
import 'product.dart';

class WholesaleOrderItem {
  final int id;
  final int wholesaleOrderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final WholesaleOrder? wholesaleOrder;
  final Product? product;

  WholesaleOrderItem({
    required this.id,
    required this.wholesaleOrderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    this.wholesaleOrder,
    this.product,
  });

  factory WholesaleOrderItem.fromJson(Map<String, dynamic> json) {
    return WholesaleOrderItem(
      id: json['id'],
      wholesaleOrderId: json['wholesale_order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      wholesaleOrder: json['wholesaleOrder'] != null
          ? WholesaleOrder.fromJson(json['wholesaleOrder'])
          : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wholesale_order_id': wholesaleOrderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'wholesaleOrder': wholesaleOrder?.toJson(),
      'product': product?.toJson(),
    };
  }
}
