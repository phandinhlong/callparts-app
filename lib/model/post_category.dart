import 'post.dart';

class PostCategory {
  final int id;
  final String? nameEn;
  final String name;
  final String? contentEn;
  final String? content;
  final String slug;
  final List<Post> posts;

  PostCategory({
    required this.id,
    this.nameEn,
    required this.name,
    this.contentEn,
    this.content,
    required this.slug,
    required this.posts,
  });

  factory PostCategory.fromJson(Map<String, dynamic> json) {
    return PostCategory(
      id: json['id'],
      nameEn: json['name_en'],
      name: json['name'],
      contentEn: json['content_en'],
      content: json['content'],
      slug: json['slug'],
      posts: json['posts'] != null
          ? (json['posts'] as List).map((i) => Post.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name': name,
      'content_en': contentEn,
      'content': content,
      'slug': slug,
      'posts': posts.map((e) => e.toJson()).toList(),
    };
  }
}
