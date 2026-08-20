enum AttendanceDayStatus { present, absent, holiday, halfDay }

class AttendanceDayRecord {
  final DateTime date;
  final AttendanceDayStatus status;
  final String? remarks;

  const AttendanceDayRecord({
    required this.date,
    required this.status,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status.name,
      'remarks': remarks,
    };
  }

  factory AttendanceDayRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceDayRecord(
      date: DateTime.parse(json['date'] as String),
      status: AttendanceDayStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AttendanceDayStatus.present,
      ),
      remarks: json['remarks'] as String?,
    );
  }
}

class SubjectAttendanceModel {
  final String subjectName;
  final int totalClasses;
  final int attendedClasses;

  const SubjectAttendanceModel({
    required this.subjectName,
    required this.totalClasses,
    required this.attendedClasses,
  });

  double get percentage => totalClasses > 0 ? (attendedClasses / totalClasses) * 100 : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
    };
  }

  factory SubjectAttendanceModel.fromJson(Map<String, dynamic> json) {
    return SubjectAttendanceModel(
      subjectName: json['subjectName'] as String,
      totalClasses: json['totalClasses'] as int,
      attendedClasses: json['attendedClasses'] as int,
    );
  }
}

class AttendanceSummaryModel {
  final int totalWorkingDays;
  final int presentDays;
  final int absentDays;
  final int holidays;
  final List<AttendanceDayRecord> dailyRecords;
  final List<SubjectAttendanceModel> subjectAttendance;

  const AttendanceSummaryModel({
    required this.totalWorkingDays,
    required this.presentDays,
    required this.absentDays,
    required this.holidays,
    required this.dailyRecords,
    required this.subjectAttendance,
  });

  double get overallPercentage =>
      totalWorkingDays > 0 ? (presentDays / totalWorkingDays) * 100 : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'totalWorkingDays': totalWorkingDays,
      'presentDays': presentDays,
      'absentDays': absentDays,
      'holidays': holidays,
      'dailyRecords': dailyRecords.map((e) => e.toJson()).toList(),
      'subjectAttendance': subjectAttendance.map((e) => e.toJson()).toList(),
    };
  }

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalWorkingDays: json['totalWorkingDays'] as int,
      presentDays: json['presentDays'] as int,
      absentDays: json['absentDays'] as int,
      holidays: json['holidays'] as int,
      dailyRecords: (json['dailyRecords'] as List<dynamic>)
          .map((e) => AttendanceDayRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      subjectAttendance: (json['subjectAttendance'] as List<dynamic>)
          .map((e) => SubjectAttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
