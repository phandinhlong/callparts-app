import 'car_class.dart';

class Maker {
  final int id;
  final String makerName;
  final List<CarClass>? carClasses;

  Maker({
    required this.id,
    required this.makerName,
    this.carClasses,
  });

  factory Maker.fromJson(Map<String, dynamic> json) {
    List<CarClass>? carClassesList;
    if (json['car_classes'] != null) {
      carClassesList = (json['car_classes'] as List)
          .map((carClassJson) => CarClass.fromJson(carClassJson))
          .toList();
    }

    return Maker(
      id: json['id'],
      makerName: json['maker_name'],
      carClasses: carClassesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maker_name': makerName,
      if (carClasses != null)
        'car_classes': carClasses!.map((cc) => cc.toJson()).toList(),
    };
  }
}
