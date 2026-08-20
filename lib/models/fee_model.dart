enum FeePaymentStatus { paid, pending, overdue }

class FeeInstallmentModel {
  final String id;
  final String monthTitle; // e.g. "April 2026", "May 2026"
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final FeePaymentStatus status;
  final String? receiptNumber;
  final String? paymentMode;

  const FeeInstallmentModel({
    required this.id,
    required this.monthTitle,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.receiptNumber,
    this.paymentMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthTitle': monthTitle,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'status': status.name,
      'receiptNumber': receiptNumber,
      'paymentMode': paymentMode,
    };
  }

  factory FeeInstallmentModel.fromJson(Map<String, dynamic> json) {
    return FeeInstallmentModel(
      id: json['id'] as String,
      monthTitle: json['monthTitle'] as String,
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate'] as String) : null,
      status: FeePaymentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => FeePaymentStatus.pending,
      ),
      receiptNumber: json['receiptNumber'] as String?,
      paymentMode: json['paymentMode'] as String?,
    );
  }
}

class FeeSummaryModel {
  final double totalAnnualFee;
  final double totalDiscount;
  final List<FeeInstallmentModel> installments;

  const FeeSummaryModel({
    required this.totalAnnualFee,
    this.totalDiscount = 0.0,
    required this.installments,
  });

  double get totalPaid => installments
      .where((item) => item.status == FeePaymentStatus.paid)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalPending => installments
      .where((item) => item.status != FeePaymentStatus.paid)
      .fold(0.0, (sum, item) => sum + item.amount);

  Map<String, dynamic> toJson() {
    return {
      'totalAnnualFee': totalAnnualFee,
      'totalDiscount': totalDiscount,
      'installments': installments.map((e) => e.toJson()).toList(),
    };
  }

  factory FeeSummaryModel.fromJson(Map<String, dynamic> json) {
    return FeeSummaryModel(
      totalAnnualFee: (json['totalAnnualFee'] as num).toDouble(),
      totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0.0,
      installments: (json['installments'] as List<dynamic>)
          .map((e) => FeeInstallmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
