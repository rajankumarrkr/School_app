import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../repositories/mock_school_repository.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _repository = MockSchoolRepository();
  List<NotificationItemModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final list = await _repository.getNotifications();
    if (!mounted) return;
    setState(() {
      _notifications = list;
      _isLoading = false;
    });
  }

  Future<void> _handleMarkAllRead() async {
    await _repository.markAllNotificationsRead();
    _loadNotifications();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.homework:
        return Icons.assignment_outlined;
      case NotificationType.notice:
        return Icons.campaign_outlined;
      case NotificationType.exam:
        return Icons.timer_outlined;
      case NotificationType.attendance:
        return Icons.how_to_reg_outlined;
      case NotificationType.result:
        return Icons.military_tech_outlined;
      case NotificationType.fee:
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.homework:
        return AppColors.mathColor;
      case NotificationType.notice:
        return AppColors.error;
      case NotificationType.exam:
        return AppColors.accentBlue;
      case NotificationType.attendance:
        return AppColors.success;
      case NotificationType.result:
        return AppColors.accentGold;
      case NotificationType.fee:
        return AppColors.computerColor;
      default:
        return AppColors.primaryNavy;
    }
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _handleMarkAllRead,
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? EmptyStateView(
                  title: 'No Notifications',
                  message: "You're all caught up with recent school alerts! 🔔",
                  icon: Icons.notifications_off_outlined,
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final item = _notifications[index];
                    final color = _getColorForType(item.type);
                    final icon = _getIconForType(item.type);

                    return AppCard(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      padding: const EdgeInsets.all(14),
                      color: item.isRead
                          ? AppColors.surface
                          : AppColors.primaryNavy.withOpacity(0.04),
                      border: Border.all(
                        color: item.isRead
                            ? AppColors.surfaceSubtle
                            : AppColors.accentBlue.withOpacity(0.4),
                        width: item.isRead ? 1 : 1.5,
                      ),
                      onTap: () {
                        if (item.targetRoute != null) {
                          Navigator.pushNamed(context, item.targetRoute!);
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(icon, color: color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: AppTextStyles.titleSmall.copyWith(
                                          fontWeight: item.isRead
                                              ? FontWeight.w600
                                              : FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _formatTimeAgo(item.timestamp),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.message,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
