import 'package:flutter/material.dart';
import '../models/timetable_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

class TimetableCard extends StatelessWidget {
  final TimetableSlotModel slot;
  final bool isCurrent;

  const TimetableCard({
    super.key,
    required this.slot,
    this.isCurrent = false,
  });

  IconData _getSubjectIcon(String iconType) {
    switch (iconType) {
      case 'math':
        return Icons.calculate_rounded;
      case 'physics':
        return Icons.bolt_rounded;
      case 'chemistry':
        return Icons.science_rounded;
      case 'biology':
        return Icons.biotech_rounded;
      case 'computer':
        return Icons.computer_rounded;
      case 'english':
        return Icons.menu_book_rounded;
      case 'history':
        return Icons.public_rounded;
      case 'hindi':
        return Icons.translate_rounded;
      case 'sports':
        return Icons.fitness_center_rounded;
      case 'break':
        return Icons.restaurant_rounded;
      case 'library':
        return Icons.local_library_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  Color _getSubjectColor(String iconType) {
    switch (iconType) {
      case 'math':
        return AppColors.mathColor;
      case 'physics':
        return AppColors.physicsColor;
      case 'chemistry':
        return AppColors.chemistryColor;
      case 'biology':
        return AppColors.biologyColor;
      case 'computer':
        return AppColors.computerColor;
      case 'english':
        return AppColors.englishColor;
      case 'sports':
        return AppColors.sportsColor;
      case 'hindi':
        return AppColors.hindiColor;
      case 'break':
        return AppColors.warning;
      default:
        return AppColors.primaryNavy;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSubjectColor(slot.iconType);
    final icon = _getSubjectIcon(slot.iconType);

    if (slot.isBreak) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.warning.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.coffee_rounded, size: 18, color: AppColors.warning),
            const SizedBox(width: 10),
            Text(
              slot.subject,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${slot.startTime} – ${slot.endTime}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      border: isCurrent
          ? Border.all(color: AppColors.accentBlue, width: 2)
          : Border.all(color: AppColors.surfaceSubtle, width: 1),
      child: Row(
        children: [
          // Time badge
          Container(
            width: 75,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppColors.accentBlue.withOpacity(0.1)
                  : AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot.startTime.split(' ')[0],
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isCurrent ? AppColors.accentBlue : AppColors.textPrimary,
                  ),
                ),
                Text(
                  slot.startTime.split(' ').length > 1
                      ? slot.startTime.split(' ')[1]
                      : '',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  width: 16,
                  height: 1,
                  color: AppColors.surfaceSubtle,
                ),
                Text(
                  slot.endTime,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Subject icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          // Subject & Teacher info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        slot.subject,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NOW',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.person_pin_circle_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        slot.teacherName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.room_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      slot.roomNumber,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
