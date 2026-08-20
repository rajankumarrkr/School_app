import 'package:flutter/material.dart';
import '../../models/student_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../repositories/mock_school_repository.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  final bool isEmbedded;

  const ProfileScreen({super.key, this.isEmbedded = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _repository = MockSchoolRepository();
  late StudentModel _student;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      _student = _repository.currentStudent;
      _isLoading = false;
    });
  }

  void _showEditProfileDialog() {
    final phoneController = TextEditingController(text: _student.phone);
    final emailController = TextEditingController(text: _student.email);
    final addressController = TextEditingController(text: _student.address);
    final fatherPhoneController =
        TextEditingController(text: _student.fatherPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Contact Details',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Academic information is locked by school administration. You can update emergency contact details below.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Student Mobile Number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Student Email Address',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Parent Contact Number',
                controller: fatherPhoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_android_outlined,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Residential Address',
                controller: addressController,
                maxLines: 2,
                prefixIcon: Icons.home_outlined,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Save Changes',
                icon: Icons.check_circle_outline_rounded,
                onPressed: () async {
                  final updated = _student.copyWith(
                    phone: phoneController.text.trim(),
                    email: emailController.text.trim(),
                    address: addressController.text.trim(),
                    fatherPhone: fatherPhoneController.text.trim(),
                  );
                  await _repository.updateStudentProfile(updated);
                  if (context.mounted) {
                    Navigator.pop(context);
                    setState(() {
                      _student = updated;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully! (Local state)'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStudentSwitcherDialog() async {
    final students = await _repository.getAllStudents();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.people_alt_rounded,
                      color: AppColors.primaryNavy),
                  const SizedBox(width: 8),
                  Text(
                    'Switch Student Demo Profile',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Showing ${students.length} students enrolled at WORTH RM SOLDIER PUBLIC SCHOOL.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final s = students[index];
                  final isSelected = s.id == _student.id;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(s.avatarUrl),
                    ),
                    title: Text(
                      s.fullName,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryNavy
                            : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'ID: ${s.id} • Class ${s.className}-${s.section} • Roll ${s.rollNumber}',
                      style: AppTextStyles.bodySmall,
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded,
                            color: AppColors.success)
                        : const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: AppColors.textMuted),
                    onTap: () {
                      _repository.switchStudent(s);
                      Navigator.pop(context);
                      setState(() {
                        _student = s;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Switched to ${s.fullName}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Student Profile'),
        automaticallyImplyLeading: !widget.isEmbedded,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Switch Student',
            onPressed: _showStudentSwitcherDialog,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: _showEditProfileDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Student Header Card
            AppCard(
              padding: const EdgeInsets.all(20),
              gradient: AppColors.navyHeroGradient,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Large Avatar with Gold Border
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.accentGold,
                                width: 2.5,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(_student.avatarUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.accentGold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _student.fullName,
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Student ID: ${_student.id}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.accentGoldLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _student.houseName,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderMetric('Class', _student.className),
                        _buildHeaderMetric('Section', _student.section),
                        _buildHeaderMetric('Roll No.', _student.rollNumber),
                        _buildHeaderMetric('Blood Grp', _student.bloodGroup),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Academic & Identity Info
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_rounded,
                          size: 18, color: AppColors.primaryNavy),
                      const SizedBox(width: 8),
                      Text(
                        'Academic Details',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow('Admission Number', _student.admissionNo),
                  _buildDetailRow('Academic Session', _student.academicYear),
                  _buildDetailRow('Date of Birth', _student.dateOfBirth),
                  _buildDetailRow('Gender', _student.gender),
                  _buildDetailRow('Student Email', _student.email),
                  _buildDetailRow('Student Phone', _student.phone, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Parents & Guardian Info
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.family_restroom_rounded,
                          size: 18, color: AppColors.primaryNavy),
                      const SizedBox(width: 8),
                      Text(
                        'Parent & Guardian Details',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow("Father's Name", _student.fatherName),
                  _buildDetailRow("Father's Occupation", _student.fatherOccupation),
                  _buildDetailRow("Father's Contact", _student.fatherPhone),
                  _buildDetailRow("Mother's Name", _student.motherName),
                  _buildDetailRow("Mother's Occupation", _student.motherOccupation),
                  _buildDetailRow("Mother's Contact", _student.motherPhone),
                  _buildDetailRow("Permanent Address", _student.address, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Edit Profile Button
            CustomButton(
              text: 'Edit Profile Contact Info',
              icon: Icons.edit_note_rounded,
              type: ButtonType.outline,
              onPressed: _showEditProfileDialog,
            ),
            const SizedBox(height: 12),

            // Switch Student Demo Button
            CustomButton(
              text: 'Switch Student Demo Profile',
              icon: Icons.switch_account_rounded,
              type: ButtonType.secondary,
              onPressed: _showStudentSwitcherDialog,
            ),
            const SizedBox(height: 12),

            // Logout Button
            CustomButton(
              text: 'Log Out',
              icon: Icons.logout_rounded,
              type: ButtonType.danger,
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.white,
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

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: AppColors.surfaceSecondary),
      ],
    );
  }
}
