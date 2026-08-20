import 'package:flutter/material.dart';
import '../../models/result_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_header.dart';
import '../../repositories/mock_school_repository.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final _repository = MockSchoolRepository();
  List<ExamResultModel> _results = [];
  int _selectedResultIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    final list = await _repository.getExamResults();
    if (!mounted) return;
    setState(() {
      _results = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_results.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Academic Results')),
        body: const Center(child: Text('No results published yet.')),
      );
    }

    final activeResult = _results[_selectedResultIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Academic Report Card'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Term Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_results.length, (index) {
                  final isSelected = index == _selectedResultIndex;
                  final item = _results[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(item.examTitle),
                      selected: isSelected,
                      selectedColor: AppColors.primaryNavy,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedResultIndex = index;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Hero Report Card Summary
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
                            activeResult.academicYear,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textOnNavySubtle,
                            ),
                          ),
                          Text(
                            activeResult.examTitle,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Grade ${activeResult.overallGrade}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreMetric(
                        'Percentage',
                        '${activeResult.overallPercentage.toStringAsFixed(1)}%',
                        AppColors.success,
                      ),
                      _buildScoreMetric(
                        'Total Marks',
                        '${activeResult.totalObtained.toInt()} / ${activeResult.maxPossible.toInt()}',
                        Colors.white,
                      ),
                      _buildScoreMetric(
                        'Class Rank',
                        '#${activeResult.classRank} / ${activeResult.totalStudentsInClass}',
                        AppColors.accentGoldLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Subject Breakdown Section
            const SectionHeader(
              title: 'Subject-Wise Marks & Grades',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),

            ...activeResult.subjects.map((sub) {
              final pct = sub.percentage;
              return AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            sub.subjectName,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryNavy.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Grade ${sub.grade}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primaryNavy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${sub.marksObtained.toInt()}/${sub.totalMarks.toInt()}',
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.surfaceSecondary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          pct >= 90
                              ? AppColors.success
                              : (pct >= 75
                                  ? AppColors.accentBlue
                                  : AppColors.warning),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Class Avg: ${sub.classAverage.toInt()}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          sub.remarks,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // Teacher / Principal Remarks Box
            AppCard(
              padding: const EdgeInsets.all(18),
              color: AppColors.surfaceSecondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.rate_review_outlined,
                          size: 18, color: AppColors.primaryNavy),
                      SizedBox(width: 8),
                      Text(
                        'Class Teacher & Principal Remarks',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    activeResult.teacherRemarks,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Published on: ${activeResult.publishedDate}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Verified Digital Copy',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.success,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textOnNavySubtle,
          ),
        ),
      ],
    );
  }
}
