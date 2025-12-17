import 'post_category.dart'; // Placeholder

class Post {
  final int id;
  final int postCategoryId;
  final String? titleEn;
  final String title;
  final String? image;
  final String? metaTitle;
  final String? metaTitleEn;
  final String? shortDescription;
  final String? shortDescriptionEn;
  final String? content;
  final String? contentEn;
  final bool active;
  final String slug;
  final PostCategory? postCategory;

  Post({
    required this.id,
    required this.postCategoryId,
    this.titleEn,
    required this.title,
    this.image,
    this.metaTitle,
    this.metaTitleEn,
    this.shortDescription,
    this.shortDescriptionEn,
    this.content,
    this.contentEn,
    required this.active,
    required this.slug,
    this.postCategory,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      postCategoryId: json['post_category_id'],
      titleEn: json['title_en'],
      title: json['title'],
      image: json['image'],
      metaTitle: json['meta_title'],
      metaTitleEn: json['meta_title_en'],
      shortDescription: json['short_description'],
      shortDescriptionEn: json['short_description_en'],
      content: json['content'],
      contentEn: json['content_en'],
      active: json['active'] == 1 || json['active'] == true,
      slug: json['slug'],
      postCategory: json['postCategory'] != null
          ? PostCategory.fromJson(json['postCategory'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_category_id': postCategoryId,
      'title_en': titleEn,
      'title': title,
      'image': image,
      'meta_title': metaTitle,
      'meta_title_en': metaTitleEn,
      'short_description': shortDescription,
      'short_description_en': shortDescriptionEn,
      'content': content,
      'content_en': contentEn,
      'active': active,
      'slug': slug,
      'postCategory': postCategory?.toJson(),
    };
  }
}
