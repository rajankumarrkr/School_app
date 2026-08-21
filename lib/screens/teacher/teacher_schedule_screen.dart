import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  String _selectedDay = 'Monday';
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  final Map<String, List<Map<String, dynamic>>> _teacherSchedule = {
    'Monday': [
      {'period': '1', 'time': '08:30 - 09:15', 'class': 'Class 10-A', 'room': 'Room 204', 'subject': 'Physics (Theory)', 'type': 'Lecture'},
      {'period': '2', 'time': '09:15 - 10:00', 'class': 'Class 12-B', 'room': 'Physics Lab', 'subject': 'Optics Practicals', 'type': 'Lab'},
      {'period': 'Break', 'time': '10:00 - 10:30', 'class': 'Staff Room', 'room': 'Block A', 'subject': 'Recess & Tea', 'type': 'Break'},
      {'period': '3', 'time': '10:30 - 11:15', 'class': 'Class 10-A', 'room': 'Physics Lab', 'subject': 'Physics Practicals', 'type': 'Lab'},
      {'period': '4', 'time': '11:15 - 12:00', 'class': 'Free Period', 'room': 'Staff Room', 'subject': 'Lesson Planning', 'type': 'Free'},
      {'period': '5', 'time': '12:00 - 12:45', 'class': 'Class 12-A', 'room': 'Room 302', 'subject': 'Electrostatics', 'type': 'Lecture'},
    ],
    'Tuesday': [
      {'period': '1', 'time': '08:30 - 09:15', 'class': 'Class 12-A', 'room': 'Room 302', 'subject': 'Electromagnetism', 'type': 'Lecture'},
      {'period': '2', 'time': '09:15 - 10:00', 'class': 'Class 10-A', 'room': 'Room 204', 'subject': 'Physics (Mechanics)', 'type': 'Lecture'},
      {'period': 'Break', 'time': '10:00 - 10:30', 'class': 'Staff Room', 'room': 'Block A', 'subject': 'Recess & Tea', 'type': 'Break'},
      {'period': '3', 'time': '10:30 - 11:15', 'class': 'Class 10-B', 'room': 'Room 205', 'subject': 'Physics (Theory)', 'type': 'Lecture'},
      {'period': '4', 'time': '11:15 - 12:00', 'class': 'Class 12-B', 'room': 'Physics Lab', 'subject': 'Current Electricity Lab', 'type': 'Lab'},
      {'period': '5', 'time': '12:00 - 12:45', 'class': 'Free Period', 'room': 'Staff Room', 'subject': 'Correction Work', 'type': 'Free'},
    ],
    'Wednesday': [
      {'period': '1', 'time': '08:30 - 09:15', 'class': 'Class 10-B', 'room': 'Room 205', 'subject': 'Sound & Waves', 'type': 'Lecture'},
      {'period': '2', 'time': '09:15 - 10:00', 'class': 'Class 12-B', 'room': 'Room 303', 'subject': 'Modern Physics', 'type': 'Lecture'},
      {'period': 'Break', 'time': '10:00 - 10:30', 'class': 'Staff Room', 'room': 'Block A', 'subject': 'Recess & Tea', 'type': 'Break'},
      {'period': '3', 'time': '10:30 - 11:15', 'class': 'Class 10-A', 'room': 'Room 204', 'subject': 'Physics Doubt Class', 'type': 'Lecture'},
      {'period': '4', 'time': '11:15 - 12:00', 'class': 'Class 12-A', 'room': 'Physics Lab', 'subject': 'Semiconductors Lab', 'type': 'Lab'},
    ],
    'Thursday': [
      {'period': '1', 'time': '08:30 - 09:15', 'class': 'Class 10-A', 'room': 'Room 204', 'subject': 'Physics (Theory)', 'type': 'Lecture'},
      {'period': '2', 'time': '09:15 - 10:00', 'class': 'Class 12-A', 'room': 'Room 302', 'subject': 'Nuclear Physics', 'type': 'Lecture'},
      {'period': 'Break', 'time': '10:00 - 10:30', 'class': 'Staff Room', 'room': 'Block A', 'subject': 'Recess & Tea', 'type': 'Break'},
      {'period': '3', 'time': '10:30 - 11:15', 'class': 'Class 10-B', 'room': 'Physics Lab', 'subject': 'Electricity Practicals', 'type': 'Lab'},
    ],
    'Friday': [
      {'period': '1', 'time': '08:30 - 09:15', 'class': 'Class 12-B', 'room': 'Room 303', 'subject': 'Wave Optics', 'type': 'Lecture'},
      {'period': '2', 'time': '09:15 - 10:00', 'class': 'Class 10-A', 'room': 'Room 204', 'subject': 'Revision & Quiz', 'type': 'Lecture'},
      {'period': 'Break', 'time': '10:00 - 10:30', 'class': 'Staff Room', 'room': 'Block A', 'subject': 'Recess & Tea', 'type': 'Break'},
      {'period': '3', 'time': '10:30 - 11:15', 'class': 'Assembly / House', 'room': 'Auditorium', 'subject': 'Shivaji House Meeting', 'type': 'Activity'},
    ],
    'Saturday': [
      {'period': '1', 'time': '08:30 - 09:30', 'class': 'Class 12 Remedial', 'room': 'Room 302', 'subject': 'Board Exam Prep', 'type': 'Lecture'},
      {'period': '2', 'time': '09:30 - 10:30', 'class': 'Class 10 Remedial', 'room': 'Room 204', 'subject': 'Numerical Problem Solving', 'type': 'Lecture'},
      {'period': '3', 'time': '11:00 - 12:30', 'class': 'Departmental Meet', 'room': 'Conference Room', 'subject': 'Science Faculty Review', 'type': 'Activity'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final list = _teacherSchedule[_selectedDay] ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Faculty Timetable',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Day selector tabs
            Container(
              height: 52,
              color: AppColors.surface,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final isSelected = day == _selectedDay;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = day),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryNavy : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),

            // Schedule List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final slot = list[index];
                  final isBreak = slot['type'] == 'Break';
                  final isFree = slot['type'] == 'Free';

                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isBreak ? AppColors.warningLight : (isFree ? AppColors.surfaceSecondary : AppColors.surface),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isBreak
                                ? AppColors.warning.withOpacity(0.2)
                                : (isFree ? AppColors.textMuted.withOpacity(0.2) : AppColors.accentBlue.withOpacity(0.12)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            slot['period'],
                            style: TextStyle(
                              color: isBreak ? AppColors.warning : (isFree ? AppColors.textSecondary : AppColors.accentBlue),
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    slot['class'],
                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),
                                  Text(
                                    slot['time'],
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${slot['subject']} • ${slot['room']}',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
