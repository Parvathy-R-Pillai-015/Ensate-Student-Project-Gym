class GymClass {
  final int id;
  final String name;
  final String type;
  final String? description;
  final int trainerId;
  final String? trainerName;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;
  final int enrolled;
  final String? imageUrl;
  final DateTime? createdAt;
  
  GymClass({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.trainerId,
    this.trainerName,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    this.enrolled = 0,
    this.imageUrl,
    this.createdAt,
  });
  
  bool get isFull => enrolled >= capacity;
  int get availableSlots => capacity - enrolled;
  
  int get durationMinutes => endTime.difference(startTime).inMinutes;
  
  factory GymClass.fromJson(Map<String, dynamic> json) {
    return GymClass(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'],
      trainerId: json['trainer_id'] ?? 0,
      trainerName: json['trainer_name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      capacity: json['capacity'] ?? 0,
      enrolled: json['enrolled'] ?? 0,
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'trainer_id': trainerId,
      'trainer_name': trainerName,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'capacity': capacity,
      'enrolled': enrolled,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class ClassBooking {
  final int id;
  final int userId;
  final int classId;
  final GymClass? classInfo;
  final String status;
  final DateTime bookedAt;
  
  ClassBooking({
    required this.id,
    required this.userId,
    required this.classId,
    this.classInfo,
    this.status = 'CONFIRMED',
    required this.bookedAt,
  });
  
  factory ClassBooking.fromJson(Map<String, dynamic> json) {
    return ClassBooking(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      classId: json['class_id'] ?? 0,
      classInfo: json['class_info'] != null 
          ? GymClass.fromJson(json['class_info']) 
          : null,
      status: json['status'] ?? 'CONFIRMED',
      bookedAt: json['booked_at'] != null 
          ? DateTime.parse(json['booked_at']) 
          : DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'class_id': classId,
      'class_info': classInfo?.toJson(),
      'status': status,
      'booked_at': bookedAt.toIso8601String(),
    };
  }
}
