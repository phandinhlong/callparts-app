class OemCode {
  final int id;
  final int productId;
  final String from;
  final String oemCode;

  OemCode({
    required this.id,
    required this.productId,
    required this.from,
    required this.oemCode,
  });

  factory OemCode.fromJson(Map<String, dynamic> json) {
    return OemCode(
      id: json['id'],
      productId: json['product_id'],
      from: json['from'],
      oemCode: json['OEM_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'from': from,
      'OEM_code': oemCode,
    };
  }
}
