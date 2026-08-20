import '../models/fee_model.dart';

class DummyFeeData {
  static FeeSummaryModel getFeeSummary() {
    return FeeSummaryModel(
      totalAnnualFee: 30000.0,
      totalDiscount: 0.0,
      installments: [
        FeeInstallmentModel(
          id: 'FEE-APR-2026',
          monthTitle: 'April 2026 (Quarter 1)',
          amount: 5000.0,
          dueDate: DateTime(2026, 4, 10),
          paidDate: DateTime(2026, 4, 5),
          status: FeePaymentStatus.paid,
          receiptNumber: 'REC-2026-04-1042',
          paymentMode: 'Net Banking / UPI',
        ),
        FeeInstallmentModel(
          id: 'FEE-MAY-2026',
          monthTitle: 'May 2026',
          amount: 5000.0,
          dueDate: DateTime(2026, 5, 10),
          paidDate: DateTime(2026, 5, 8),
          status: FeePaymentStatus.paid,
          receiptNumber: 'REC-2026-05-1042',
          paymentMode: 'Debit Card',
        ),
        FeeInstallmentModel(
          id: 'FEE-JUN-2026',
          monthTitle: 'June 2026',
          amount: 5000.0,
          dueDate: DateTime(2026, 6, 10),
          paidDate: DateTime(2026, 6, 7),
          status: FeePaymentStatus.paid,
          receiptNumber: 'REC-2026-06-1042',
          paymentMode: 'UPI AutoPay',
        ),
        FeeInstallmentModel(
          id: 'FEE-JUL-2026',
          monthTitle: 'July 2026',
          amount: 5000.0,
          dueDate: DateTime(2026, 7, 10),
          paidDate: DateTime(2026, 7, 9),
          status: FeePaymentStatus.paid,
          receiptNumber: 'REC-2026-07-1042',
          paymentMode: 'Net Banking',
        ),
        FeeInstallmentModel(
          id: 'FEE-AUG-2026',
          monthTitle: 'August 2026',
          amount: 5000.0,
          dueDate: DateTime(2026, 8, 25),
          paidDate: null,
          status: FeePaymentStatus.pending,
          receiptNumber: null,
          paymentMode: null,
        ),
        FeeInstallmentModel(
          id: 'FEE-SEP-2026',
          monthTitle: 'September 2026',
          amount: 5000.0,
          dueDate: DateTime(2026, 9, 10),
          paidDate: null,
          status: FeePaymentStatus.pending,
          receiptNumber: null,
          paymentMode: null,
        ),
      ],
    );
  }
}
