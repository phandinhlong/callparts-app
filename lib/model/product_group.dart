import 'product.dart';

class ProductGroup {
  final int id;
  final String groupName;
  final List<Product> products;

  ProductGroup({
    required this.id,
    required this.groupName,
    required this.products,
  });

  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    return ProductGroup(
      id: json['id'],
      groupName: json['group_name'],
      products: json['products'] != null
          ? (json['products'] as List).map((i) => Product.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': groupName,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}
