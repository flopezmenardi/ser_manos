import 'package:cloud_firestore/cloud_firestore.dart';

class DateUtils {
  /// Converts a DD-MM-YYYY or DD/MM/YYYY string to a Firestore Timestamp
  static Timestamp? stringToTimestamp(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    
    try {
      // Normalize the separator (handle both - and /)
      final normalizedString = dateString.replaceAll('/', '-');
      
      // Parse DD-MM-YYYY format
      final parts = normalizedString.split('-');
      if (parts.length != 3) return null;
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final dateTime = DateTime(year, month, day);
      return Timestamp.fromDate(dateTime);
    } catch (e) {
      return null;
    }
  }
  
  /// Converts a Firestore Timestamp to a DD-MM-YYYY string
  static String timestampToString(Timestamp? timestamp) {
    if (timestamp == null) return '';
    
    final dateTime = timestamp.toDate();
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    
    return '$day-$month-$year';
  }
  
  /// Validates a DD-MM-YYYY string format
  static bool isValidDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return false;
    
    final regex = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');
    if (!regex.hasMatch(dateString)) return false;
    
    try {
      final parts = dateString.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      // Check if it's a valid date
      final dateTime = DateTime(year, month, day);
      return dateTime.day == day && 
             dateTime.month == month && 
             dateTime.year == year;
    } catch (e) {
      return false;
    }
  }
}
