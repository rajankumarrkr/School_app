import '../models/student_model.dart';
import '../models/homework_model.dart';
import '../models/notice_model.dart';
import '../models/timetable_model.dart';
import '../models/result_model.dart';
import '../models/attendance_model.dart';
import '../models/exam_model.dart';
import '../models/fee_model.dart';
import '../models/notification_model.dart';

abstract class SchoolRepository {
  Future<StudentModel> getStudentProfile(String studentId);
  Future<List<StudentModel>> getAllStudents();
  Future<StudentModel> updateStudentProfile(StudentModel student);
  Future<List<HomeworkModel>> getHomeworkList({HomeworkStatus? status});
  Future<void> submitHomework(String homeworkId, String note);
  Future<List<NoticeModel>> getNotices({NoticeCategory? category});
  Future<void> markNoticeAsRead(String noticeId);
  Future<Map<String, List<TimetableSlotModel>>> getWeeklyTimetable();
  Future<List<TimetableSlotModel>> getTodaySchedule();
  Future<List<ExamResultModel>> getExamResults();
  Future<AttendanceSummaryModel> getAttendanceSummary();
  Future<List<ExamScheduleModel>> getUpcomingExams();
  Future<FeeSummaryModel> getFeeSummary();
  Future<List<NotificationItemModel>> getNotifications();
  Future<void> markAllNotificationsRead();
  Future<bool> login(String studentId, String password);
}
