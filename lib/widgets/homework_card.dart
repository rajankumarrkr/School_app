import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/homework_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

class HomeworkCard extends StatelessWidget {
  final HomeworkModel homework;
  final VoidCallback? onTap;

  const HomeworkCard({
    super.key,
    required this.homework,
    this.onTap,
  });

  Color _getSubjectColor(String subject) {
    final s = subject.toLowerCase();
    if (s.contains('math')) return AppColors.mathColor;
    if (s.contains('physic')) return AppColors.physicsColor;
    if (s.contains('chem')) return AppColors.chemistryColor;
    if (s.contains('bio')) return AppColors.biologyColor;
    if (s.contains('comp')) return AppColors.computerColor;
    if (s.contains('eng')) return AppColors.englishColor;
    if (s.contains('hindi')) return AppColors.hindiColor;
    return AppColors.accentBlue;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDueDate = dateFormat.format(homework.dueDate);
    final subjectColor = _getSubjectColor(homework.subject);

    Color statusBg;
    Color statusTextColor;
    String statusLabel;
    IconData statusIcon;

    switch (homework.status) {
      case HomeworkStatus.completed:
        statusBg = AppColors.successLight;
        statusTextColor = AppColors.success;
        statusLabel = 'Completed';
        statusIcon = Icons.check_circle_rounded;
        break;
      case HomeworkStatus.overdue:
        statusBg = AppColors.errorLight;
        statusTextColor = AppColors.error;
        statusLabel = 'Overdue';
        statusIcon = Icons.error_rounded;
        break;
      case HomeworkStatus.pending:
        statusBg = AppColors.warningLight;
        statusTextColor = AppColors.warning;
        statusLabel = 'Pending';
        statusIcon = Icons.access_time_filled_rounded;
        break;
    }

    final daysLeft = homework.dueDate.difference(DateTime.now()).inDays;
    String dueText = 'Due: $formattedDueDate';
    if (homework.status == HomeworkStatus.pending) {
      if (daysLeft == 0) {
        dueText = 'Due Today';
      } else if (daysLeft == 1) {
        dueText = 'Due Tomorrow';
      } else if (daysLeft > 1) {
        dueText = 'Due in $daysLeft days';
      }
    }

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: subjectColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  homework.subject,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: subjectColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusTextColor),
                    const SizedBox(width: 4),
                    Text(
                      statusLabel,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: statusTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            homework.title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            homework.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                size: 15,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  homework.teacherName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 14,
                    color: homework.status == HomeworkStatus.overdue
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dueText,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: homework.status == HomeworkStatus.overdue
                          ? AppColors.error
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
