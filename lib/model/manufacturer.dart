class Manufacturer {
  final int id;
  final String manufacturerName;
  final String slug;
  final String? description;
  final String? link;
  final String? logo;
  final bool isShowHome;

  Manufacturer({
    required this.id,
    required this.manufacturerName,
    required this.slug,
    this.description,
    this.link,
    this.logo,
    required this.isShowHome,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['id'],
      manufacturerName: json['manufacturer_name'],
      slug: json['slug'],
      description: json['description'],
      link: json['link'],
      logo: json['logo'],
      isShowHome: json['is_show_home'] == 1 || json['is_show_home'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'manufacturer_name': manufacturerName,
      'slug': slug,
      'description': description,
      'link': link,
      'logo': logo,
      'is_show_home': isShowHome,
    };
  }
}
