import 'package:flutter_test/flutter_test.dart';
import 'package:segar/core/utils/format_utils.dart';

void main() {
  group('formatDateId', () {
    test('formats day, short month and year', () {
      expect(formatDateId(DateTime(2026, 11, 9)), '9 Nov 2026');
      expect(formatDateId(DateTime(2026, 1, 1)), '1 Jan 2026');
      expect(formatDateId(DateTime(2026, 5, 31)), '31 Mei 2026');
    });
  });

  group('formatMonthShort', () {
    test('uses Indonesian short month names', () {
      expect(formatMonthShort(DateTime(2026, 1, 15)), 'Jan');
      expect(formatMonthShort(DateTime(2026, 5, 15)), 'Mei');
      expect(formatMonthShort(DateTime(2026, 8, 15)), 'Agu');
      expect(formatMonthShort(DateTime(2026, 12, 15)), 'Des');
    });
  });

  group('formatWeekdayShort', () {
    test('starts the week on Monday', () {
      expect(formatWeekdayShort(DateTime(2026, 11, 9)), 'Sen');
      expect(formatWeekdayShort(DateTime(2026, 11, 13)), 'Jum');
      expect(formatWeekdayShort(DateTime(2026, 11, 15)), 'Min');
    });
  });

  group('formatQuantity', () {
    test('drops the decimal part for whole numbers', () {
      expect(formatQuantity(2), '2');
      expect(formatQuantity(2.0), '2');
    });

    test('uses an Indonesian decimal comma', () {
      expect(formatQuantity(1.5), '1,5');
      expect(formatQuantity(0.25), '0,3');
    });
  });

  group('formatRupiah', () {
    test('groups thousands with dots', () {
      expect(formatRupiah(0), 'Rp0');
      expect(formatRupiah(5000), 'Rp5.000');
      expect(formatRupiah(12500), 'Rp12.500');
      expect(formatRupiah(1250000), 'Rp1.250.000');
    });

    test('keeps a negative sign in front', () {
      expect(formatRupiah(-5000), '-Rp5.000');
    });
  });

  group('dateKey', () {
    test('uses a zero-padded yyyy-MM-dd key', () {
      expect(dateKey(DateTime(2026, 1, 2)), '2026-01-02');
      expect(dateKey(DateTime(2026, 11, 10)), '2026-11-10');
    });
  });

  group('formatClock', () {
    test('uses a 24-hour clock with an Indonesian dot', () {
      expect(formatClock(8, 0), '08.00');
      expect(formatClock(21, 5), '21.05');
      expect(formatClock(0, 30), '00.30');
    });
  });
}
