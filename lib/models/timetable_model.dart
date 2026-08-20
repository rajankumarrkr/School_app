class TimetableSlotModel {
  final String id;
  final String subject;
  final String teacherName;
  final String startTime;
  final String endTime;
  final String roomNumber;
  final String dayOfWeek; // 'Monday', 'Tuesday', ...
  final String iconType; // 'math', 'physics', 'english', 'computer', etc.
  final bool isBreak;

  const TimetableSlotModel({
    required this.id,
    required this.subject,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    required this.dayOfWeek,
    required this.iconType,
    this.isBreak = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'teacherName': teacherName,
      'startTime': startTime,
      'endTime': endTime,
      'roomNumber': roomNumber,
      'dayOfWeek': dayOfWeek,
      'iconType': iconType,
      'isBreak': isBreak,
    };
  }

  factory TimetableSlotModel.fromJson(Map<String, dynamic> json) {
    return TimetableSlotModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      teacherName: json['teacherName'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      roomNumber: json['roomNumber'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      iconType: json['iconType'] as String? ?? 'general',
      isBreak: json['isBreak'] as bool? ?? false,
    );
  }
}
