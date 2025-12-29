class Category {
  final int id;
  final String categoryName;
  final String slug;
  final int? parentId;
  final String? image;
  final int? order;
  final List<Category> children;

  Category({
    required this.id,
    required this.categoryName,
    required this.slug,
    this.parentId,
    this.image,
    this.order,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      slug: json['slug'],
      parentId: json['parent_id'],
      image: json['image'],
      order: json['order'],
      children: json['children'] != null
          ? (json['children'] as List)
              .map((i) => Category.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
      'slug': slug,
      'parent_id': parentId,
      'image': image,
      'order': order,
      'children': children.map((i) => i.toJson()).toList(),
    };
  }
}
