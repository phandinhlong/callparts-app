import 'order.dart';

class Transaction {
  final int id;
  final int orderId;
  final String type;
  final String status;
  final String? data;
  final Order? order;

  Transaction({
    required this.id,
    required this.orderId,
    required this.type,
    required this.status,
    this.data,
    this.order,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      orderId: json['order_id'],
      type: json['type'],
      status: json['status'],
      data: json['data'],
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'type': type,
      'status': status,
      'data': data,
      'order': order?.toJson(),
    };
  }
}
