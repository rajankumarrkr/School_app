import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/user_role_model.dart';
import '../../repositories/mock_school_repository.dart';
import '../../widgets/custom_button.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  final MockSchoolRepository _repository = MockSchoolRepository();
  String _selectedClass = '10';
  String _selectedSection = 'A';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<TeacherAttendanceStudent> _students = [];

  final List<String> _classes = ['9', '10', '11', '12'];
  final List<String> _sections = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    final list = await _repository.getStudentsForAttendance(_selectedClass, _selectedSection);
    setState(() {
      _students = list;
      _isLoading = false;
    });
  }

  void _markAll(AttendanceStatus status) {
    setState(() {
      for (var s in _students) {
        s.status = status;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == AttendanceStatus.present
              ? 'All students marked Present'
              : 'All students status updated',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitAttendance() async {
    setState(() => _isSubmitting = true);
    await _repository.submitClassAttendance(
      _selectedClass,
      _selectedSection,
      _selectedDate,
      _students,
    );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: AppColors.success),
            SizedBox(width: 8),
            Text('Attendance Submitted'),
          ],
        ),
        content: Text(
          'Daily attendance for Class $_selectedClass-$_selectedSection (${_students.where((s) => s.status == AttendanceStatus.present).length}/${_students.length} Present) has been saved to the school database.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  int get _presentCount => _students.where((s) => s.status == AttendanceStatus.present).length;
  int get _absentCount => _students.where((s) => s.status == AttendanceStatus.absent).length;
  int get _lateCount => _students.where((s) => s.status == AttendanceStatus.late).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Class Attendance Register',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            onPressed: _loadStudents,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Bar (Class, Section, Date)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surface,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Class Dropdown
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.surfaceSubtle),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedClass,
                              isExpanded: true,
                              items: _classes.map((c) => DropdownMenuItem(
                                value: c,
                                child: Text('Class $c', style: AppTextStyles.labelMedium),
                              )).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedClass = val);
                                  _loadStudents();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Section Dropdown
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.surfaceSubtle),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedSection,
                              isExpanded: true,
                              items: _sections.map((s) => DropdownMenuItem(
                                value: s,
                                child: Text('Section $s', style: AppTextStyles.labelMedium),
                              )).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedSection = val);
                                  _loadStudents();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Date Pill
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2025),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.surfaceSubtle),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.accentBlue),
                              const SizedBox(width: 6),
                              Text(
                                '${_selectedDate.day}/${_selectedDate.month}',
                                style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Quick Stats & Mark All Action
                  Row(
                    children: [
                      _buildChipCount('Present', _presentCount, AppColors.success, AppColors.successLight),
                      const SizedBox(width: 8),
                      _buildChipCount('Absent', _absentCount, AppColors.error, AppColors.errorLight),
                      const SizedBox(width: 8),
                      _buildChipCount('Late', _lateCount, AppColors.warning, AppColors.warningLight),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _markAll(AttendanceStatus.present),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.done_all_rounded, size: 16, color: AppColors.accentBlue),
                        label: Text(
                          'All Present',
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
            ),

            // Student List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _students.length,
                      itemBuilder: (context, index) {
                        final student = _students[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: student.status == AttendanceStatus.absent
                                  ? AppColors.error.withOpacity(0.3)
                                  : AppColors.surfaceSubtle,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(student.avatarUrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.fullName,
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'Roll No: ${student.rollNumber} • ${student.studentId}',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              // 3-state switcher
                              _buildStatusToggle(student),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Bottom Submit Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: CustomButton(
                text: 'Save Attendance ($_presentCount/${_students.length} Present)',
                isLoading: _isSubmitting,
                onPressed: _submitAttendance,
                icon: Icons.save_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipCount(String label, int count, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggle(TeacherAttendanceStudent student) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildChoiceChip(
          'P',
          student.status == AttendanceStatus.present,
          AppColors.success,
          () => setState(() => student.status = AttendanceStatus.present),
        ),
        const SizedBox(width: 4),
        _buildChoiceChip(
          'A',
          student.status == AttendanceStatus.absent,
          AppColors.error,
          () => setState(() => student.status = AttendanceStatus.absent),
        ),
        const SizedBox(width: 4),
        _buildChoiceChip(
          'L',
          student.status == AttendanceStatus.late,
          AppColors.warning,
          () => setState(() => student.status = AttendanceStatus.late),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String letter, bool isSelected, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColors.surfaceSubtle,
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
