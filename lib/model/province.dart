class Province {
  final int id;
  final String provinceName;

  Province({
    required this.id,
    required this.provinceName,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      provinceName: json['province_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'province_name': provinceName,
    };
  }
}
