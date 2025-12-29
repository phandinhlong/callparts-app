class District {
  final int id;
  final int provinceId;
  final String code;
  final String districtName;
  final String? supportType;
  final String? type;

  District({
    required this.id,
    required this.provinceId,
    required this.code,
    required this.districtName,
    this.supportType,
    this.type,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      provinceId: json['province_id'],
      code: json['code'],
      districtName: json['district_name'],
      supportType: json['support_type'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'province_id': provinceId,
      'code': code,
      'district_name': districtName,
      'support_type': supportType,
      'type': type,
    };
  }
}
