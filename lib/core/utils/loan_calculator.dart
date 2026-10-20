import 'dart:math' as math;

/// Annuity loan: equal monthly payments.
class LoanCalculator {
  const LoanCalculator._();

  /// Monthly payment for borrowing [principal] over [months] at
  /// [annualRatePercent] per year. A zero rate splits the principal evenly.
  static double monthlyPayment({
    required double principal,
    required int months,
    required double annualRatePercent,
  }) {
    if (principal <= 0 || months <= 0) return 0;
    final r = annualRatePercent / 100 / 12;
    if (r == 0) return principal / months;
    final factor = math.pow(1 + r, months);
    return principal * r * factor / (factor - 1);
  }
}
