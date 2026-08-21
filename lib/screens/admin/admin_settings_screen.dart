import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../repositories/mock_school_repository.dart';
import '../../widgets/app_card.dart';
import '../../routes/app_routes.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = MockSchoolRepository().getActiveAdmin()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'School & Admin Settings',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top Admin Profile Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(admin.avatarUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      admin.fullName,
                      style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      admin.designation,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentBlue, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Admin ID: ${admin.adminId}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Institutional Information
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('School Institution Details', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 14),
                    _buildSettingRow('School Name', 'Worth RM Soldier Public School', Icons.school_rounded),
                    _buildSettingRow('CBSE Affiliation', admin.schoolAffiliationNo, Icons.verified_rounded),
                    _buildSettingRow('Current Session', admin.academicSession, Icons.event_rounded),
                    _buildSettingRow('Campus Address', 'Sector 14, Cantonment Area, New Delhi - 110010', Icons.location_on_rounded),
                    _buildSettingRow('Admin Email', admin.email, Icons.mail_outline_rounded),
                    _buildSettingRow('Central Desk', admin.phone, Icons.phone_in_talk_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // System Operations
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System & Database Control', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      context,
                      'Backup Database',
                      'Sync school records to cloud backup',
                      Icons.cloud_upload_rounded,
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cloud backup initiated successfully.')),
                      ),
                    ),
                    _buildActionItem(
                      context,
                      'SMS Gateway Settings',
                      'Configure DLT templates & sender ID',
                      Icons.message_rounded,
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('SMS Gateway status: Connected (9,420 credits remaining)')),
                      ),
                    ),
                    _buildActionItem(
                      context,
                      'Academic Session Roll-over',
                      'Promote students & initialize terms',
                      Icons.published_with_changes_rounded,
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session 2026-2027 is active.')),
                      ),
                    ),
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
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign Out from Admin Control', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(String label, String value, IconData icon) {
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

  Widget _buildActionItem(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryNavy, size: 18),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
