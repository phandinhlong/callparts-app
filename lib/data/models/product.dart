class Product {
  final int id;
  final int manufacturerId;
  final int categoryId;

  final String productName;
  final String pCode;

  final int stock;
  final double price;
  final double? discountPrice;

  final String slug;
  final List<String> images;

  final bool active;
  final bool isShowHome;

  final String? description;
  final String? specifications;
  final String? uses;
  final String? afterMarketCode;
  final String? oemCode;
  final String? shortLink;

  final int? numberOfViewed;

  Product({
    required this.id,
    required this.manufacturerId,
    required this.categoryId,
    required this.productName,
    required this.pCode,
    required this.stock,
    required this.price,
    this.discountPrice,
    required this.slug,
    required this.images,
    required this.active,
    required this.isShowHome,
    this.description,
    this.specifications,
    this.uses,
    this.afterMarketCode,
    this.oemCode,
    this.shortLink,
    this.numberOfViewed,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      manufacturerId: json['manufacturerId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      pCode: json['pCode'],
      stock: json['stock'],
      price: json['price'].toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      slug: json['slug'],
      images: List<String>.from(json['list_img']),
      active: json['active'] == 1,
      isShowHome: json['isShowHome'] == 1,
      description: json['description'],
      specifications: json['specifications'],
      uses: json['uses'],
      afterMarketCode: json['afterMarketCode'],
      oemCode: json['oemCode'],
      shortLink: json['shortLink'],
      numberOfViewed: json['numberOfViewed'],
    );
  }
}
