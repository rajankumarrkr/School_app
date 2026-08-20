import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/fee_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_header.dart';
import '../../repositories/mock_school_repository.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  final _repository = MockSchoolRepository();
  FeeSummaryModel? _feeSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFees();
  }

  Future<void> _loadFees() async {
    final summary = await _repository.getFeeSummary();
    if (!mounted) return;
    setState(() {
      _feeSummary = summary;
      _isLoading = false;
    });
  }

  void _showPayFeesDemoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.payment_rounded, color: AppColors.accentBlue),
            SizedBox(width: 8),
            Text('Online Fee Payment'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Online Payment Gateway integration (Razorpay / UPI / NetBanking) will be enabled in production.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 18, color: AppColors.primaryNavy),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Outstanding Amount: ₹${_feeSummary?.totalPending.toInt() ?? 10000}',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close Demo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _feeSummary == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final summary = _feeSummary!;
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('School Fee & Invoices'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fee Summary Hero Card
            AppCard(
              padding: const EdgeInsets.all(20),
              gradient: AppColors.navyHeroGradient,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Year 2026-27',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textOnNavySubtle,
                            ),
                          ),
                          Text(
                            'Annual Tuition & Lab Fees',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: summary.totalPending == 0
                              ? AppColors.success.withOpacity(0.25)
                              : AppColors.warning.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          summary.totalPending == 0 ? 'Fully Paid' : 'Dues Pending',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: summary.totalPending == 0
                                ? AppColors.successLight
                                : AppColors.accentGoldLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeeMetric(
                        'Total Fees',
                        currencyFormat.format(summary.totalAnnualFee),
                        Colors.white,
                      ),
                      _buildFeeMetric(
                        'Paid',
                        currencyFormat.format(summary.totalPaid),
                        AppColors.success,
                      ),
                      _buildFeeMetric(
                        'Pending',
                        currencyFormat.format(summary.totalPending),
                        AppColors.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pay Fees Action Button
            CustomButton(
              text: 'Pay Outstanding Fees (${currencyFormat.format(summary.totalPending)})',
              icon: Icons.credit_card_rounded,
              onPressed: _showPayFeesDemoDialog,
            ),
            const SizedBox(height: 20),

            // Installment Breakdown Header
            const SectionHeader(
              title: 'Monthly Installments & Receipts',
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),

            ...summary.installments.map((item) {
              final isPaid = item.status == FeePaymentStatus.paid;
              return AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isPaid
                                ? AppColors.successLight
                                : AppColors.warningLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isPaid
                                ? Icons.check_circle_outline_rounded
                                : Icons.pending_actions_rounded,
                            color: isPaid
                                ? AppColors.success
                                : AppColors.warning,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.monthTitle,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isPaid
                                    ? 'Paid via ${item.paymentMode ?? "Online"}'
                                    : 'Due by ${DateFormat('dd MMM yyyy').format(item.dueDate)}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isPaid
                                      ? AppColors.textMuted
                                      : AppColors.error,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currencyFormat.format(item.amount),
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isPaid
                                    ? AppColors.successLight
                                    : AppColors.warningLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isPaid ? 'Paid' : 'Pending',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: isPaid
                                      ? AppColors.success
                                      : AppColors.warning,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isPaid && item.receiptNumber != null) ...[
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Receipt: ${item.receiptNumber}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Downloading ${item.receiptNumber}.pdf receipt...'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.receipt_long_rounded,
                                    size: 14, color: AppColors.accentBlue),
                                const SizedBox(width: 4),
                                Text(
                                  'Download Slip',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.accentBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeMetric(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          amount,
          style: AppTextStyles.headlineSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textOnNavySubtle,
          ),
        ),
      ],
    );
  }
}
