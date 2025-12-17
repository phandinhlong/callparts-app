class Maker {
  final int id;
  final String makerName;

  Maker({
    required this.id,
    required this.makerName,
  });

  factory Maker.fromJson(Map<String, dynamic> json) {
    return Maker(
      id: json['id'],
      makerName: json['maker_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maker_name': makerName,
    };
  }
}
