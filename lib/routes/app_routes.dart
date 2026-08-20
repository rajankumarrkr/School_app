import 'package:flutter/material.dart';
import '../models/homework_model.dart';
import '../models/notice_model.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/login/login_screen.dart';
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

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

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
