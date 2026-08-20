class ExamSubjectSchedule {
  final String subjectName;
  final DateTime examDate;
  final String startTime;
  final String endTime;
  final String roomNumber;
  final int maxMarks;
  final String syllabus;

  const ExamSubjectSchedule({
    required this.subjectName,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    required this.maxMarks,
    required this.syllabus,
  });

  int get daysRemaining {
    final now = DateTime.now();
    final examDay = DateTime(examDate.year, examDate.month, examDate.day);
    final today = DateTime(now.year, now.month, now.day);
    return examDay.difference(today).inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'examDate': examDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'roomNumber': roomNumber,
      'maxMarks': maxMarks,
      'syllabus': syllabus,
    };
  }

  factory ExamSubjectSchedule.fromJson(Map<String, dynamic> json) {
    return ExamSubjectSchedule(
      subjectName: json['subjectName'] as String,
      examDate: DateTime.parse(json['examDate'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      roomNumber: json['roomNumber'] as String,
      maxMarks: json['maxMarks'] as int,
      syllabus: json['syllabus'] as String,
    );
  }
}

class ExamScheduleModel {
  final String id;
  final String examTitle; // e.g. "Unit Test 2 - 2026", "Half Yearly Exams"
  final String term;
  final DateTime startDate;
  final DateTime endDate;
  final List<ExamSubjectSchedule> schedules;
  final String instructions;

  const ExamScheduleModel({
    required this.id,
    required this.examTitle,
    required this.term,
    required this.startDate,
    required this.endDate,
    required this.schedules,
    required this.instructions,
  });

  int get daysUntilStart {
    final now = DateTime.now();
    final startDay = DateTime(startDate.year, startDate.month, startDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = startDay.difference(today).inDays;
    return diff < 0 ? 0 : diff;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examTitle': examTitle,
      'term': term,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'schedules': schedules.map((e) => e.toJson()).toList(),
      'instructions': instructions,
    };
  }

  factory ExamScheduleModel.fromJson(Map<String, dynamic> json) {
    return ExamScheduleModel(
      id: json['id'] as String,
      examTitle: json['examTitle'] as String,
      term: json['term'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => ExamSubjectSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      instructions: json['instructions'] as String,
    );
  }
}
