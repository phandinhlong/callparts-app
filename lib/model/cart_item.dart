import 'package:callparts/model/product.dart';

class CartItem {
  final int productId;
  final Product? product; // Store product reference for easy access
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
    required this.productId,
    this.product,
    String? name,
    String? price,
    String? imagePath,
    String? brand,
    double? rating,
    this.quantity = 1,
    this.partNumber,
    this.oemCode,
    this.compatibility,
    this.selected = true,
  })  : name = name ?? product?.productName ?? '',
        price = price ?? product?.price.toString() ?? '0',
        imagePath = imagePath ?? (product?.images.isNotEmpty == true ? product!.images.first : ''),
        brand = brand ?? product?.manufacturer?.manufacturerName ?? '',
        rating = rating ?? 0.0;

  // Factory method to create CartItem from Product
  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      productId: product.id,
      product: product,
      quantity: quantity,
      partNumber: product.pCode,
      oemCode: product.oemCode,
      compatibility: null, // Can be set based on product category or other logic
      selected: true,
    );
  }

  // Factory method for backward compatibility
  factory CartItem.fromProductData(dynamic product, {int quantity = 1}) {
    if (product is Product) {
      return CartItem.fromProduct(product, quantity: quantity);
    }
    return CartItem(
      productId: 0,
      name: product.name ?? '',
      price: product.price ?? '',
      imagePath: product.imagePath ?? '',
      brand: product.brand ?? '',
      rating: product.rating ?? 0.0,
      quantity: quantity,
      selected: true,
    );
  }

  double get unitPrice {
    // Use discounted price if available, otherwise regular price
    if (product != null) {
      return product!.discountPrice ?? product!.price;
    }
    return double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    int? productId,
    Product? product,
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
      productId: productId ?? this.productId,
      product: product ?? this.product,
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
      'productId': productId,
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
      // Store minimal product data for persistence
      if (product != null) 'product': {
        'id': product!.id,
        'productName': product!.productName,
        'price': product!.price,
        'discountPrice': product!.discountPrice,
        'pCode': product!.pCode,
        'images': product!.images,
        'manufacturerId': product!.manufacturerId,
        'categoryId': product!.categoryId,
        'stock': product!.stock,
        'slug': product!.slug,
        'active': product!.active,
        'isShowHome': product!.isShowHome,
      },
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    Product? product;
    if (json['product'] != null) {
      final productData = json['product'];
      product = Product(
        id: productData['id'],
        productName: productData['productName'],
        price: productData['price'].toDouble(),
        discountPrice: productData['discountPrice']?.toDouble(),
        pCode: productData['pCode'],
        images: List<String>.from(productData['images']),
        manufacturerId: productData['manufacturerId'],
        categoryId: productData['categoryId'],
        stock: productData['stock'],
        slug: productData['slug'],
        active: productData['active'],
        isShowHome: productData['isShowHome'],
      );
    }

    return CartItem(
      productId: json['productId'] ?? 0,
      product: product,
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
