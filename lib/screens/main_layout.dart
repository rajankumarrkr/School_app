import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home/home_screen.dart';
import 'timetable/timetable_screen.dart';
import 'homework/homework_screen.dart';
import 'notices/notices_screen.dart';
import 'profile/profile_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  final int initialIndex;

  const MainLayoutScreen({super.key, this.initialIndex = 0});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabChanged),
      const TimetableScreen(isEmbedded: true),
      const HomeworkScreen(isEmbedded: true),
      const NoticesScreen(isEmbedded: true),
      const ProfileScreen(isEmbedded: true),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ModernBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
