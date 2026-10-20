import 'package:flutter/material.dart';

import '../../../../injection.dart';
import '../../domain/car_repository.dart';
import '../../domain/entities.dart';

class CarDetailPage extends StatelessWidget {
  const CarDetailPage({super.key, required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    final specs = <(String, String)>[
      ('Year', '${car.year}'),
      ('Mileage', '${car.mileageKm} km'),
      ('Fuel', car.fuel),
      ('Transmission', car.transmission),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(car.title)),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: Color(car.colorValue),
            child: const Icon(Icons.directions_car, color: Colors.white, size: 88),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${car.price}',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                for (final (label, value) in specs)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Text(label),
                        const Spacer(),
                        Text(value,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => _TestDriveSheet(car: car),
            ),
            child: const Text('Book a test drive'),
          ),
        ),
      ),
    );
  }
}

class _TestDriveSheet extends StatefulWidget {
  const _TestDriveSheet({required this.car});

  final Car car;

  @override
  State<_TestDriveSheet> createState() => _TestDriveSheetState();
}

class _TestDriveSheetState extends State<_TestDriveSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await sl<CarRepository>().requestTestDrive(
      TestDriveRequest(
        car: widget.car,
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        date: DateTime.now().add(const Duration(days: 1)),
      ),
    );
    navigator.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Request sent. We will call you soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Test drive: ${widget.car.title}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Your name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
            ),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
              validator: (v) => (v == null || v.trim().length < 9)
                  ? 'Enter a valid phone number'
                  : null,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _submit, child: const Text('Send')),
            ),
          ],
        ),
      ),
    );
  }
}
