class ProductCategory {
  final int id;
  final int productId;
  final int categoryId;

  ProductCategory({
    required this.id,
    required this.productId,
    required this.categoryId,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      productId: json['product_id'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'category_id': categoryId,
    };
  }
}
