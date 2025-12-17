class AfterMarketCode {
  final int id;
  final int productId;
  final String from;
  final String afterMarketCode;

  AfterMarketCode({
    required this.id,
    required this.productId,
    required this.from,
    required this.afterMarketCode,
  });

  factory AfterMarketCode.fromJson(Map<String, dynamic> json) {
    return AfterMarketCode(
      id: json['id'],
      productId: json['product_id'],
      from: json['from'],
      afterMarketCode: json['after_market_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'from': from,
      'after_market_code': afterMarketCode,
    };
  }
}
