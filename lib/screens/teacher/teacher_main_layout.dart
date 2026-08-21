import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'teacher_home_screen.dart';
import 'teacher_attendance_screen.dart';
import 'teacher_homework_screen.dart';
import 'teacher_schedule_screen.dart';
import 'teacher_profile_screen.dart';

class TeacherMainLayoutScreen extends StatefulWidget {
  final int initialIndex;

  const TeacherMainLayoutScreen({super.key, this.initialIndex = 0});

  @override
  State<TeacherMainLayoutScreen> createState() => _TeacherMainLayoutScreenState();
}

class _TeacherMainLayoutScreenState extends State<TeacherMainLayoutScreen> {
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
      TeacherHomeScreen(onNavigateTab: _onTabChanged),
      const TeacherAttendanceScreen(),
      const TeacherHomeworkScreen(),
      const TeacherScheduleScreen(),
      const TeacherProfileScreen(),
    ];

    final navItems = [
      {'icon': Icons.dashboard_outlined, 'active': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.how_to_reg_outlined, 'active': Icons.how_to_reg_rounded, 'label': 'Attendance'},
      {'icon': Icons.assignment_outlined, 'active': Icons.assignment_rounded, 'label': 'Homework'},
      {'icon': Icons.calendar_month_outlined, 'active': Icons.calendar_month_rounded, 'label': 'Schedule'},
      {'icon': Icons.person_outline_rounded, 'active': Icons.person_rounded, 'label': 'Profile'},
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: AppColors.surfaceSubtle, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = index == _currentIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabChanged(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryNavy.withOpacity(0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? (item['active'] as IconData) : (item['icon'] as IconData),
                            size: 22,
                            color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['label'] as String,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
