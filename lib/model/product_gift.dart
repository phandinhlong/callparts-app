import 'product.dart';

class ProductGift {
  final int id;
  final int productId;
  final int productGiftId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final Product? product;
  final Product? gift;

  ProductGift({
    required this.id,
    required this.productId,
    required this.productGiftId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.product,
    this.gift,
  });

  factory ProductGift.fromJson(Map<String, dynamic> json) {
    return ProductGift(
      id: json['id'],
      productId: json['product_id'],
      productGiftId: json['product_gift_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      gift: json['gift'] != null ? Product.fromJson(json['gift']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_gift_id': productGiftId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'product': product?.toJson(),
      'gift': gift?.toJson(),
    };
  }
}
