import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'admin_home_screen.dart';
import 'admin_directory_screen.dart';
import 'admin_fee_overview_screen.dart';
import 'admin_notice_manager_screen.dart';
import 'admin_settings_screen.dart';

class AdminMainLayoutScreen extends StatefulWidget {
  final int initialIndex;

  const AdminMainLayoutScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminMainLayoutScreen> createState() => _AdminMainLayoutScreenState();
}

class _AdminMainLayoutScreenState extends State<AdminMainLayoutScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      AdminHomeScreen(onNavigateTab: _onTabChanged),
      const AdminDirectoryScreen(),
      const AdminFeeOverviewScreen(),
      const AdminNoticeManagerScreen(),
      const AdminSettingsScreen(),
    ];

    final navItems = [
      {'icon': Icons.dashboard_outlined, 'active': Icons.dashboard_rounded, 'label': 'Overview'},
      {'icon': Icons.people_outline_rounded, 'active': Icons.people_rounded, 'label': 'Directory'},
      {'icon': Icons.account_balance_wallet_outlined, 'active': Icons.account_balance_wallet_rounded, 'label': 'Finance'},
      {'icon': Icons.campaign_outlined, 'active': Icons.campaign_rounded, 'label': 'Circulars'},
      {'icon': Icons.admin_panel_settings_outlined, 'active': Icons.admin_panel_settings_rounded, 'label': 'Admin'},
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: AppColors.surfaceSubtle, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = index == _currentIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabChanged(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryNavy.withOpacity(0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? (item['active'] as IconData) : (item['icon'] as IconData),
                            size: 22,
                            color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['label'] as String,
                            style: AppTextStyles.labelSmall.copyWith(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppColors.primaryNavy : AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
