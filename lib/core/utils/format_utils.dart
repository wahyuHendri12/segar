const _monthNamesId = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

const _weekdayNamesId = <String>[
  'Sen',
  'Sel',
  'Rab',
  'Kam',
  'Jum',
  'Sab',
  'Min',
];

/// Short Indonesian date, e.g. "9 Nov 2026".
String formatDateId(DateTime date) {
  return '${date.day} ${_monthNamesId[date.month - 1]} ${date.year}';
}

/// Short Indonesian month, e.g. "Nov".
String formatMonthShort(DateTime date) => _monthNamesId[date.month - 1];

/// Short Indonesian weekday, e.g. "Sen".
String formatWeekdayShort(DateTime date) => _weekdayNamesId[date.weekday - 1];

/// Quantity without an unnecessary decimal part, using an Indonesian comma.
String formatQuantity(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(1).replaceAll('.', ',');
}

/// Rupiah without decimals, e.g. 12500 -> "Rp12.500".
String formatRupiah(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();

  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[index]);
  }

  return '${negative ? '-' : ''}Rp$buffer';
}

/// Stable yyyy-MM-dd key used for once-per-day preferences.
String dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// 24-hour clock label with an Indonesian dot, e.g. "08.00".
String formatClock(int hour, int minute) {
  final paddedHour = hour.toString().padLeft(2, '0');
  final paddedMinute = minute.toString().padLeft(2, '0');
  return '$paddedHour.$paddedMinute';
}
