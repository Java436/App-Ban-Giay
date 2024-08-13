import 'package:intl/intl.dart';

String formatPrice(double price) {
  final NumberFormat formatter = NumberFormat('#,###');
  return formatter.format(price).replaceAll(',', '.') + ' ' + 'VNĐ';
}
