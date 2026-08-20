import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../models/timetable_model.dart';
import '../../models/notice_model.dart';
import '../../models/homework_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_badge.dart';
import '../../widgets/timetable_card.dart';
import '../../widgets/notice_card.dart';
import '../../repositories/mock_school_repository.dart';
import '../../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = MockSchoolRepository();
  late StudentModel _student;
  List<TimetableSlotModel> _todaySchedule = [];
  List<NoticeModel> _latestNotices = [];
  int _pendingHomeworkCount = 3;
  int _upcomingExamsCount = 2;
  double _attendancePercentage = 92.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    final student = _repository.currentStudent;
    final schedule = await _repository.getTodaySchedule();
    final notices = await _repository.getNotices();
    final homework = await _repository.getHomeworkList(status: HomeworkStatus.pending);
    final attendance = await _repository.getAttendanceSummary();
    final exams = await _repository.getUpcomingExams();

    if (!mounted) return;

    setState(() {
      _student = student;
      _todaySchedule = schedule.take(4).toList();
      _latestNotices = notices.take(3).toList();
      _pendingHomeworkCount = homework.length;
      _attendancePercentage = attendance.overallPercentage;
      _upcomingExamsCount = exams.length;
      _isLoading = false;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning 👋';
    if (hour < 17) return 'Good Afternoon ☀️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryNavy),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar & Hero Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.navyHeroGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: School Badge + Notification Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.accentGold,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.shield_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'WORTH RM SOLDIER',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textOnNavy,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  Text(
                                    'PUBLIC SCHOOL',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.accentGoldLight,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Notification Center Action
                              Stack(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, AppRoutes.notifications);
                                    },
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Student Info Card
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (widget.onNavigateTab != null) {
                                widget.onNavigateTab!(4); // Profile tab
                              } else {
                                Navigator.pushNamed(context, AppRoutes.profile);
                              }
                            },
                            child: Hero(
                              tag: 'student_avatar',
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.accentGold,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(_student.avatarUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textOnNavySubtle,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _student.fullName,
                                  style: AppTextStyles.headlineMedium.copyWith(
                                    color: AppColors.textOnNavy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Class ${_student.className} • Section ${_student.section}',
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.textOnNavy,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Roll No. ${_student.rollNumber}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textOnNavySubtle,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Summary Metrics Cards Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  StatBadge(
                    label: 'Attendance',
                    value: '${_attendancePercentage.toStringAsFixed(0)}%',
                    icon: Icons.pie_chart_rounded,
                    color: AppColors.success,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.attendance),
                  ),
                  const SizedBox(width: 10),
                  StatBadge(
                    label: 'Pending HW',
                    value: '$_pendingHomeworkCount',
                    icon: Icons.assignment_late_rounded,
                    color: AppColors.warning,
                    onTap: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(2);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.homework);
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  StatBadge(
                    label: 'Upcoming Exams',
                    value: '$_upcomingExamsCount',
                    icon: Icons.timer_rounded,
                    color: AppColors.accentBlue,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.exams),
                  ),
                  const SizedBox(width: 10),
                  StatBadge(
                    label: 'Notices',
                    value: '${_latestNotices.length}',
                    icon: Icons.campaign_rounded,
                    color: AppColors.error,
                    onTap: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(3);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.notices);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Quick Actions Grid Header
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Quick Actions',
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            ),
          ),

          // Quick Action 8 Icon Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppCard(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionItem(
                          icon: Icons.how_to_reg_rounded,
                          label: 'Attendance',
                          color: AppColors.success,
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.attendance),
                        ),
                        _buildActionItem(
                          icon: Icons.menu_book_rounded,
                          label: 'Homework',
                          color: AppColors.mathColor,
                          onTap: () {
                            if (widget.onNavigateTab != null) {
                              widget.onNavigateTab!(2);
                            } else {
                              Navigator.pushNamed(context, AppRoutes.homework);
                            }
                          },
                        ),
                        _buildActionItem(
                          icon: Icons.calendar_month_rounded,
                          label: 'Timetable',
                          color: AppColors.accentBlue,
                          onTap: () {
                            if (widget.onNavigateTab != null) {
                              widget.onNavigateTab!(1);
                            } else {
                              Navigator.pushNamed(context, AppRoutes.timetable);
                            }
                          },
                        ),
                        _buildActionItem(
                          icon: Icons.military_tech_rounded,
                          label: 'Results',
                          color: AppColors.accentGold,
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.results),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionItem(
                          icon: Icons.timer_outlined,
                          label: 'Exams',
                          color: AppColors.chemistryColor,
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.exams),
                        ),
                        _buildActionItem(
                          icon: Icons.announcement_rounded,
                          label: 'Notices',
                          color: AppColors.englishColor,
                          onTap: () {
                            if (widget.onNavigateTab != null) {
                              widget.onNavigateTab!(3);
                            } else {
                              Navigator.pushNamed(context, AppRoutes.notices);
                            }
                          },
                        ),
                        _buildActionItem(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'Fees',
                          color: AppColors.computerColor,
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.fees),
                        ),
                        _buildActionItem(
                          icon: Icons.contact_phone_rounded,
                          label: 'Contact',
                          color: AppColors.sportsColor,
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.contact),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Today's Schedule Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "Today's Schedule",
              actionTitle: 'Full Timetable',
              onActionTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1);
                } else {
                  Navigator.pushNamed(context, AppRoutes.timetable);
                }
              },
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            ),
          ),

          // Today's classes list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final slot = _todaySchedule[index];
                return TimetableCard(
                  slot: slot,
                  isCurrent: index == 0,
                );
              },
              childCount: _todaySchedule.length,
            ),
          ),

          // Latest Notices Section
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Latest Notices',
              actionTitle: 'View All',
              onActionTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3);
                } else {
                  Navigator.pushNamed(context, AppRoutes.notices);
                }
              },
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            ),
          ),

          // Latest Notices List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final notice = _latestNotices[index];
                return NoticeCard(
                  notice: notice,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.noticeDetail,
                      arguments: notice,
                    );
                  },
                );
              },
              childCount: _latestNotices.length,
            ),
          ),

          // Bottom Spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
