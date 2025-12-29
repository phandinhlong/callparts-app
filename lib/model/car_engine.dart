class CarEngine {
  final int id;
  final int makerId;
  final int carClassId;
  final int carModelId;
  final String engineVolume;
  final String? engineNumber;
  final String? image;
  final String? kwHp;
  final String? ccm;
  final String? fuelType;
  final String? productionStart;
  final String? productionEnd;
  final String? bodyCode;
  final String? gear;
  final String? capacity;
  final String? driveSystem;

  CarEngine({
    required this.id,
    required this.makerId,
    required this.carClassId,
    required this.carModelId,
    required this.engineVolume,
    this.engineNumber,
    this.image,
    this.kwHp,
    this.ccm,
    this.fuelType,
    this.productionStart,
    this.productionEnd,
    this.bodyCode,
    this.gear,
    this.capacity,
    this.driveSystem,
  });

  factory CarEngine.fromJson(Map<String, dynamic> json) {
    return CarEngine(
      id: json['id'],
      makerId: json['maker_id'],
      carClassId: json['car_class_id'],
      carModelId: json['car_model_id'],
      engineVolume: json['engine_volume'],
      engineNumber: json['engine_number'],
      image: json['image'],
      kwHp: json['kw_hp'],
      ccm: json['ccm'],
      fuelType: json['fuel_type'],
      productionStart: json['production_start'],
      productionEnd: json['production_end'],
      bodyCode: json['body_code'],
      gear: json['gear'],
      capacity: json['capacity'],
      driveSystem: json['drive_system'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maker_id': makerId,
      'car_class_id': carClassId,
      'car_model_id': carModelId,
      'engine_volume': engineVolume,
      'engine_number': engineNumber,
      'image': image,
      'kw_hp': kwHp,
      'ccm': ccm,
      'fuel_type': fuelType,
      'production_start': productionStart,
      'production_end': productionEnd,
      'body_code': bodyCode,
      'gear': gear,
      'capacity': capacity,
      'drive_system': driveSystem,
    };
  }
}
