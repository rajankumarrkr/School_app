import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contact School'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // School Info Hero Header
            AppCard(
              padding: const EdgeInsets.all(20),
              gradient: AppColors.navyHeroGradient,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.accentGold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'WORTH RM SOLDIER',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'PUBLIC SCHOOL',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accentGoldLight,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Affiliated to CBSE • Excellence in Academics & Cadet Training',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textOnNavySubtle,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Contact Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Call School',
                    icon: Icons.phone_rounded,
                    height: 48,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dialing School Reception (+91 11 2614 8890)...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Email Desk',
                    icon: Icons.email_rounded,
                    type: ButtonType.secondary,
                    height: 48,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening email client for contact@worthrm.edu.in...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Open Campus on Maps',
              icon: Icons.map_rounded,
              type: ButtonType.outline,
              height: 48,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening Google Maps location...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Official Information Cards
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    iconColor: AppColors.error,
                    title: 'School Campus Address',
                    content:
                        'WORTH RM SOLDIER PUBLIC SCHOOL\nDefence Enclave, Sector 21, Cantonment Area\nNew Delhi, Delhi – 110010, India',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.phone_in_talk_outlined,
                    iconColor: AppColors.success,
                    title: 'Phone Numbers',
                    content:
                        'Reception: +91 11 2614 8890\nPrincipal Office: +91 11 2614 8891\nAccounts Desk: +91 11 2614 8892',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.email_outlined,
                    iconColor: AppColors.accentBlue,
                    title: 'Email Addresses',
                    content:
                        'General Inquiries: info@worthrm.edu.in\nAdmissions: admissions@worthrm.edu.in\nPrincipal: principal@worthrm.edu.in',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // School Timings Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    icon: Icons.access_time_rounded,
                    iconColor: AppColors.warning,
                    title: 'School & Assembly Timings',
                    content:
                        'Monday – Friday: 07:45 AM – 02:00 PM\nSaturday (Activity & Clubs): 08:00 AM – 01:00 PM\nSunday: Closed',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.business_center_outlined,
                    iconColor: AppColors.primaryNavy,
                    title: 'Administrative Office Hours',
                    content:
                        'Monday – Saturday: 08:30 AM – 03:30 PM\nParent Visiting Hours: 01:30 PM – 02:30 PM (With Prior Appointment)',
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

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
