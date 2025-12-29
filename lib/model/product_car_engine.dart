class ProductCarEngine {
  final int id;
  final int productId;
  final int carEngineId;

  ProductCarEngine({
    required this.id,
    required this.productId,
    required this.carEngineId,
  });

  factory ProductCarEngine.fromJson(Map<String, dynamic> json) {
    return ProductCarEngine(
      id: json['id'],
      productId: json['product_id'],
      carEngineId: json['car_engine_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'car_engine_id': carEngineId,
    };
  }
}
