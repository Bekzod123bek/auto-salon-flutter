import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/loan_calculator.dart';

class LoanCalculatorCard extends StatefulWidget {
  const LoanCalculatorCard({super.key, required this.price});

  final int price;

  @override
  State<LoanCalculatorCard> createState() => _LoanCalculatorCardState();
}

class _LoanCalculatorCardState extends State<LoanCalculatorCard> {
  static const _terms = [12, 24, 36, 48, 60];

  double _downPercent = 30;
  int _months = 36;
  double _rate = 22;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final down = widget.price * _downPercent / 100;
    final loan = widget.price - down;
    final monthly = LoanCalculator.monthlyPayment(
      principal: loan,
      months: _months,
      annualRatePercent: _rate,
    );
    final totalPaid = monthly * _months + down;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate_outlined, color: scheme.primary),
                const SizedBox(width: 8),
                Text('Loan calculator',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.primary.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly payment',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(
                    formatPrice(monthly.round()),
                    key: const Key('monthly-payment'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Loan ${formatPrice(loan.round())}  •  '
                    'Total ${formatPrice(totalPaid.round())}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _label('Down payment',
                '${_downPercent.round()}%  •  ${formatPrice(down.round())}'),
            Slider(
              value: _downPercent,
              max: 90,
              divisions: 18,
              onChanged: (v) => setState(() => _downPercent = v),
            ),
            _label('Interest rate', '${_rate.toStringAsFixed(0)}% / year'),
            Slider(
              value: _rate,
              max: 36,
              divisions: 36,
              onChanged: (v) => setState(() => _rate = v),
            ),
            _label('Term', '$_months months'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final m in _terms)
                  ChoiceChip(
                    label: Text('$m'),
                    selected: m == _months,
                    onSelected: (_) => setState(() => _months = m),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Estimate only. Real terms depend on the bank.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String title, String value) => Row(
        children: [
          Text(title),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      );
}
