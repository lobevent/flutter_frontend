import 'package:flutter_frontend/l10n/app_strings.dart';

class DateTimeConverter{



  static String convertToStringWithMonthName(DateTime date){
    String month = RecurringStrings.Months[date.month-1];
    String day = date.day.toString();
    String time = date.hour.toString() + ":" + date.minute.toString();

    return day + " " + month + " " + time;
  }
}