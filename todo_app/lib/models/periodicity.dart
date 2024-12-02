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
    }
    
    // add days
    DateTime nextDate = DateTime(newYear, newMonth, original.day).add(Duration(days: days));
    
    return nextDate;
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