import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/homework_model.dart';
import '../../repositories/mock_school_repository.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class TeacherHomeworkScreen extends StatefulWidget {
  const TeacherHomeworkScreen({super.key});

  @override
  State<TeacherHomeworkScreen> createState() => _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState extends State<TeacherHomeworkScreen> {
  final MockSchoolRepository _repository = MockSchoolRepository();
  List<HomeworkModel> _homeworkList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  Future<void> _loadHomework() async {
    setState(() => _isLoading = true);
    final list = await _repository.getHomeworkList();
    setState(() {
      _homeworkList = list;
      _isLoading = false;
    });
  }

  void _showCreateHomeworkSheet() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedSubject = 'Physics';
    String selectedClass = 'Class 10-A';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 3));
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Assign New Homework',
                        style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Class & Subject Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedClass,
                          decoration: InputDecoration(
                            labelText: 'Class',
                            filled: true,
                            fillColor: AppColors.surfaceSecondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: ['Class 10-A', 'Class 10-B', 'Class 12-A', 'Class 12-B']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) => setSheetState(() => selectedClass = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedSubject,
                          decoration: InputDecoration(
                            labelText: 'Subject',
                            filled: true,
                            fillColor: AppColors.surfaceSecondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: ['Physics', 'Mathematics', 'Chemistry', 'English', 'Computer Science']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (val) => setSheetState(() => selectedSubject = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Assignment Title
                  CustomTextField(
                    label: 'Homework Title',
                    hint: 'e.g. Electromagnetic Induction Numerical Problems',
                    controller: titleController,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 14),

                  // Description
                  CustomTextField(
                    label: 'Instructions & Task Details',
                    hint: 'Mention exercises, textbook page numbers, and guidelines...',
                    controller: descController,
                    maxLines: 3,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter instructions' : null,
                  ),
                  const SizedBox(height: 14),

                  // Due Date selector
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 60)),
                      );
                      if (picked != null) {
                        setSheetState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: AppColors.accentBlue, size: 18),
                          const SizedBox(width: 10),
                          Text('Due Date: ', style: AppTextStyles.bodyMedium),
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          const Icon(Icons.edit_calendar_rounded, size: 16, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  CustomButton(
                    text: 'Publish Homework to Class',
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final teacher = _repository.getActiveTeacher();
                      final newHw = HomeworkModel(
                        id: 'HW${DateTime.now().millisecondsSinceEpoch}',
                        subject: selectedSubject,
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        teacherName: teacher?.fullName ?? 'Faculty',
                        assignedDate: DateTime.now(),
                        dueDate: selectedDate,
                        status: HomeworkStatus.pending,
                        maxMarks: 20,
                      );
                      await _repository.createHomework(newHw);
                      if (!mounted) return;
                      Navigator.pop(context);
                      _loadHomework();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Homework successfully published to class!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icons.send_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Manage Assignments',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded, color: AppColors.accentBlue),
            onPressed: _showCreateHomeworkSheet,
            tooltip: 'New Homework',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHomework,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _homeworkList.length,
                itemBuilder: (context, index) {
                  final hw = _homeworkList[index];
                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryNavy.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                hw.subject,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primaryNavy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.alarm_rounded, size: 14, color: AppColors.accentGold),
                                const SizedBox(width: 4),
                                Text(
                                  'Due: ${hw.dueDate.day}/${hw.dueDate.month}/${hw.dueDate.year}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.accentGold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          hw.title,
                          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          hw.description,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.people_alt_rounded, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Text(
                              'Submissions: 32 / 40 Students',
                              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Viewing student submissions for "${hw.title}"'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'View Submissions →',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.accentBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentBlue,
        onPressed: _showCreateHomeworkSheet,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Assign Homework', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
