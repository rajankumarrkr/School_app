enum UserRole {
  student,
  teacher,
  admin,
}

class TeacherModel {
  final String id;
  final String employeeId;
  final String fullName;
  final String designation;
  final String department;
  final String primarySubject;
  final String classTeacherOf; // e.g. "10-A"
  final String email;
  final String phone;
  final String qualification;
  final String experience;
  final String avatarUrl;
  final List<String> assignedClasses;
  final List<String> subjectsTaught;

  const TeacherModel({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.designation,
    required this.department,
    required this.primarySubject,
    required this.classTeacherOf,
    required this.email,
    required this.phone,
    required this.qualification,
    required this.experience,
    required this.avatarUrl,
    required this.assignedClasses,
    required this.subjectsTaught,
  });
}

class AdminModel {
  final String id;
  final String adminId;
  final String fullName;
  final String designation; // e.g. "Principal & Head of School", "Chief Administrator"
  final String email;
  final String phone;
  final String avatarUrl;
  final String schoolAffiliationNo;
  final String academicSession;

  const AdminModel({
    required this.id,
    required this.adminId,
    required this.fullName,
    required this.designation,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.schoolAffiliationNo,
    required this.academicSession,
  });
}

enum AttendanceStatus {
  present,
  absent,
  late,
}

class TeacherAttendanceStudent {
  final String studentId;
  final String rollNumber;
  final String fullName;
  final String avatarUrl;
  AttendanceStatus status;
  String? remarks;

  TeacherAttendanceStudent({
    required this.studentId,
    required this.rollNumber,
    required this.fullName,
    required this.avatarUrl,
    this.status = AttendanceStatus.present,
    this.remarks,
  });
}

class AdminStatsModel {
  final int totalStudents;
  final int totalTeachers;
  final int totalStaff;
  final double todayAttendancePercentage;
  final double monthlyFeeCollectionRupees;
  final double pendingFeesRupees;
  final int activeNoticesCount;
  final int busesOnRoute;

  const AdminStatsModel({
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalStaff,
    required this.todayAttendancePercentage,
    required this.monthlyFeeCollectionRupees,
    required this.pendingFeesRupees,
    required this.activeNoticesCount,
    required this.busesOnRoute,
  });
}
