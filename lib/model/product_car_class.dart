class ProductCarClass {
  final int id;
  final int productId;
  final int carClassId;

  ProductCarClass({
    required this.id,
    required this.productId,
    required this.carClassId,
  });

  factory ProductCarClass.fromJson(Map<String, dynamic> json) {
    return ProductCarClass(
      id: json['id'],
      productId: json['product_id'],
      carClassId: json['car_class_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'car_class_id': carClassId,
    };
  }
}
