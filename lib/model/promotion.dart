class Promotion {
  final int id;
  final String promotionName;
  final String code;
  final double? minLimit;
  final String type;
  final double discount;
  final int? quantity;
  final bool public;
  final String slug;
  final bool active;

  Promotion({
    required this.id,
    required this.promotionName,
    required this.code,
    this.minLimit,
    required this.type,
    required this.discount,
    this.quantity,
    required this.public,
    required this.slug,
    required this.active,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      promotionName: json['promotion_name'],
      code: json['code'],
      minLimit: (json['min_limit'] as num?)?.toDouble(),
      type: json['type'],
      discount: (json['discount'] as num).toDouble(),
      quantity: json['quantity'],
      public: json['public'] == 1 || json['public'] == true,
      slug: json['slug'],
      active: json['active'] == 1 || json['active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promotion_name': promotionName,
      'code': code,
      'min_limit': minLimit,
      'type': type,
      'discount': discount,
      'quantity': quantity,
      'public': public,
      'slug': slug,
      'active': active,
    };
  }
}
