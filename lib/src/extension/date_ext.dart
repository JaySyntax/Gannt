import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String get months => DateFormat('MMMM').format(this);
  String get getWeekday => DateFormat('EEE').format(this);
  DateTime get toDateOnly => DateTime(year, month, day);
}
