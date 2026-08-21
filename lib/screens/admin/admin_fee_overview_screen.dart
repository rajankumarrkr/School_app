import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';

class AdminFeeOverviewScreen extends StatelessWidget {
  const AdminFeeOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Fee Collection Analytics',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Collections Banner Card
              AppCard(
                gradient: AppColors.navyHeroGradient,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL REVENUE COLLECTED (AY 2026-27)',
                          style: TextStyle(
                            color: AppColors.accentGoldLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '86.6% ON TRACK',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '₹ 1,84,50,000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Target: ₹ 2,12,90,000 • Pending Dues: ₹ 28,40,000',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.866,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quarter Breakdown
              Text('Quarterly Collection Breakup', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _buildQuarterCards(),
              const SizedBox(height: 24),

              // Outstanding Defaulters List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Fee Defaulters (Overdue > 15 Days)', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Broadcasting fee reminder SMS to 14 defaulters...')),
                      );
                    },
                    icon: const Icon(Icons.send_to_mobile_rounded, size: 14, color: AppColors.accentBlue),
                    label: Text(
                      'Send All Alerts',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.accentBlue, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDefaultersList(context),
              const SizedBox(height: 24),

              // Recent Transactions Feed
              Text('Recent Receipts & Transactions', style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _buildRecentTransactions(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuarterCards() {
    return Row(
      children: [
        Expanded(
          child: _buildQuarterItem('Q1 (Apr - Jun)', '₹ 56.2 L', '98% Rec.', AppColors.success),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuarterItem('Q2 (Jul - Sep)', '₹ 51.8 L', '91% Rec.', AppColors.accentBlue),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildQuarterItem('Q3 (Oct - Dec)', '₹ 44.5 L', '78% Rec.', AppColors.warning),
        ),
      ],
    );
  }

  Widget _buildQuarterItem(String q, String amount, String rate, Color col) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
          const SizedBox(height: 4),
          Text(amount, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(rate, style: TextStyle(color: col, fontWeight: FontWeight.w700, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildDefaultersList(BuildContext context) {
    final defaulters = [
      {'name': 'Rohan Singh', 'class': '10-B', 'adm': 'WRM/2020/1077', 'due': '₹ 14,500', 'overdue': '22 days'},
      {'name': 'Tanvi Malhotra', 'class': '12-A', 'adm': 'WRM/2018/0642', 'due': '₹ 18,200', 'overdue': '19 days'},
      {'name': 'Karan Bedi', 'class': '9-C', 'adm': 'WRM/2021/1402', 'due': '₹ 12,000', 'overdue': '16 days'},
    ];

    return Column(
      children: defaulters.map((d) => AppCard(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d['name']!, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                  Text('${d['class']} • ${d['adm']} • Overdue: ${d['overdue']}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(d['due']!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.w800)),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fee reminder sent to parents of ${d['name']}')),
                    );
                  },
                  child: Text(
                    'Remind 🔔',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentBlue, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildRecentTransactions() {
    final txns = [
      {'student': 'Rahul Kumar (10-A)', 'rec': 'RCP-98214', 'mode': 'UPI / NetBanking', 'amount': '₹ 14,500', 'date': '20 Aug 2026'},
      {'student': 'Ananya Sharma (10-A)', 'rec': 'RCP-98213', 'mode': 'Credit Card', 'amount': '₹ 14,500', 'date': '19 Aug 2026'},
      {'student': 'Arjun Verma (10-A)', 'rec': 'RCP-98210', 'mode': 'Debit Card', 'amount': '₹ 14,500', 'date': '18 Aug 2026'},
    ];

    return Column(
      children: txns.map((t) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.surfaceSubtle),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t['student']!, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text('${t['rec']} • ${t['mode']} • ${t['date']}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            Text(
              t['amount']!,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
