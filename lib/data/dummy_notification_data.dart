import '../models/notification_model.dart';

class DummyNotificationData {
  static final List<NotificationItemModel> notificationList = [
    NotificationItemModel(
      id: 'NOTIF-1',
      title: 'New Homework Uploaded',
      message: 'Dr. Ramanujam assigned Chapter 5 Algebra exercises (Due in 2 days).',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      type: NotificationType.homework,
      isRead: false,
      targetRoute: '/homework',
    ),
    NotificationItemModel(
      id: 'NOTIF-2',
      title: 'Parent-Teacher Meeting Scheduled',
      message: 'PTM for Term 1 progress has been scheduled for this Saturday.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.notice,
      isRead: false,
      targetRoute: '/notices',
    ),
    NotificationItemModel(
      id: 'NOTIF-3',
      title: 'Unit Test – 2 Date Sheet Published',
      message: 'Exam schedule starting from 25th August is now available.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: NotificationType.exam,
      isRead: true,
      targetRoute: '/exams',
    ),
    NotificationItemModel(
      id: 'NOTIF-4',
      title: 'Attendance Marked Present',
      message: 'Morning roll call recorded: Present on 20 Aug 2026 at 07:55 AM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      type: NotificationType.attendance,
      isRead: true,
      targetRoute: '/attendance',
    ),
    NotificationItemModel(
      id: 'NOTIF-5',
      title: 'Term 1 Exam Results Published',
      message: 'Congratulations! You secured 4th Rank in Class 10-A with Grade A+.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.result,
      isRead: true,
      targetRoute: '/results',
    ),
    NotificationItemModel(
      id: 'NOTIF-6',
      title: 'School Fee Reminder for August',
      message: 'Installment for August 2026 is due by 25th August.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.fee,
      isRead: true,
      targetRoute: '/fees',
    ),
  ];
}
