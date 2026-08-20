import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/attendance_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';
import '../../repositories/mock_school_repository.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _repository = MockSchoolRepository();
  AttendanceSummaryModel? _summary;
  bool _isLoading = true;
  DateTime _selectedMonth = DateTime(2026, 8, 1);

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final summary = await _repository.getAttendanceSummary();
    if (!mounted) return;
    setState(() {
      _summary = summary;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _summary == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final summary = _summary!;
    final monthFormat = DateFormat('MMMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Attendance Dashboard'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Circular Indicator Card
            AppCard(
              padding: const EdgeInsets.all(20),
              gradient: AppColors.navyHeroGradient,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Session 2026-27',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textOnNavySubtle,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Overall Attendance',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          'Eligible for Exams',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.successLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Large circular meter
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: CircularProgressIndicator(
                            value: summary.overallPercentage / 100,
                            strokeWidth: 12,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.success,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${summary.overallPercentage.toStringAsFixed(1)}%',
                              style: AppTextStyles.displayMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Present Ratio',
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
                  const SizedBox(height: 24),
                  // Detailed Metric Pills
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeroStat('138', 'Present', AppColors.success),
                        _buildHeroStat('12', 'Absent', AppColors.error),
                        _buildHeroStat('150', 'Working Days', Colors.white),
                        _buildHeroStat('24', 'Holidays', AppColors.accentGoldLight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Monthly Calendar Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Log',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.surfaceSubtle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 13, color: AppColors.primaryNavy),
                      const SizedBox(width: 6),
                      Text(
                        monthFormat.format(_selectedMonth),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primaryNavy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Calendar Visualizer Grid Card
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Weekday headers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _CalendarHeaderCell('M'),
                      _CalendarHeaderCell('T'),
                      _CalendarHeaderCell('W'),
                      _CalendarHeaderCell('T'),
                      _CalendarHeaderCell('F'),
                      _CalendarHeaderCell('S'),
                      _CalendarHeaderCell('S', isWeekend: true),
                    ],
                  ),
                  const Divider(height: 16),
                  // Calendar 31-day sample grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: 31,
                    itemBuilder: (context, index) {
                      final dayNum = index + 1;
                      final isSunday = (index % 7 == 6);
                      final isAbsent = (dayNum == 7 || dayNum == 19);
                      final isHoliday = (dayNum == 15 || dayNum == 26);
                      final isFuture = dayNum > 20;

                      Color cellBg;
                      Color cellText;
                      Border? border;

                      if (isFuture) {
                        cellBg = AppColors.surfaceSecondary;
                        cellText = AppColors.textMuted;
                      } else if (isSunday || isHoliday) {
                        cellBg = AppColors.warningLight;
                        cellText = AppColors.warning;
                      } else if (isAbsent) {
                        cellBg = AppColors.errorLight;
                        cellText = AppColors.error;
                      } else {
                        cellBg = AppColors.successLight;
                        cellText = AppColors.success;
                      }

                      if (dayNum == 20) {
                        border = Border.all(color: AppColors.accentBlue, width: 2);
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: cellBg,
                          borderRadius: BorderRadius.circular(8),
                          border: border,
                        ),
                        child: Center(
                          child: Text(
                            '$dayNum',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: cellText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('Present', AppColors.success),
                      _buildLegendItem('Absent', AppColors.error),
                      _buildLegendItem('Holiday/Sun', AppColors.warning),
                      _buildLegendItem('Upcoming', AppColors.textMuted),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Subject-Wise Attendance Breakdown
            const SectionHeader(
              title: 'Subject-Wise Attendance',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),

            ...summary.subjectAttendance.map((sub) {
              final pct = sub.percentage;
              return AppCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sub.subjectName,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${sub.attendedClasses}/${sub.totalClasses} Classes',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${pct.toStringAsFixed(0)}%',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: pct >= 75
                                    ? AppColors.success
                                    : (pct >= 60
                                        ? AppColors.warning
                                        : AppColors.error),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (pct / 100).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceSecondary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          pct >= 75
                              ? AppColors.success
                              : (pct >= 60
                                  ? AppColors.warning
                                  : AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textOnNavySubtle,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CalendarHeaderCell extends StatelessWidget {
  final String title;
  final bool isWeekend;

  const _CalendarHeaderCell(this.title, {this.isWeekend = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.labelSmall.copyWith(
        fontWeight: FontWeight.w800,
        color: isWeekend ? AppColors.error : AppColors.textSecondary,
      ),
    );
  }
}
