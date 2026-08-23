import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../repositories/mock_school_repository.dart';
import '../../services/firebase_auth_service.dart';
import '../../widgets/app_card.dart';
import '../../routes/app_routes.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacher = MockSchoolRepository().getActiveTeacher()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Faculty Profile',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top Profile Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(teacher.avatarUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      teacher.fullName,
                      style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      teacher.designation,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentBlue, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${teacher.department} • ${teacher.employeeId}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Academic Details Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Academic & Teaching Info', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 14),
                    _buildInfoRow('Class Teacher', teacher.classTeacherOf, Icons.school_rounded),
                    _buildInfoRow('Primary Subject', teacher.primarySubject, Icons.menu_book_rounded),
                    _buildInfoRow('Assigned Classes', teacher.assignedClasses.join(', '), Icons.groups_rounded),
                    _buildInfoRow('Qualification', teacher.qualification, Icons.workspace_premium_rounded),
                    _buildInfoRow('Teaching Experience', teacher.experience, Icons.timeline_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Contact Details Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Information', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 14),
                    _buildInfoRow('Email Address', teacher.email, Icons.email_outlined),
                    _buildInfoRow('Official Phone', teacher.phone, Icons.phone_outlined),
                    _buildInfoRow('Faculty Room', 'Science Block, Room SF-04', Icons.location_on_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await FirebaseAuthService().signOut();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign Out from Faculty Account', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.accentBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
