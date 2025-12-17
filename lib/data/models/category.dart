class Category {
  final int id;
  final String categoryName;
  final String? categoryNameEn;
  final String slug;
  final int? parentId;
  final String? description;
  final String? image;
  final int? order;
  final String? sizeTemplate;
  final String? sizeTemplateEn;
  final String? metaTitle;
  final String? metaTitleEn;
  final String? metaDescription;
  final String? metaDescriptionVn;
  final List<Category> children;

  Category({
    required this.id,
    required this.categoryName,
    this.categoryNameEn,
    required this.slug,
    this.parentId,
    this.description,
    this.image,
    this.order,
    this.sizeTemplate,
    this.sizeTemplateEn,
    this.metaTitle,
    this.metaTitleEn,
    this.metaDescription,
    this.metaDescriptionVn,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      categoryNameEn: json['category_name_en'],
      slug: json['slug'],
      parentId: json['parent_id'],
      description: json['description'],
      image: json['image'],
      order: json['order'],
      sizeTemplate: json['size_template'],
      sizeTemplateEn: json['size_template_en'],
      metaTitle: json['meta_title'],
      metaTitleEn: json['meta_title_en'],
      metaDescription: json['meta_description'],
      metaDescriptionVn: json['meta_description_vn'],
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
      'category_name_en': categoryNameEn,
      'slug': slug,
      'parent_id': parentId,
      'description': description,
      'image': image,
      'order': order,
      'size_template': sizeTemplate,
      'size_template_en': sizeTemplateEn,
      'meta_title': metaTitle,
      'meta_title_en': metaTitleEn,
      'meta_description': metaDescription,
      'meta_description_vn': metaDescriptionVn,
      'children': children.map((i) => i.toJson()).toList(),
    };
  }
}
