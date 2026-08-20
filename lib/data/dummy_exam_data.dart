import '../models/exam_model.dart';

class DummyExamData {
  static final List<ExamScheduleModel> upcomingExams = [
    ExamScheduleModel(
      id: 'EXAM-UT2-2026',
      examTitle: 'Unit Test – 2 (2026)',
      term: 'Periodic Assessment 2',
      startDate: DateTime.now().add(const Duration(days: 4)),
      endDate: DateTime.now().add(const Duration(days: 12)),
      instructions:
          '1. Arrive in full uniform 15 minutes before exam commencement.\n2. Bring authorized scientific calculators where permitted.\n3. Digital smartwatches and mobile phones are strictly prohibited.',
      schedules: [
        ExamSubjectSchedule(
          subjectName: 'Mathematics',
          examDate: DateTime.now().add(const Duration(days: 4)),
          startTime: '09:00 AM',
          endTime: '11:00 AM',
          roomNumber: 'Hall A (Roll 01-25)',
          maxMarks: 50,
          syllabus: 'Ch 4 (Quadratic Equations), Ch 5 (Arithmetic Progressions), Ch 7 (Coordinate Geometry)',
        ),
        ExamSubjectSchedule(
          subjectName: 'Physics',
          examDate: DateTime.now().add(const Duration(days: 6)),
          startTime: '09:00 AM',
          endTime: '11:00 AM',
          roomNumber: 'Hall A',
          maxMarks: 50,
          syllabus: 'Light (Reflection & Refraction), Human Eye & Colourful World (Part 1)',
        ),
        ExamSubjectSchedule(
          subjectName: 'English Language',
          examDate: DateTime.now().add(const Duration(days: 8)),
          startTime: '09:00 AM',
          endTime: '11:00 AM',
          roomNumber: 'Hall B',
          maxMarks: 50,
          syllabus: 'Reading Comprehension, Formal Letter Writing, Analytical Paragraph, First Flight Ch 3-5',
        ),
        ExamSubjectSchedule(
          subjectName: 'Computer Science',
          examDate: DateTime.now().add(const Duration(days: 10)),
          startTime: '09:00 AM',
          endTime: '11:00 AM',
          roomNumber: 'Computer Lab 1',
          maxMarks: 50,
          syllabus: 'Python Loops, User-Defined Functions, String Manipulations, Cybersecurity Ethics',
        ),
        ExamSubjectSchedule(
          subjectName: 'Chemistry',
          examDate: DateTime.now().add(const Duration(days: 12)),
          startTime: '09:00 AM',
          endTime: '11:00 AM',
          roomNumber: 'Hall A',
          maxMarks: 50,
          syllabus: 'Acids, Bases and Salts, Metals and Non-Metals (Properties & Extraction)',
        ),
      ],
    ),
    ExamScheduleModel(
      id: 'EXAM-HALF-2026',
      examTitle: 'Half Yearly Examination 2026',
      term: 'Mid-Term Board Mock',
      startDate: DateTime.now().add(const Duration(days: 40)),
      endDate: DateTime.now().add(const Duration(days: 55)),
      instructions:
          'Comprehensive 80-mark board pattern examination covering complete Term 1 syllabus.',
      schedules: [
        ExamSubjectSchedule(
          subjectName: 'All Major Subjects',
          examDate: DateTime.now().add(const Duration(days: 40)),
          startTime: '08:30 AM',
          endTime: '11:45 AM',
          roomNumber: 'Senior Examination Wing',
          maxMarks: 80,
          syllabus: 'Full Term 1 CBSE Curriculum',
        ),
      ],
    ),
  ];
}
