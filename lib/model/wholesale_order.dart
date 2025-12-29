import 'cp_user.dart';
import 'wholesale_order_item.dart'; // Placeholder, will be fully converted later

class WholesaleOrder {
  final int id;
  final int userId;
  final String customerName;
  final String phone;
  final String shippingAddress;
  final String status;
  final double totalAmount;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CPUser? user;
  final List<WholesaleOrderItem> items;

  WholesaleOrder({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.phone,
    required this.shippingAddress,
    required this.status,
    required this.totalAmount,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    required this.items,
  });

  factory WholesaleOrder.fromJson(Map<String, dynamic> json) {
    return WholesaleOrder(
      id: json['id'],
      userId: json['user_id'],
      customerName: json['customer_name'],
      phone: json['phone'],
      shippingAddress: json['shipping_address'],
      status: json['status'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? CPUser.fromJson(json['user']) : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => WholesaleOrderItem.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'customer_name': customerName,
      'phone': phone,
      'shipping_address': shippingAddress,
      'status': status,
      'total_amount': totalAmount,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
