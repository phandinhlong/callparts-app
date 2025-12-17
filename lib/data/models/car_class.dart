class CarClass {
  final int id;
  final int makerId;
  final String className;
  final String? shortClassName;

  CarClass({
    required this.id,
    required this.makerId,
    required this.className,
    this.shortClassName,
  });

  factory CarClass.fromJson(Map<String, dynamic> json) {
    return CarClass(
      id: json['id'],
      makerId: json['maker_id'],
      className: json['class_name'],
      shortClassName: json['short_class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maker_id': makerId,
      'class_name': className,
      'short_class_name': shortClassName,
    };
  }
}
