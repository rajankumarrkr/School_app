import '../models/notice_model.dart';

class DummyNoticeData {
  static final List<NoticeModel> noticeList = [
    NoticeModel(
      id: 'NOT-201',
      title: 'Parent-Teacher Meeting (PTM) for Term 1 Progress',
      description:
          'The Parent-Teacher Meeting for Classes 9 through 12 is scheduled for Saturday, 29th August 2026 from 09:00 AM to 01:30 PM. Parents are requested to adhere to their allotted time slots to discuss academic progress, discipline, and co-curricular development.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      priority: NoticePriority.high,
      category: NoticeCategory.academic,
      issuedBy: 'Principal Office, WORTH RM SOLDIER PUBLIC SCHOOL',
      isRead: false,
      attachmentUrl: 'PTM_Schedule_Slot_Allotment.pdf',
    ),
    NoticeModel(
      id: 'NOT-202',
      title: 'Annual Inter-House Sports Meet & Parade 2026',
      description:
          'Registrations are now open for the Annual Inter-House Athletics Championship, March Past Parade, Obstacle Course, and Rifle Shooting competition. Students wishing to participate should submit their names to their respective House Captains by 26th August 2026.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      priority: NoticePriority.normal,
      category: NoticeCategory.sports,
      issuedBy: 'Director of Physical Education & Cadet Training',
      isRead: true,
      attachmentUrl: 'Sports_Events_Rulebook.pdf',
    ),
    NoticeModel(
      id: 'NOT-203',
      title: 'Independence Day Celebrations & Guard of Honour Review',
      description:
          'All students and staff are cordially invited to celebrate the 79th Independence Day in the School Main Ground at 07:45 AM. Formal uniform with house badge and polished shoes is strictly mandatory. Sweets and refreshments will be served after the flag hoisting ceremony.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      priority: NoticePriority.urgent,
      category: NoticeCategory.events,
      issuedBy: 'Commandant / School Administration',
      isRead: true,
    ),
    NoticeModel(
      id: 'NOT-204',
      title: 'Unit Test – 2 Schedule & Syllabus Release (Classes 9-12)',
      description:
          'The detailed date sheet for Unit Test 2 has been released. The tests will commence from 25th August 2026. The maximum marks for each paper will be 50 with a time duration of 2 hours. Download the syllabus blueprint attached.',
      date: DateTime.now().subtract(const Duration(days: 6)),
      priority: NoticePriority.urgent,
      category: NoticeCategory.exams,
      issuedBy: 'Controller of Examinations',
      isRead: false,
      attachmentUrl: 'Unit_Test_2_Blueprint.pdf',
    ),
    NoticeModel(
      id: 'NOT-205',
      title: 'School Holiday Notice: Janmashtami Festival',
      description:
          'The school will remain closed on Friday, 4th September 2026 on account of Janmashtami. Regular classes and cadet drills will resume on Monday, 7th September 2026.',
      date: DateTime.now().subtract(const Duration(days: 8)),
      priority: NoticePriority.low,
      category: NoticeCategory.holiday,
      issuedBy: 'Registrar',
      isRead: true,
    ),
  ];
}
