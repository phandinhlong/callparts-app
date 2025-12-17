import 'order.dart'; // Placeholder, will be fully converted later
import 'cp_user.dart'; // Assuming App\Models\User maps to CPUser

class DeliveryHistory {
  final int id;
  final int orderId;
  final String? transport;
  final String? code;
  final String? status;
  final String? data;
  final String? data1;
  final int? userId;
  final Order? order;
  final CPUser? user;

  DeliveryHistory({
    required this.id,
    required this.orderId,
    this.transport,
    this.code,
    this.status,
    this.data,
    this.data1,
    this.userId,
    this.order,
    this.user,
  });

  factory DeliveryHistory.fromJson(Map<String, dynamic> json) {
    return DeliveryHistory(
      id: json['id'],
      orderId: json['order_id'],
      transport: json['transport'],
      code: json['code'],
      status: json['status'],
      data: json['data'],
      data1: json['data1'],
      userId: json['user_id'],
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
      user: json['user'] != null ? CPUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'transport': transport,
      'code': code,
      'status': status,
      'data': data,
      'data1': data1,
      'user_id': userId,
      'order': order?.toJson(),
      'user': user?.toJson(),
    };
  }
}
