class Progress {
  final int? id;
  final int userId;
  final double weight;
  final double? bodyFat;
  final double? muscleMass;
  final Map<String, double>? measurements;
  final String? notes;
  final DateTime date;
  final List<String>? photoUrls;
  
  Progress({
    this.id,
    required this.userId,
    required this.weight,
    this.bodyFat,
    this.muscleMass,
    this.measurements,
    this.notes,
    required this.date,
    this.photoUrls,
  });
  
  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      bodyFat: json['body_fat']?.toDouble(),
      muscleMass: json['muscle_mass']?.toDouble(),
      measurements: json['measurements'] != null 
          ? Map<String, double>.from(json['measurements']) 
          : null,
      notes: json['notes'],
      date: DateTime.parse(json['date']),
      photoUrls: json['photo_urls'] != null 
          ? List<String>.from(json['photo_urls']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      'body_fat': bodyFat,
      'muscle_mass': muscleMass,
      'measurements': measurements,
      'notes': notes,
      'date': date.toIso8601String(),
      'photo_urls': photoUrls,
    };
  }
}

class Goal {
  final int? id;
  final int userId;
  final String type;
  final String description;
  final double? targetWeight;
  final double? targetBodyFat;
  final DateTime? targetDate;
  final String status;
  final DateTime createdAt;
  
  Goal({
    this.id,
    required this.userId,
    required this.type,
    required this.description,
    this.targetWeight,
    this.targetBodyFat,
    this.targetDate,
    this.status = 'ACTIVE',
    required this.createdAt,
  });
  
  bool get isCompleted => status == 'COMPLETED';
  bool get isActive => status == 'ACTIVE';
  
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      targetWeight: json['target_weight']?.toDouble(),
      targetBodyFat: json['target_body_fat']?.toDouble(),
      targetDate: json['target_date'] != null 
          ? DateTime.parse(json['target_date']) 
          : null,
      status: json['status'] ?? 'ACTIVE',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'description': description,
      'target_weight': targetWeight,
      'target_body_fat': targetBodyFat,
      'target_date': targetDate?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
