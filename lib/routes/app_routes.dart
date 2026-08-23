import 'package:flutter/material.dart';
import '../models/homework_model.dart';
import '../models/notice_model.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/student_register_screen.dart';
import '../screens/main_layout.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/homework/homework_screen.dart';
import '../screens/homework/homework_detail_screen.dart';
import '../screens/timetable/timetable_screen.dart';
import '../screens/exams/exams_screen.dart';
import '../screens/results/results_screen.dart';
import '../screens/notices/notices_screen.dart';
import '../screens/notices/notice_detail_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/fees/fees_screen.dart';
import '../screens/contact/contact_screen.dart';
import '../screens/teacher/teacher_main_layout.dart';
import '../screens/teacher/teacher_attendance_screen.dart';
import '../screens/teacher/teacher_homework_screen.dart';
import '../screens/admin/admin_main_layout.dart';
import '../screens/admin/admin_directory_screen.dart';
import '../screens/admin/admin_fee_overview_screen.dart';
import '../screens/admin/admin_notice_manager_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainLayout = '/main';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String attendance = '/attendance';
  static const String homework = '/homework';
  static const String homeworkDetail = '/homework-detail';
  static const String timetable = '/timetable';
  static const String exams = '/exams';
  static const String results = '/results';
  static const String notices = '/notices';
  static const String noticeDetail = '/notice-detail';
  static const String notifications = '/notifications';
  static const String fees = '/fees';
  static const String contact = '/contact';

  // Teacher routes
  static const String teacherMain = '/teacher-main';
  static const String teacherAttendance = '/teacher-attendance';
  static const String teacherHomework = '/teacher-homework';

  // Admin routes
  static const String adminMain = '/admin-main';
  static const String adminDirectory = '/admin-directory';
  static const String adminFees = '/admin-fees';
  static const String adminNotices = '/admin-notices';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const StudentRegisterScreen());

      case mainLayout:
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainLayoutScreen(initialIndex: initialIndex),
        );

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());

      case homework:
        return MaterialPageRoute(builder: (_) => const HomeworkScreen());

      case homeworkDetail:
        final homework = settings.arguments as HomeworkModel;
        return MaterialPageRoute(
          builder: (_) => HomeworkDetailScreen(homework: homework),
        );

      case timetable:
        return MaterialPageRoute(builder: (_) => const TimetableScreen());

      case exams:
        return MaterialPageRoute(builder: (_) => const ExamsScreen());

      case results:
        return MaterialPageRoute(builder: (_) => const ResultsScreen());

      case notices:
        return MaterialPageRoute(builder: (_) => const NoticesScreen());

      case noticeDetail:
        final notice = settings.arguments as NoticeModel;
        return MaterialPageRoute(
          builder: (_) => NoticeDetailScreen(notice: notice),
        );

      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case fees:
        return MaterialPageRoute(builder: (_) => const FeesScreen());

      case contact:
        return MaterialPageRoute(builder: (_) => const ContactScreen());

      // Teacher Portal Routes
      case teacherMain:
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => TeacherMainLayoutScreen(initialIndex: initialIndex),
        );

      case teacherAttendance:
        return MaterialPageRoute(builder: (_) => const TeacherAttendanceScreen());

      case teacherHomework:
        return MaterialPageRoute(builder: (_) => const TeacherHomeworkScreen());

      // Admin Portal Routes
      case adminMain:
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => AdminMainLayoutScreen(initialIndex: initialIndex),
        );

      case adminDirectory:
        return MaterialPageRoute(builder: (_) => const AdminDirectoryScreen());

      case adminFees:
        return MaterialPageRoute(builder: (_) => const AdminFeeOverviewScreen());

      case adminNotices:
        return MaterialPageRoute(builder: (_) => const AdminNoticeManagerScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
