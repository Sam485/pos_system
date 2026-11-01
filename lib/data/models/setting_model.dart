class SettingsModel {
  final double taxRate;
  final bool applySalesTax;
  final bool requireApproval;
  final String? receiptFooter;
  final bool showLogo;
  final bool showTaxBreakdown;
  final bool offerEmailReceipts;
  final bool autoPrintReceipts;

  SettingsModel({
    required this.taxRate,
    required this.applySalesTax,
    required this.requireApproval,
    this.receiptFooter,
    this.showLogo = true,
    this.showTaxBreakdown = true,
    this.offerEmailReceipts = true,
    this.autoPrintReceipts = false,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 0.10,
      applySalesTax: json['apply_sales_tax'] as bool? ?? true,
      requireApproval: json['require_approval'] as bool? ?? true,
      receiptFooter: json['receipt_footer'] as String?,
      showLogo: json['show_logo'] as bool? ?? true,
      showTaxBreakdown: json['show_tax'] as bool? ?? true,
      offerEmailReceipts: json['offer_email'] as bool? ?? true,
      autoPrintReceipts: json['auto_print'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tax_rate': taxRate,
      'apply_sales_tax': applySalesTax,
      'require_approval': requireApproval,
      'receipt_footer': receiptFooter,
      'show_logo': showLogo,
      'show_tax': showTaxBreakdown,
      'offer_email': offerEmailReceipts,
      'auto_print': autoPrintReceipts,
    };
  }

  SettingsModel copyWith({
    double? taxRate,
    bool? applySalesTax,
    bool? requireApproval,
    String? receiptFooter,
    bool? showLogo,
    bool? showTaxBreakdown,
    bool? offerEmailReceipts,
    bool? autoPrintReceipts,
  }) {
    return SettingsModel(
      taxRate: taxRate ?? this.taxRate,
      applySalesTax: applySalesTax ?? this.applySalesTax,
      requireApproval: requireApproval ?? this.requireApproval,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      showLogo: showLogo ?? this.showLogo,
      showTaxBreakdown: showTaxBreakdown ?? this.showTaxBreakdown,
      offerEmailReceipts: offerEmailReceipts ?? this.offerEmailReceipts,
      autoPrintReceipts: autoPrintReceipts ?? this.autoPrintReceipts,
    );
  }
}
