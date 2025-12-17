import 'district.dart'; // Placeholder
import 'province.dart';

class Ward {
  final int id;
  final String wardCode;
  final String wardName;
  final int provinceId;
  final int districtId;
  final District? district;
  final Province? province;

  Ward({
    required this.id,
    required this.wardCode,
    required this.wardName,
    required this.provinceId,
    required this.districtId,
    this.district,
    this.province,
  });

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['id'],
      wardCode: json['ward_code'],
      wardName: json['ward_name'],
      provinceId: json['province_id'],
      districtId: json['district_id'],
      district: json['district'] != null ? District.fromJson(json['district']) : null,
      province: json['province'] != null ? Province.fromJson(json['province']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ward_code': wardCode,
      'ward_name': wardName,
      'province_id': provinceId,
      'district_id': districtId,
      'district': district?.toJson(),
      'province': province?.toJson(),
    };
  }
}
