import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities.dart';

/// Bottom sheet with the advanced filters. Returns the new filter, or `null`
/// when dismissed.
Future<CarFilter?> showFilterSheet(BuildContext context, CarFilter current) {
  return showModalBottomSheet<CarFilter>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _FilterSheet(initial: current),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});

  final CarFilter initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  static const _priceMin = 20000.0;
  static const _priceMax = 250000.0;
  static const _yearMin = 2015.0;
  static const _yearMax = 2025.0;
  static const _mileageMax = 100000.0;

  late RangeValues _price;
  late RangeValues _years;
  late double _mileage;
  late Set<FuelType> _fuels;
  late Set<Transmission> _transmissions;
  late Set<BodyType> _bodies;

  @override
  void initState() {
    super.initState();
    final f = widget.initial;
    _price = RangeValues(
      (f.minPrice ?? _priceMin).toDouble(),
      (f.maxPrice ?? _priceMax).toDouble(),
    );
    _years = RangeValues(
      (f.minYear ?? _yearMin).toDouble(),
      (f.maxYear ?? _yearMax).toDouble(),
    );
    _mileage = (f.maxMileage ?? _mileageMax).toDouble();
    _fuels = {...f.fuels};
    _transmissions = {...f.transmissions};
    _bodies = {...f.bodies};
  }

  void _reset() => setState(() {
        _price = const RangeValues(_priceMin, _priceMax);
        _years = const RangeValues(_yearMin, _yearMax);
        _mileage = _mileageMax;
        _fuels = {};
        _transmissions = {};
        _bodies = {};
      });

  CarFilter _result() {
    int? bound(double value, double limit) =>
        value == limit ? null : value.round();
    return widget.initial.copyWith(
      minPrice: () => bound(_price.start, _priceMin),
      maxPrice: () => bound(_price.end, _priceMax),
      minYear: () => bound(_years.start, _yearMin),
      maxYear: () => bound(_years.end, _yearMax),
      maxMileage: () => bound(_mileage, _mileageMax),
      fuels: _fuels,
      transmissions: _transmissions,
      bodies: _bodies,
    );
  }

  Widget _section(String title, Widget child, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              if (trailing != null)
                Text(trailing,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _chips<T>(List<T> values, Set<T> selected, String Function(T) label) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final v in values)
          FilterChip(
            label: Text(label(v)),
            selected: selected.contains(v),
            onSelected: (on) =>
                setState(() => on ? selected.add(v) : selected.remove(v)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 8),
            child: Row(
              children: [
                Text('Filters', style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                TextButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _section(
                  'Price',
                  RangeSlider(
                    values: _price,
                    min: _priceMin,
                    max: _priceMax,
                    divisions: 46,
                    onChanged: (v) => setState(() => _price = v),
                  ),
                  trailing:
                      '${formatPrice(_price.start)} – ${formatPrice(_price.end)}',
                ),
                _section(
                  'Year',
                  RangeSlider(
                    values: _years,
                    min: _yearMin,
                    max: _yearMax,
                    divisions: (_yearMax - _yearMin).round(),
                    onChanged: (v) => setState(() => _years = v),
                  ),
                  trailing: '${_years.start.round()} – ${_years.end.round()}',
                ),
                _section(
                  'Max mileage',
                  Slider(
                    value: _mileage,
                    max: _mileageMax,
                    divisions: 20,
                    onChanged: (v) => setState(() => _mileage = v),
                  ),
                  trailing: _mileage == _mileageMax
                      ? 'Any'
                      : formatKm(_mileage.round()),
                ),
                _section('Fuel',
                    _chips(FuelType.values, _fuels, (f) => f.label)),
                _section(
                    'Transmission',
                    _chips(Transmission.values, _transmissions,
                        (t) => t.label)),
                _section('Body type',
                    _chips(BodyType.values, _bodies, (b) => b.label)),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_result()),
                child: const Text('Show results'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
