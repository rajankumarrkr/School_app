import '../models/homework_model.dart';

class DummyHomeworkData {
  static final List<HomeworkModel> homeworkList = [
    HomeworkModel(
      id: 'HW-101',
      subject: 'Mathematics',
      title: 'Chapter 5 – Quadratic Equations & Algebra',
      description:
          'Complete exercises 5.1 and 5.2 from the NCERT textbook. Solve all word problems from questions 10 to 18 on graph paper.',
      teacherName: 'Dr. S. K. Ramanujam',
      assignedDate: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now().add(const Duration(days: 2)),
      status: HomeworkStatus.pending,
      attachmentName: 'Algebra_Worksheet_Ch5.pdf',
      maxMarks: 20,
    ),
    HomeworkModel(
      id: 'HW-102',
      subject: 'Physics',
      title: 'Light: Reflection and Refraction Ray Diagrams',
      description:
          'Draw neat ray diagrams for convex and concave mirrors for 6 object positions. Write the sign convention rules in your practical journal.',
      teacherName: 'Mrs. Sunita Mukherjee',
      assignedDate: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 3)),
      status: HomeworkStatus.pending,
      attachmentName: 'Ray_Diagrams_Reference.pdf',
      maxMarks: 25,
    ),
    HomeworkModel(
      id: 'HW-103',
      subject: 'Computer Science',
      title: 'Python Functions & List Comprehension Assignment',
      description:
          'Write Python programs to find prime numbers in a range, matrix transpose, and word frequency counter. Submit the .py file script.',
      teacherName: 'Mr. Arvind Gupta',
      assignedDate: DateTime.now().subtract(const Duration(days: 4)),
      dueDate: DateTime.now().add(const Duration(days: 1)),
      status: HomeworkStatus.pending,
      attachmentName: 'Python_Lab_Sheet_04.pdf',
      maxMarks: 30,
    ),
    HomeworkModel(
      id: 'HW-104',
      subject: 'English Language',
      title: 'Essay: The Role of Armed Forces in Nation Building',
      description:
          'Write a 350-word analytical essay discussing discipline, patriotism, and modernization of modern defence forces.',
      teacherName: 'Mrs. Jennifer Thomas',
      assignedDate: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      status: HomeworkStatus.completed,
      submissionNote: 'Essay submitted on notebook and uploaded scanned copy.',
      attachmentName: 'Essay_Draft_Rahul.pdf',
      maxMarks: 20,
    ),
    HomeworkModel(
      id: 'HW-105',
      subject: 'Chemistry',
      title: 'Chemical Reactions and Equations: Balancing Practice',
      description:
          'Balance 25 chemical equations from Chapter 1. State the reaction type for each (Combination, Decomposition, Displacement, Redox).',
      teacherName: 'Dr. Vivek Sharma',
      assignedDate: DateTime.now().subtract(const Duration(days: 6)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      status: HomeworkStatus.completed,
      submissionNote: 'Checked and graded with 19/20 marks.',
      maxMarks: 20,
    ),
    HomeworkModel(
      id: 'HW-106',
      subject: 'Social Science (History)',
      title: 'The Rise of Nationalism in Europe – Timeline Chart',
      description:
          'Create a chronological timeline chart from 1789 to 1871 covering the French Revolution, Congress of Vienna, and Unification of Italy and Germany.',
      teacherName: 'Mr. Pradeep Joshi',
      assignedDate: DateTime.now().subtract(const Duration(days: 7)),
      dueDate: DateTime.now().subtract(const Duration(days: 3)),
      status: HomeworkStatus.overdue,
      attachmentName: 'Timeline_Guidelines.pdf',
      maxMarks: 15,
    ),
  ];
}
