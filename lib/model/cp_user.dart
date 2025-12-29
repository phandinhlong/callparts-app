class CPUser {
  final int id;
  final String name;
  final String email;
  // Add other fields from App\Models\User as needed

  CPUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CPUser.fromJson(Map<String, dynamic> json) {
    return CPUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

// Placeholder for WholesaleOrder, will be fully converted later
class WholesaleOrder {
  final int id;
  // Add other fields as needed

  WholesaleOrder({
    required this.id,
  });

  factory WholesaleOrder.fromJson(Map<String, dynamic> json) {
    return WholesaleOrder(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
