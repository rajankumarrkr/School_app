import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/homework_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../repositories/mock_school_repository.dart';

class HomeworkDetailScreen extends StatefulWidget {
  final HomeworkModel homework;

  const HomeworkDetailScreen({super.key, required this.homework});

  @override
  State<HomeworkDetailScreen> createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  final _repository = MockSchoolRepository();
  final _submissionController = TextEditingController();
  late HomeworkModel _homework;
  bool _isSubmitting = false;
  String? _selectedAttachedFile;

  @override
  void initState() {
    super.initState();
    _homework = widget.homework;
  }

  @override
  void dispose() {
    _submissionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    await _repository.submitHomework(
      _homework.id,
      _submissionController.text.trim().isNotEmpty
          ? _submissionController.text.trim()
          : 'Assignment submitted on portal.',
    );
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _homework = _homework.copyWith(
        status: HomeworkStatus.completed,
        submissionNote: _submissionController.text.trim().isNotEmpty
            ? _submissionController.text.trim()
            : 'Submitted online.',
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Homework submitted successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy');
    final isCompleted = _homework.status == HomeworkStatus.completed;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assignment Details'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject & Title Card
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _homework.subject,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primaryNavy,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.successLight
                              : (_homework.status == HomeworkStatus.overdue
                                  ? AppColors.errorLight
                                  : AppColors.warningLight),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isCompleted
                              ? 'Completed'
                              : (_homework.status == HomeworkStatus.overdue
                                  ? 'Overdue'
                                  : 'Pending Submission'),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isCompleted
                                ? AppColors.success
                                : (_homework.status == HomeworkStatus.overdue
                                    ? AppColors.error
                                    : AppColors.warning),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _homework.title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  // Teacher & Date Meta
                  Row(
                    children: [
                      const Icon(Icons.person_pin_circle_outlined,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Faculty: ${_homework.teacherName}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.schedule_outlined,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Due Date: ${dateFormat.format(_homework.dueDate)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _homework.status == HomeworkStatus.overdue
                              ? AppColors.error
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.grade_outlined,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Maximum Weightage: ${_homework.maxMarks} Marks',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Instructions / Description
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions & Description',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _homework.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Teacher Attachment Reference
            if (_homework.attachmentName != null) ...[
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.picture_as_pdf_rounded,
                          color: AppColors.accentBlue, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _homework.attachmentName!,
                            style: AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Teacher Worksheet Resource (1.4 MB)',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download_rounded,
                          color: AppColors.accentBlue),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Downloading ${_homework.attachmentName}...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submission Box
            if (!isCompleted) ...[
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Submission',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Student Note / Answers summary',
                      hint: 'Describe your answers or add submission comments...',
                      controller: _submissionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 14),
                    // Attachment upload simulator
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAttachedFile = 'Rahul_HW_${_homework.subject}_AnswerSheet.pdf';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Attached Rahul_HW_AnswerSheet.pdf (Demo)'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.surfaceSubtle,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedAttachedFile != null
                                  ? Icons.check_circle_rounded
                                  : Icons.upload_file_rounded,
                              size: 20,
                              color: _selectedAttachedFile != null
                                  ? AppColors.success
                                  : AppColors.accentBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedAttachedFile ?? 'Attach Solution File (PDF / Images)',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: _selectedAttachedFile != null
                                    ? AppColors.success
                                    : AppColors.accentBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      text: 'Submit Assignment',
                      icon: Icons.send_rounded,
                      isLoading: _isSubmitting,
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
              ),
            ] else ...[
              AppCard(
                padding: const EdgeInsets.all(18),
                color: AppColors.successLight,
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assignment Completed & Verified',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _homework.submissionNote ??
                                'Submitted and received by faculty.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
