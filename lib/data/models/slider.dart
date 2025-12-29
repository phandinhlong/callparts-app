class Slider {
  final int id;
  final String? title;
  final int? order;
  final String? image;
  final bool active;

  Slider({
    required this.id,
    this.title,
    this.order,
    this.image,
    required this.active,
  });

  factory Slider.fromJson(Map<String, dynamic> json) {
    return Slider(
      id: json['id'],
      title: json['title'],
      order: json['order'],
      image: json['image'],
      active: json['active'] == 1 || json['active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'order': order,
      'image': image,
      'active': active,
    };
  }
}
