

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

}