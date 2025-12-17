class GroupSize {
  final int id;
  final String sizeName;
  final String? content;

  GroupSize({
    required this.id,
    required this.sizeName,
    this.content,
  });

  factory GroupSize.fromJson(Map<String, dynamic> json) {
    return GroupSize(
      id: json['id'],
      sizeName: json['size_name'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size_name': sizeName,
      'content': content,
    };
  }
}
