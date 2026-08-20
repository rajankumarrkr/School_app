import '../models/student_model.dart';
import '../models/homework_model.dart';
import '../models/notice_model.dart';
import '../models/timetable_model.dart';
import '../models/result_model.dart';
import '../models/attendance_model.dart';
import '../models/exam_model.dart';
import '../models/fee_model.dart';
import '../models/notification_model.dart';
import '../data/dummy_student_data.dart';
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

  StudentModel _activeStudent = DummyStudentData.currentStudent;
  final List<HomeworkModel> _homeworkList = List.from(DummyHomeworkData.homeworkList);
  final List<NoticeModel> _noticeList = List.from(DummyNoticeData.noticeList);
  final List<NotificationItemModel> _notifications = List.from(DummyNotificationData.notificationList);

  StudentModel get currentStudent => _activeStudent;

  void switchStudent(StudentModel student) {
    _activeStudent = student;
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

  @override
  Future<bool> login(String studentId, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Demo credentials check
    final trimmedId = studentId.trim().toUpperCase();
    final trimmedPass = password.trim();
    if (trimmedId.isNotEmpty && (trimmedPass == '123456' || trimmedPass.length >= 4)) {
      final found = DummyStudentData.detailedStudents.firstWhere(
        (s) => s.id == trimmedId,
        orElse: () => DummyStudentData.detailedStudents.first,
      );
      _activeStudent = found;
      return true;
    }
    return false;
  }
}
