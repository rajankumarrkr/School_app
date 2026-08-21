import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/student_model.dart';
import '../../models/user_role_model.dart';
import '../../repositories/mock_school_repository.dart';
import '../../widgets/app_card.dart';

class AdminDirectoryScreen extends StatefulWidget {
  const AdminDirectoryScreen({super.key});

  @override
  State<AdminDirectoryScreen> createState() => _AdminDirectoryScreenState();
}

class _AdminDirectoryScreenState extends State<AdminDirectoryScreen> {
  final MockSchoolRepository _repository = MockSchoolRepository();
  int _selectedDirectoryType = 0; // 0: Students, 1: Teachers
  String _searchQuery = '';
  String _selectedClassFilter = 'All';

  List<StudentModel> _students = [];
  List<TeacherModel> _teachers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDirectoryData();
  }

  Future<void> _loadDirectoryData() async {
    setState(() => _isLoading = true);
    final sList = await _repository.getAllStudents();
    final tList = await _repository.getAllTeachers();
    setState(() {
      _students = sList;
      _teachers = tList;
      _isLoading = false;
    });
  }

  List<StudentModel> get _filteredStudents {
    return _students.where((s) {
      final matchesSearch = s.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.admissionNo.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesClass = _selectedClassFilter == 'All' || s.className == _selectedClassFilter;
      return matchesSearch && matchesClass;
    }).toList();
  }

  List<TeacherModel> get _filteredTeachers {
    return _teachers.where((t) {
      return t.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.primarySubject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.employeeId.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Institutional Directory',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Directory Segmented Control
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surface,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSegmentButton(0, 'Students (${_students.length})', Icons.school_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSegmentButton(1, 'Faculty & Staff (${_teachers.length})', Icons.badge_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search Bar
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: _selectedDirectoryType == 0
                          ? 'Search student name, ID or admission no...'
                          : 'Search teacher name, subject or ID...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () => setState(() => _searchQuery = ''),
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.surfaceSecondary,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  // Class filter (only if Students selected)
                  if (_selectedDirectoryType == 0) ...[
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['All', '9', '10', '11', '12'].map((c) {
                          final isSel = _selectedClassFilter == c;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(c == 'All' ? 'All Classes' : 'Class $c'),
                              selected: isSel,
                              onSelected: (_) => setState(() => _selectedClassFilter = c),
                              selectedColor: AppColors.primaryNavy.withOpacity(0.12),
                              checkmarkColor: AppColors.primaryNavy,
                              labelStyle: TextStyle(
                                color: isSel ? AppColors.primaryNavy : AppColors.textSecondary,
                                fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),

            // Content List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _selectedDirectoryType == 0
                      ? _buildStudentList()
                      : _buildTeacherList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(int index, String label, IconData icon) {
    final isSelected = _selectedDirectoryType == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDirectoryType = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNavy : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    final list = _filteredStudents;
    if (list.isEmpty) {
      return const Center(child: Text('No students match your query.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final s = list[index];
        return AppCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(s.avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.fullName,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Class ${s.className}-${s.section} • Roll ${s.rollNumber} • ${s.admissionNo}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Parent: ${s.fatherName} (${s.fatherPhone})',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline_rounded, color: AppColors.accentBlue),
                onPressed: () {
                  _showStudentInfoModal(s);
                },
                tooltip: 'Details',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeacherList() {
    final list = _filteredTeachers;
    if (list.isEmpty) {
      return const Center(child: Text('No teachers match your query.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final t = list[index];
        return AppCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(t.avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.fullName,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${t.designation} • ${t.employeeId}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Subject: ${t.primarySubject} | ${t.phone}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentBlue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call_rounded, color: AppColors.success),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling faculty ${t.fullName} at ${t.phone}')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStudentInfoModal(StudentModel s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 28, backgroundImage: NetworkImage(s.avatarUrl)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.fullName, style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w700)),
                      Text('Class ${s.className}-${s.section} • Roll: ${s.rollNumber}', style: AppTextStyles.bodySmall),
                      Text('Adm No: ${s.admissionNo}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text('Father: ${s.fatherName} (${s.fatherOccupation})', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 4),
            Text('Phone: ${s.fatherPhone}', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 4),
            Text('House: ${s.houseName}', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 4),
            Text('Address: ${s.address}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
