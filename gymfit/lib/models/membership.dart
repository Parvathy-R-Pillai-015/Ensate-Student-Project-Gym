class MembershipPlan {
  final int id;
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final List<String> benefits;
  final bool isActive;
  final DateTime? createdAt;
  
  MembershipPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.benefits,
    this.isActive = true,
    this.createdAt,
  });
  
  String get durationType {
    if (durationDays == 30) return '1 Month';
    if (durationDays == 90) return '3 Months';
    if (durationDays == 180) return '6 Months';
    if (durationDays == 365) return '1 Year';
    return '$durationDays Days';
  }
  
  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      durationDays: json['duration_days'] ?? 0,
      benefits: List<String>.from(json['benefits'] ?? []),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'benefits': benefits,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class Membership {
  final int id;
  final int userId;
  final MembershipPlan plan;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? qrCode;
  final DateTime? createdAt;
  
  Membership({
    required this.id,
    required this.userId,
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.qrCode,
    this.createdAt,
  });
  
  bool get isActive => status == 'ACTIVE' && endDate.isAfter(DateTime.now());
  bool get isExpired => status == 'EXPIRED' || endDate.isBefore(DateTime.now());
  
  int get daysRemaining {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }
  
  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      plan: MembershipPlan.fromJson(json['plan'] ?? {}),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'] ?? 'ACTIVE',
      qrCode: json['qr_code'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan': plan.toJson(),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'qr_code': qrCode,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
