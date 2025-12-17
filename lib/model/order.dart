import 'cp_user.dart';
import 'order_detail.dart'; // Placeholder
import 'transaction.dart'; // Placeholder
import 'province.dart'; // Placeholder
import 'ward.dart'; // Placeholder
import 'district.dart'; // Placeholder
import 'delivery_history.dart';

class Order {
  final int id;
  final String code;
  final int? userId;
  final String status;
  final String? message;
  final String? customerInfo;
  final String? address;
  final int? provinceId;
  final int? districtId;
  final int? wardId;
  final double? taxFee;
  final double? shippingFee;
  final double? shippingFeeReal;
  final int? shippingServiceId;
  final String? shipCode;
  final double? discount;
  final double? subTotal;
  final double? total;
  final double? weight;
  final double? length;
  final double? width;
  final double? height;
  final String? transport;
  final CPUser? user;
  final List<OrderDetail> orderDetail;
  final Transaction? transaction;
  final Province? province;
  final Ward? ward;
  final District? district;
  final List<DeliveryHistory> deliveryHistory;

  Order({
    required this.id,
    required this.code,
    this.userId,
    required this.status,
    this.message,
    this.customerInfo,
    this.address,
    this.provinceId,
    this.districtId,
    this.wardId,
    this.taxFee,
    this.shippingFee,
    this.shippingFeeReal,
    this.shippingServiceId,
    this.shipCode,
    this.discount,
    this.subTotal,
    this.total,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.transport,
    this.user,
    required this.orderDetail,
    this.transaction,
    this.province,
    this.ward,
    this.district,
    required this.deliveryHistory,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      code: json['code'],
      userId: json['user_id'],
      status: json['status'],
      message: json['message'],
      customerInfo: json['customer_info'],
      address: json['address'],
      provinceId: json['province_id'],
      districtId: json['district_id'],
      wardId: json['ward_id'],
      taxFee: (json['tax_fee'] as num?)?.toDouble(),
      shippingFee: (json['shipping_fee'] as num?)?.toDouble(),
      shippingFeeReal: (json['shipping_fee_real'] as num?)?.toDouble(),
      shippingServiceId: json['shipping_service_id'],
      shipCode: json['ship_code'],
      discount: (json['discount'] as num?)?.toDouble(),
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      transport: json['transport'],
      user: json['user'] != null ? CPUser.fromJson(json['user']) : null,
      orderDetail: json['orderDetail'] != null
          ? (json['orderDetail'] as List)
              .map((i) => OrderDetail.fromJson(i))
              .toList()
          : [],
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
      province: json['province'] != null
          ? Province.fromJson(json['province'])
          : null,
      ward: json['ward'] != null ? Ward.fromJson(json['ward']) : null,
      district: json['district'] != null
          ? District.fromJson(json['district'])
          : null,
      deliveryHistory: json['deliveryHistory'] != null
          ? (json['deliveryHistory'] as List)
              .map((i) => DeliveryHistory.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'user_id': userId,
      'status': status,
      'message': message,
      'customer_info': customerInfo,
      'address': address,
      'province_id': provinceId,
      'district_id': districtId,
      'ward_id': wardId,
      'tax_fee': taxFee,
      'shipping_fee': shippingFee,
      'shipping_fee_real': shippingFeeReal,
      'shipping_service_id': shippingServiceId,
      'ship_code': shipCode,
      'discount': discount,
      'sub_total': subTotal,
      'total': total,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'transport': transport,
      'user': user?.toJson(),
      'orderDetail': orderDetail.map((e) => e.toJson()).toList(),
      'transaction': transaction?.toJson(),
      'province': province?.toJson(),
      'ward': ward?.toJson(),
      'district': district?.toJson(),
      'deliveryHistory': deliveryHistory.map((e) => e.toJson()).toList(),
    };
  }
}
