class CartItem {
  final String name;
  final String price;
  final String imagePath;
  final String brand;
  final double rating;
  int quantity;
  final String? partNumber;
  final String? oemCode;
  final String? compatibility;
  final bool selected;

  CartItem({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.brand,
    required this.rating,
    this.quantity = 1,
    this.partNumber,
    this.oemCode,
    this.compatibility,
    this.selected = true,
  });

  // Factory method to create CartItem from product data
  factory CartItem.fromProductData(dynamic product, {int quantity = 1}) {
    return CartItem(
      name: product.name ?? '',
      price: product.price ?? '',
      imagePath: product.imagePath ?? '',
      brand: product.brand ?? '',
      rating: product.rating ?? 0.0,
      quantity: quantity,
      partNumber: null, // Will be set by product if available
      oemCode: null, // Will be set by product if available
      compatibility: null, // Will be set by product if available
      selected: true,
    );
  }

  double get unitPrice {
    return double.tryParse(price.replaceAll('\$', '').replaceAll(' VND', '').replaceAll(',', '')) ?? 0.0;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? name,
    String? price,
    String? imagePath,
    String? brand,
    double? rating,
    int? quantity,
    String? partNumber,
    String? oemCode,
    String? compatibility,
    bool? selected,
  }) {
    return CartItem(
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      quantity: quantity ?? this.quantity,
      partNumber: partNumber ?? this.partNumber,
      oemCode: oemCode ?? this.oemCode,
      compatibility: compatibility ?? this.compatibility,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imagePath': imagePath,
      'brand': brand,
      'rating': rating,
      'quantity': quantity,
      'partNumber': partNumber,
      'oemCode': oemCode,
      'compatibility': compatibility,
      'selected': selected,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      imagePath: json['imagePath'] ?? '',
      brand: json['brand'] ?? '',
      rating: json['rating'] ?? 0.0,
      quantity: json['quantity'] ?? 1,
      partNumber: json['partNumber'],
      oemCode: json['oemCode'],
      compatibility: json['compatibility'],
      selected: json['selected'] ?? true,
    );
  }
}
