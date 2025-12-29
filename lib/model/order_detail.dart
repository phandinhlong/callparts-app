import 'product.dart';

class OrderDetail {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final String pCode;
  final double price;
  final double? discount;
  final double? originalPrice;
  final double? taxRate;
  final String? option;
  final Product? product;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.pCode,
    required this.price,
    this.discount,
    this.originalPrice,
    this.taxRate,
    this.option,
    this.product,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      pCode: json['p_code'],
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      taxRate: (json['taxRate'] as num?)?.toDouble(),
      option: json['option'],
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'p_code': pCode,
      'price': price,
      'discount': discount,
      'original_price': originalPrice,
      'taxRate': taxRate,
      'option': option,
      'product': product?.toJson(),
    };
  }
}
