import '../models/student_model.dart';
import '../models/homework_model.dart';
import '../models/notice_model.dart';
import '../models/timetable_model.dart';
import '../models/result_model.dart';
import '../models/attendance_model.dart';
import '../models/exam_model.dart';
import '../models/fee_model.dart';
import '../models/notification_model.dart';
import '../models/user_role_model.dart';
import '../data/dummy_student_data.dart';
import '../data/dummy_staff_data.dart';
import '../data/dummy_homework_data.dart';
import '../data/dummy_notice_data.dart';
import '../data/dummy_timetable_data.dart';
import '../data/dummy_result_data.dart';
import '../data/dummy_attendance_data.dart';
import '../data/dummy_exam_data.dart';
import '../data/dummy_fee_data.dart';
import '../data/dummy_notification_data.dart';
import 'school_repository.dart';

class MockSchoolRepository implements SchoolRepository {
  // Singleton pattern for session-wide state persistence
  static final MockSchoolRepository _instance = MockSchoolRepository._internal();
  factory MockSchoolRepository() => _instance;
  MockSchoolRepository._internal();

  UserRole _activeRole = UserRole.student;
  StudentModel _activeStudent = DummyStudentData.currentStudent;
  TeacherModel _activeTeacher = DummyStaffData.teachers.first;
  AdminModel _activeAdmin = DummyStaffData.admin;

  final List<HomeworkModel> _homeworkList = List.from(DummyHomeworkData.homeworkList);
  final List<NoticeModel> _noticeList = List.from(DummyNoticeData.noticeList);
  final List<NotificationItemModel> _notifications = List.from(DummyNotificationData.notificationList);

  StudentModel get currentStudent => _activeStudent;

  void switchStudent(StudentModel student) {
    _activeStudent = student;
  }

  @override
  UserRole getActiveRole() => _activeRole;

  @override
  StudentModel getActiveStudent() => _activeStudent;

  @override
  TeacherModel? getActiveTeacher() => _activeTeacher;

  @override
  AdminModel? getActiveAdmin() => _activeAdmin;

  @override
  Future<bool> login(String studentId, String password) async {
    return loginWithRole(studentId, password, UserRole.student);
  }

  @override
  Future<bool> loginWithRole(String username, String password, UserRole role) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final trimmedUser = username.trim().toUpperCase();
    final trimmedPass = password.trim();

    if (trimmedUser.isEmpty || (trimmedPass != '123456' && trimmedPass.length < 4)) {
      return false;
    }

    _activeRole = role;

    switch (role) {
      case UserRole.student:
        final found = DummyStudentData.detailedStudents.firstWhere(
          (s) => s.id == trimmedUser,
          orElse: () => DummyStudentData.detailedStudents.first,
        );
        _activeStudent = found;
        return true;

      case UserRole.teacher:
        final found = DummyStaffData.teachers.firstWhere(
          (t) => t.id == trimmedUser || t.employeeId == trimmedUser,
          orElse: () => DummyStaffData.teachers.first,
        );
        _activeTeacher = found;
        return true;

      case UserRole.admin:
        _activeAdmin = DummyStaffData.admin;
        return true;
    }
  }

  @override
  Future<StudentModel> getStudentProfile(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final found = DummyStudentData.detailedStudents.firstWhere(
      (s) => s.id.toLowerCase() == studentId.toLowerCase(),
      orElse: () => _activeStudent,
    );
    _activeStudent = found;
    return _activeStudent;
  }

  @override
  Future<List<StudentModel>> getAllStudents() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DummyStudentData.getAllStudentsRoster();
  }

  @override
  Future<StudentModel> updateStudentProfile(StudentModel student) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _activeStudent = student;
    return _activeStudent;
  }

  @override
  Future<List<HomeworkModel>> getHomeworkList({HomeworkStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (status == null) {
      return List.unmodifiable(_homeworkList);
    }
    return _homeworkList.where((hw) => hw.status == status).toList();
  }

  @override
  Future<void> submitHomework(String homeworkId, String note) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _homeworkList.indexWhere((h) => h.id == homeworkId);
    if (index != -1) {
      _homeworkList[index] = _homeworkList[index].copyWith(
        status: HomeworkStatus.completed,
        submissionNote: note.isNotEmpty ? note : 'Submitted via School Portal',
      );
    }
  }

  @override
  Future<List<NoticeModel>> getNotices({NoticeCategory? category}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (category == null) {
      return List.unmodifiable(_noticeList);
    }
    return _noticeList.where((n) => n.category == category).toList();
  }

  @override
  Future<void> markNoticeAsRead(String noticeId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _noticeList.indexWhere((n) => n.id == noticeId);
    if (index != -1) {
      _noticeList[index] = _noticeList[index].copyWith(isRead: true);
    }
  }

  @override
  Future<Map<String, List<TimetableSlotModel>>> getWeeklyTimetable() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DummyTimetableData.weeklySchedule;
  }

  @override
  Future<List<TimetableSlotModel>> getTodaySchedule() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return DummyTimetableData.getTodaySchedule();
  }

  @override
  Future<List<ExamResultModel>> getExamResults() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DummyResultData.examResults;
  }

  @override
  Future<AttendanceSummaryModel> getAttendanceSummary() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DummyAttendanceData.getAttendanceSummary();
  }

  @override
  Future<List<ExamScheduleModel>> getUpcomingExams() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DummyExamData.upcomingExams;
  }

  @override
  Future<FeeSummaryModel> getFeeSummary() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return DummyFeeData.getFeeSummary();
  }

  @override
  Future<List<NotificationItemModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_notifications);
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await Future.delayed(const Duration(milliseconds: 150));
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  // Teacher specific implementations
  @override
  Future<List<TeacherModel>> getAllTeachers() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(DummyStaffData.teachers);
  }

  @override
  Future<List<TeacherAttendanceStudent>> getStudentsForAttendance(String className, String section) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final roster = DummyStudentData.getAllStudentsRoster();
    final filtered = roster.where((s) => s.className == className && s.section == section).toList();
    final sourceList = filtered.isNotEmpty ? filtered : roster.take(15).toList();

    return sourceList.map((s) => TeacherAttendanceStudent(
      studentId: s.id,
      rollNumber: s.rollNumber,
      fullName: s.fullName,
      avatarUrl: s.avatarUrl,
      status: AttendanceStatus.present,
    )).toList();
  }

  @override
  Future<bool> submitClassAttendance(
    String className,
    String section,
    DateTime date,
    List<TeacherAttendanceStudent> records,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> createHomework(HomeworkModel homework) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _homeworkList.insert(0, homework);
    return true;
  }

  // Admin specific implementations
  @override
  Future<bool> publishNotice(NoticeModel notice) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _noticeList.insert(0, notice);
    return true;
  }

  @override
  Future<AdminStatsModel> getAdminStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return DummyStaffData.stats;
  }
}
