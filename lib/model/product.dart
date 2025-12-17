import 'dart:convert';
import 'manufacturer.dart';

class Product {
  final int id;
  final int manufacturerId;
  final int categoryId;
  final String productName;
  final String? pCode;
  final String? sku;
  final int stock;
  final double price;
  final double? discountPrice;
  final String slug;
  final String? description;
  final String? descriptionEn;
  final String? specifications;
  final String? specificationsEn;
  final String? uses;
  final String? usesEn;
  final List<String> images;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final String? qrCode;
  final String? oemCode;
  final String? afterMarketCode;
  final int? numberOfViewed;
  final String? docs;
  final bool active;
  final bool isShowHome;
  final String? shoppeLink;
  final Manufacturer? manufacturer;

  Product({
    required this.id,
    required this.manufacturerId,
    required this.categoryId,
    required this.productName,
    this.pCode,
    this.sku,
    required this.stock,
    required this.price,
    this.discountPrice,
    required this.slug,
    this.description,
    this.descriptionEn,
    this.specifications,
    this.specificationsEn,
    this.uses,
    this.usesEn,
    required this.images,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.qrCode,
    this.oemCode,
    this.afterMarketCode,
    this.numberOfViewed,
    this.docs,
    required this.active,
    required this.isShowHome,
    this.shoppeLink,
    this.manufacturer,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      manufacturerId: json['manufacturer_id'],
      categoryId: json['category_id'],
      productName: json['product_name'],
      pCode: json['p_code'],
      sku: json['sku'],
      stock: json['stock'],
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discount_price'] != null ? (json['discount_price'] as num).toDouble() : null,
      slug: json['slug'],
      description: json['description'],
      descriptionEn: json['description_en'],
      specifications: json['specifications'],
      specificationsEn: json['specifications_en'],
      uses: json['uses'],
      usesEn: json['uses_en'],
      images: json['images'] != null ? List<String>.from(jsonDecode(json['images'])) : [],
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      length: json['length'] != null ? (json['length'] as num).toDouble() : null,
      width: json['width'] != null ? (json['width'] as num).toDouble() : null,
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      qrCode: json['qr_code'],
      oemCode: json['oem_code'],
      afterMarketCode: json['after_market_code'],
      numberOfViewed: json['number_of_viewed'],
      docs: json['docs'],
      active: json['active'] == 1 || json['active'] == true,
      isShowHome: json['is_show_home'] == 1 || json['is_show_home'] == true,
      shoppeLink: json['shoppe_link'],
      manufacturer: json['manufacturer'] != null ? Manufacturer.fromJson(json['manufacturer']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'manufacturer_id': manufacturerId,
      'category_id': categoryId,
      'product_name': productName,
      'p_code': pCode,
      'sku': sku,
      'stock': stock,
      'price': price,
      'discount_price': discountPrice,
      'slug': slug,
      'description': description,
      'description_en': descriptionEn,
      'specifications': specifications,
      'specifications_en': specificationsEn,
      'uses': uses,
      'uses_en': usesEn,
      'images': images,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'qr_code': qrCode,
      'oem_code': oemCode,
      'after_market_code': afterMarketCode,
      'number_of_viewed': numberOfViewed,
      'docs': docs,
      'active': active,
      'is_show_home': isShowHome,
      'shoppe_link': shoppeLink,
      'manufacturer': manufacturer?.toJson(),
    };
  }
}
