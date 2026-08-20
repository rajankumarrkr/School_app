import '../models/attendance_model.dart';

class DummyAttendanceData {
  static AttendanceSummaryModel getAttendanceSummary() {
    final now = DateTime.now();
    final List<AttendanceDayRecord> records = [];

    // Generate daily records for the current month and past month (last 45 days)
    for (int i = 45; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      if (day.weekday == DateTime.sunday) {
        records.add(AttendanceDayRecord(
          date: day,
          status: AttendanceDayStatus.holiday,
          remarks: 'Sunday Holiday',
        ));
      } else if (i == 14 || i == 32) {
        records.add(AttendanceDayRecord(
          date: day,
          status: AttendanceDayStatus.absent,
          remarks: i == 14 ? 'Medical Leave (Viral Fever)' : 'Family Function',
        ));
      } else if (i == 8 || i == 25) {
        records.add(AttendanceDayRecord(
          date: day,
          status: AttendanceDayStatus.holiday,
          remarks: i == 8 ? 'Independence Day' : 'Gazetted Holiday',
        ));
      } else {
        records.add(AttendanceDayRecord(
          date: day,
          status: AttendanceDayStatus.present,
          remarks: 'Present (On Time 07:50 AM)',
        ));
      }
    }

    return AttendanceSummaryModel(
      totalWorkingDays: 150,
      presentDays: 138,
      absentDays: 12,
      holidays: 24,
      dailyRecords: records,
      subjectAttendance: const [
        SubjectAttendanceModel(
          subjectName: 'Mathematics',
          totalClasses: 48,
          attendedClasses: 46,
        ),
        SubjectAttendanceModel(
          subjectName: 'Physics & Lab',
          totalClasses: 44,
          attendedClasses: 40,
        ),
        SubjectAttendanceModel(
          subjectName: 'Computer Science',
          totalClasses: 38,
          attendedClasses: 37,
        ),
        SubjectAttendanceModel(
          subjectName: 'English Language',
          totalClasses: 36,
          attendedClasses: 34,
        ),
        SubjectAttendanceModel(
          subjectName: 'Chemistry & Lab',
          totalClasses: 42,
          attendedClasses: 38,
        ),
        SubjectAttendanceModel(
          subjectName: 'Physical Education & Drill',
          totalClasses: 30,
          attendedClasses: 29,
        ),
      ],
    );
  }
}
