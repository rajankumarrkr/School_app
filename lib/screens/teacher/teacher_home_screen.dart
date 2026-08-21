import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../repositories/mock_school_repository.dart';
import '../../routes/app_routes.dart';

class TeacherHomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const TeacherHomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final teacher = MockSchoolRepository().getActiveTeacher()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher Header
              _buildTeacherHeader(context, teacher),
              const SizedBox(height: 20),

              // KPI Stats Row
              _buildQuickStats(context),
              const SizedBox(height: 20),

              // Current / Next Period Card
              _buildNextPeriodCard(context),
              const SizedBox(height: 24),

              // Quick Actions Grid
              Text(
                'Faculty Quick Actions',
                style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(context),
              const SizedBox(height: 24),

              // Today's Teaching Schedule
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Classes",
                    style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab?.call(3), // Switch to schedule tab
                    child: Text(
                      'View All',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildTodayScheduleList(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherHeader(BuildContext context, dynamic teacher) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.navyHeroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentGold, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(teacher.avatarUrl),
                    fit: BoxFit.cover,
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'FACULTY PORTAL',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.accentGoldLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 20),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          tooltip: 'Logout',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teacher.fullName,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${teacher.designation} • ${teacher.classTeacherOf}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            '4 Lectures',
            "Today's Load",
            Icons.menu_book_rounded,
            AppColors.accentBlue,
            AppColors.infoLight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            '10-A (38/40)',
            'Att. Marked',
            Icons.how_to_reg_rounded,
            AppColors.success,
            AppColors.successLight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            '12 Pending',
            'HW Reviews',
            Icons.assignment_turned_in_rounded,
            AppColors.accentGold,
            AppColors.warningLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPeriodCard(BuildContext context) {
    return AppCard(
      gradient: const LinearGradient(
        colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'UPCOMING PERIOD • PERIOD 3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.access_time_filled_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              const Text(
                '10:30 AM - 11:15 AM',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Class 10-A • Physics (Electromagnetism)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Room 204 • Physics Lab Block (Floor 2)',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => onNavigateTab?.call(1), // Go to attendance
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.fact_check_rounded, size: 16),
                label: const Text('Mark Class Attendance', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final actions = [
      {
        'title': 'Mark Attendance',
        'desc': 'Daily Class Register',
        'icon': Icons.how_to_reg_rounded,
        'color': AppColors.success,
        'tab': 1,
      },
      {
        'title': 'Give Homework',
        'desc': 'Assign Tasks & Work',
        'icon': Icons.edit_note_rounded,
        'color': AppColors.accentBlue,
        'tab': 2,
      },
      {
        'title': 'Grade & Marks',
        'desc': 'Enter Exam Scores',
        'icon': Icons.grade_rounded,
        'color': AppColors.accentGold,
        'tab': -1,
      },
      {
        'title': 'Class Timetable',
        'desc': 'Weekly Schedule',
        'icon': Icons.calendar_month_rounded,
        'color': AppColors.mathColor,
        'tab': 3,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        final iconColor = item['color'] as Color;

        return AppCard(
          padding: const EdgeInsets.all(14),
          onTap: () {
            final tabIndex = item['tab'] as int;
            if (tabIndex >= 0) {
              onNavigateTab?.call(tabIndex);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening Grade & Marks Entry module...'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item['icon'] as IconData, color: iconColor, size: 22),
              ),
              const Spacer(),
              Text(
                item['title'] as String,
                style: AppTextStyles.headlineSmall.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                item['desc'] as String,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTodayScheduleList(BuildContext context) {
    final periods = [
      {'period': 'Period 1', 'time': '08:30 - 09:15', 'class': 'Class 10-A', 'subject': 'Physics (Theory)', 'status': 'Completed'},
      {'period': 'Period 2', 'time': '09:15 - 10:00', 'class': 'Class 12-B', 'subject': 'Physics Lab', 'status': 'Completed'},
      {'period': 'Period 3', 'time': '10:30 - 11:15', 'class': 'Class 10-A', 'subject': 'Physics Practicals', 'status': 'Upcoming'},
      {'period': 'Period 5', 'time': '12:00 - 12:45', 'class': 'Class 12-A', 'subject': 'Electrostatics', 'status': 'Upcoming'},
    ];

    return Column(
      children: periods.map((p) {
        final isCompleted = p['status'] == 'Completed';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceSubtle),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.accentBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle_rounded : Icons.schedule_rounded,
                  color: isCompleted ? AppColors.success : AppColors.accentBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${p['period']} • ${p['class']}',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(
                          p['time']!,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p['subject']!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
