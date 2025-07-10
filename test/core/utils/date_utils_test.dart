import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ser_manos/core/utils/date_utils.dart';

void main() {
  group('DateUtils', () {
    test('should convert DD-MM-YYYY string to Timestamp', () {
      final result = DateUtils.stringToTimestamp('15-03-1995');
      expect(result, isNotNull);
      expect(result!.toDate().day, 15);
      expect(result.toDate().month, 3);
      expect(result.toDate().year, 1995);
    });

    test('should convert Timestamp to DD-MM-YYYY string', () {
      final timestamp = Timestamp.fromDate(DateTime(1995, 3, 15));
      final result = DateUtils.timestampToString(timestamp);
      expect(result, '15-03-1995');
    });

    test('should handle null input', () {
      expect(DateUtils.stringToTimestamp(null), isNull);
      expect(DateUtils.timestampToString(null), '');
    });

    test('should handle empty string', () {
      expect(DateUtils.stringToTimestamp(''), isNull);
    });

    test('should validate date string correctly', () {
      expect(DateUtils.isValidDateString('15-03-1995'), isTrue);
      expect(DateUtils.isValidDateString('32-03-1995'), isFalse); // Invalid day
      expect(DateUtils.isValidDateString('15-13-1995'), isFalse); // Invalid month
      expect(DateUtils.isValidDateString('15/03/1995'), isFalse); // Wrong format
      expect(DateUtils.isValidDateString(''), isFalse);
      expect(DateUtils.isValidDateString(null), isFalse);
    });
  });
}
