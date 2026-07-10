class DateHelper {
  DateHelper._();

  static String format(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}