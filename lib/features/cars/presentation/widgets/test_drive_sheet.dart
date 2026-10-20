import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities.dart';
import '../cubit/test_drive_cubit.dart';

Future<void> showTestDriveSheet(BuildContext context, Car car) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _TestDriveSheet(car: car),
  );
}

class _TestDriveSheet extends StatefulWidget {
  const _TestDriveSheet({required this.car});

  final Car car;

  @override
  State<_TestDriveSheet> createState() => _TestDriveSheetState();
}

class _TestDriveSheetState extends State<_TestDriveSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _name =
      TextEditingController(text: context.read<AuthCubit>().state.user);
  final _phone = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  DateTime? get _when => (_date == null || _time == null)
      ? null
      : DateTime(_date!.year, _date!.month, _date!.day, _time!.hour,
          _time!.minute);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      initialDate: _date ?? now.add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 11, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final when = _when;
    if (when == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a date and time')),
      );
      return;
    }
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await context.read<TestDriveCubit>().request(
          car: widget.car,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          date: when,
        );
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Test drive booked for ${formatDate(when)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Book a test drive',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(widget.car.title),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event_outlined),
                    label: Text(_date == null
                        ? 'Date'
                        : localizations.formatMediumDate(_date!)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.schedule_outlined),
                    label: Text(_time == null
                        ? 'Time'
                        : localizations.formatTimeOfDay(_time!)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Your name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Enter your name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '+998 90 123 45 67',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (v) {
                final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                return digits.length < 9 ? 'Enter a valid phone number' : null;
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _sending ? null : _submit,
              child: const Text('Confirm request'),
            ),
          ],
        ),
      ),
    );
  }
}
