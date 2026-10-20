import 'package:intl/intl.dart';

final _money = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
final _number = NumberFormat.decimalPattern('en_US');

String formatPrice(num value) => _money.format(value);

String formatKm(int km) => '${_number.format(km)} km';

String formatDate(DateTime date) => DateFormat('d MMM yyyy, HH:mm').format(date);
