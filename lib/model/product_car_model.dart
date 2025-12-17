class ProductCarModel {
  final int id;
  final int productId;
  final int carModelId;

  ProductCarModel({
    required this.id,
    required this.productId,
    required this.carModelId,
  });

  factory ProductCarModel.fromJson(Map<String, dynamic> json) {
    return ProductCarModel(
      id: json['id'],
      productId: json['product_id'],
      carModelId: json['car_model_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'car_model_id': carModelId,
    };
  }
}
