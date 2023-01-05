class DateTimeParser {
  static DateTime parse(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (error) {
      return DateTime.now();
    }
  }
}
