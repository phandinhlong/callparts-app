class CarModel {
  final int id;
  final int makerId;
  final int carClassId;
  final String modelName;
  final String? type;
  final String? bodyCodes;

  CarModel({
    required this.id,
    required this.makerId,
    required this.carClassId,
    required this.modelName,
    this.type,
    this.bodyCodes,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      makerId: json['maker_id'],
      carClassId: json['car_class_id'],
      modelName: json['model_name'],
      type: json['type'],
      bodyCodes: json['body_codes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maker_id': makerId,
      'car_class_id': carClassId,
      'model_name': modelName,
      'type': type,
      'body_codes': bodyCodes,
    };
  }
}
