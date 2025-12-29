class ProductMaker {
  final int id;
  final int productId;
  final int makerId;

  ProductMaker({
    required this.id,
    required this.productId,
    required this.makerId,
  });

  factory ProductMaker.fromJson(Map<String, dynamic> json) {
    return ProductMaker(
      id: json['id'],
      productId: json['product_id'],
      makerId: json['maker_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'maker_id': makerId,
    };
  }
}
