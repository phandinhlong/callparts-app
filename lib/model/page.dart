class Page {
  final int id;
  final String slug;
  final String pageName;
  final String? pageNameEn;
  final String? description;
  final String? descriptionEn;
  final String? content;
  final String? contentEn;
  final bool isShowHome;
  final bool active;
  final String? image;

  Page({
    required this.id,
    required this.slug,
    required this.pageName,
    this.pageNameEn,
    this.description,
    this.descriptionEn,
    this.content,
    this.contentEn,
    required this.isShowHome,
    required this.active,
    this.image,
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      id: json['id'],
      slug: json['slug'],
      pageName: json['page_name'],
      pageNameEn: json['page_name_en'],
      description: json['description'],
      descriptionEn: json['description_en'],
      content: json['content'],
      contentEn: json['content_en'],
      isShowHome: json['is_show_home'] == 1 || json['is_show_home'] == true,
      active: json['active'] == 1 || json['active'] == true,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'page_name': pageName,
      'page_name_en': pageNameEn,
      'description': description,
      'description_en': descriptionEn,
      'content': content,
      'content_en': contentEn,
      'is_show_home': isShowHome,
      'active': active,
      'image': image,
    };
  }
}
