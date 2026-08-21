import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../repositories/mock_school_repository.dart';
import '../../routes/app_routes.dart';

class AdminHomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const AdminHomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final admin = MockSchoolRepository().getActiveAdmin()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Header
              _buildAdminHeader(context, admin),
              const SizedBox(height: 20),

              // KPI Metric Cards Grid
              _buildKpiMetricsGrid(context),
              const SizedBox(height: 24),

              // Quick Actions Grid
              Text(
                'Administrative Control Panel',
                style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildControlGrid(context),
              const SizedBox(height: 24),

              // Fee Collection Snapshot
              _buildFeeSnapshotCard(context),
              const SizedBox(height: 24),

              // Recent School Activity / Notices
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Official Circulars',
                    style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab?.call(3), // Notices tab
                    child: Text(
                      'Manage All',
                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildRecentCirculars(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context, dynamic admin) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.navyHeroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentGold, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(admin.avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'SCHOOL ADMINISTRATION',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.accentGoldLight,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 20),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          tooltip: 'Logout',
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      admin.fullName,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${admin.designation} • ${admin.schoolAffiliationNo}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetricsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _buildMetricCard(
          '1,420',
          'Total Enrolled Students',
          '96.4% Att. Today',
          Icons.school_rounded,
          AppColors.accentBlue,
          AppColors.infoLight,
        ),
        _buildMetricCard(
          '78',
          'Faculty Members',
          '76 Present (2 Leave)',
          Icons.badge_rounded,
          AppColors.sportsColor,
          AppColors.warningLight,
        ),
        _buildMetricCard(
          '₹18.45 L',
          'Fee Collection (Aug)',
          '86.6% Collected',
          Icons.account_balance_wallet_rounded,
          AppColors.success,
          AppColors.successLight,
        ),
        _buildMetricCard(
          '18 / 18',
          'School Transport',
          'All Buses GPS Active',
          Icons.directions_bus_rounded,
          AppColors.mathColor,
          AppColors.surfaceSecondary,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String value,
    String title,
    String badge,
    IconData icon,
    Color color,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlGrid(BuildContext context) {
    final actions = [
      {
        'title': 'Student Directory',
        'desc': 'Class-wise Rosters',
        'icon': Icons.groups_rounded,
        'color': AppColors.accentBlue,
        'tab': 1,
      },
      {
        'title': 'Staff & Faculty',
        'desc': 'Teacher Records',
        'icon': Icons.co_present_rounded,
        'color': AppColors.chemistryColor,
        'tab': 1,
      },
      {
        'title': 'Fee Overviews',
        'desc': 'Dues & Receipts',
        'icon': Icons.receipt_long_rounded,
        'color': AppColors.success,
        'tab': 2,
      },
      {
        'title': 'Publish Circular',
        'desc': 'Broadcast Notice',
        'icon': Icons.campaign_rounded,
        'color': AppColors.accentGold,
        'tab': 3,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        final iconColor = item['color'] as Color;

        return AppCard(
          padding: const EdgeInsets.all(14),
          onTap: () {
            final tabIndex = item['tab'] as int;
            onNavigateTab?.call(tabIndex);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item['icon'] as IconData, color: iconColor, size: 20),
              ),
              const Spacer(),
              Text(
                item['title'] as String,
                style: AppTextStyles.headlineSmall.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                item['desc'] as String,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeeSnapshotCard(BuildContext context) {
    return AppCard(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_rounded, color: AppColors.accentGold, size: 20),
              const SizedBox(width: 8),
              Text(
                'Academic Year Fee Summary',
                style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Collected', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: 2),
                    Text('₹ 1,84,50,000', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pending Dues', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                    const SizedBox(height: 2),
                    Text('₹ 28,40,000', style: AppTextStyles.headlineSmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.866,
              backgroundColor: AppColors.surfaceSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCirculars(BuildContext context) {
    final circulars = [
      {'title': 'Annual Sports Meet 2026 Schedule & Guidelines', 'date': '20 Aug 2026', 'target': 'All Students & Faculty'},
      {'title': 'CBSE Board Examination Registration Final Notice', 'date': '18 Aug 2026', 'target': 'Class 10 & 12'},
      {'title': 'Independence Day Parade Commendations & Awards', 'date': '16 Aug 2026', 'target': 'School Wide'},
    ];

    return Column(
      children: circulars.map((c) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceSubtle),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryNavy.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.campaign_outlined, color: AppColors.primaryNavy, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c['title']!,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${c['date']} • ${c['target']}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
