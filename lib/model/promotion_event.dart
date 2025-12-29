class PromotionEvent {
  final int id;
  final String title;
  final String slug;
  final String discountType;
  final double discountValue;
  final String? targetType;
  final int? targetId;
  final String status;
  final String? link;
  final String? image;
  final String? description;
  final bool isShowHome;
  final DateTime? startDate;
  final DateTime? endDate;

  PromotionEvent({
    required this.id,
    required this.title,
    required this.slug,
    required this.discountType,
    required this.discountValue,
    this.targetType,
    this.targetId,
    required this.status,
    this.link,
    this.image,
    this.description,
    required this.isShowHome,
    this.startDate,
    this.endDate,
  });

  factory PromotionEvent.fromJson(Map<String, dynamic> json) {
    return PromotionEvent(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      discountType: json['discount_type'],
      discountValue: (json['discount_value'] as num).toDouble(),
      targetType: json['target_type'],
      targetId: json['target_id'],
      status: json['status'],
      link: json['link'],
      image: json['image'],
      description: json['description'],
      isShowHome: json['is_show_home'] == 1 || json['is_show_home'] == true,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'discount_type': discountType,
      'discount_value': discountValue,
      'target_type': targetType,
      'target_id': targetId,
      'status': status,
      'link': link,
      'image': image,
      'description': description,
      'is_show_home': isShowHome,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}
