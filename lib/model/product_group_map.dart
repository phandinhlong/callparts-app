class ProductGroupMap {
  final int id;
  final int productId;
  final int productGroupId;

  ProductGroupMap({
    required this.id,
    required this.productId,
    required this.productGroupId,
  });

  factory ProductGroupMap.fromJson(Map<String, dynamic> json) {
    return ProductGroupMap(
      id: json['id'],
      productId: json['product_id'],
      productGroupId: json['product_group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_group_id': productGroupId,
    };
  }
}
