import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

class AttendanceCard extends StatelessWidget {
  final double percentage;
  final int presentDays;
  final int absentDays;
  final int totalWorkingDays;
  final VoidCallback? onTap;

  const AttendanceCard({
    super.key,
    required this.percentage,
    required this.presentDays,
    required this.absentDays,
    required this.totalWorkingDays,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Overview',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: percentage >= 75
                      ? AppColors.successLight
                      : AppColors.errorLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  percentage >= 75 ? 'Good Standing' : 'Low Attendance',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: percentage >= 75
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              // Circular progress indicator
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: (percentage / 100).clamp(0.0, 1.0),
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        backgroundColor: AppColors.surfaceSecondary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentage >= 75
                              ? AppColors.success
                              : (percentage >= 60
                                  ? AppColors.warning
                                  : AppColors.error),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Present',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Stats columns
              Expanded(
                child: Column(
                  children: [
                    _buildStatRow(
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.success,
                      label: 'Present Days',
                      value: '$presentDays',
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      icon: Icons.cancel_rounded,
                      iconColor: AppColors.error,
                      label: 'Absent Days',
                      value: '$absentDays',
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      icon: Icons.calendar_today_rounded,
                      iconColor: AppColors.accentBlue,
                      label: 'Working Days',
                      value: '$totalWorkingDays',
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

  Widget _buildStatRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
