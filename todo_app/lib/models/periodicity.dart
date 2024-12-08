import 'dart:convert';

class Periodicity {
  final int years;
  final int months;
  final int days;

  Periodicity({
    this.years = 0,
    this.months = 0,
    this.days = 0
  });

  DateTime calculateNextOccurrence(DateTime original) {
    // next year
    int newYear = original.year + years;
    
    // next month
    int newMonth = original.month + months;
    
    // modify year based on month if necessary
    if (newMonth > 12) {
      newYear += (newMonth ~/ 12);
      newMonth = newMonth % 12;
      if (newMonth == 0) {
        newMonth = 12;
        newYear -= 1;
      }
    }

    // Handle days overflow and leap year scenarios
    int maxDay = DateTime(newYear, newMonth + 1, 0).day; // Last day of new month
    int newDay = original.day <= maxDay ? original.day : maxDay;
    
    // add days
    DateTime nextDate = DateTime(newYear, newMonth, newDay).add(Duration(days: days));
    
    return nextDate;
  }

  bool isNull() {
    return (days + months + years == 0);
  }

  /// Deserialization from json, to allow fetching data from the SQLite Database
  factory Periodicity.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return Periodicity(
      years: data['years'] ?? 0,
      months: data['months'] ?? 0,
      days: data['days'] ?? 0,
    );
  }

  /// Serialization to json, to allow data storage in the SQLite Database
  String toJson() {
    return jsonEncode({
      'years': years,
      'months': months,
      'days': days,
    });
  }

}