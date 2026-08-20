import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notice_model.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

class NoticeCard extends StatelessWidget {
  final NoticeModel notice;
  final VoidCallback? onTap;

  const NoticeCard({
    super.key,
    required this.notice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final formattedDate = dateFormat.format(notice.date);

    Color priorityColor;
    Color priorityBg;
    String priorityText;

    switch (notice.priority) {
      case NoticePriority.urgent:
        priorityColor = AppColors.error;
        priorityBg = AppColors.errorLight;
        priorityText = 'Urgent';
        break;
      case NoticePriority.high:
        priorityColor = AppColors.warning;
        priorityBg = AppColors.warningLight;
        priorityText = 'Important';
        break;
      case NoticePriority.normal:
      case NoticePriority.low:
        priorityColor = AppColors.accentBlue;
        priorityBg = AppColors.infoLight;
        priorityText = 'Notice';
        break;
    }

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: priorityBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  priorityText,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: priorityColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formattedDate,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const Spacer(),
              if (!notice.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accentBlue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            notice.title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            notice.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        notice.issuedBy,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (notice.attachmentUrl != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.attach_file_rounded,
                      size: 14,
                      color: AppColors.accentBlue,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Attachment',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.accentBlue,
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
