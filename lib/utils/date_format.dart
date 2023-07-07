// Flutter Packages
import 'package:intl/intl.dart';

// This code was only copied from the last Flutter Project

enum FormatoData {
  DATE_RESULT,
  DATE_TIME_REQUEST,
  DATE_TIME_RESULT,
  DATE_BR,
  TIME_BR,
  TIME,
  DATE_TIME_BR,
  DATE_TIME_BR_NO_SECONDS,
  DAY_MONTH_HOUR,
  DAY_MONTH_YEAR,
  WEEK_DAY,
  MONTH,
  MONTH_DAY,
  MONTH_YEAR,
  MONTH_DAY_YEAR,
  YEAR_MONTH_DAY
}

extension FormatoDataExtension on FormatoData {
  String get name => toString().split('.').last;

  String get mask {
    switch (this) {
      case FormatoData.DATE_TIME_REQUEST:
        return 'yyyy-MM-dd HH:mm:ss';
      case FormatoData.DATE_TIME_RESULT:
        return 'dd-MM-yyyy HH:mm:ss';
      case FormatoData.DATE_RESULT:
        return 'dd-MM-yyyy';
      case FormatoData.DATE_BR:
        return 'dd/MM/yyyy';
      case FormatoData.TIME_BR:
        return 'HH:mm:ss';
      case FormatoData.TIME:
        return 'HH:mm';
      case FormatoData.DATE_TIME_BR:
        return 'dd/MM/yyyy HH:mm:ss';
      case FormatoData.DATE_TIME_BR_NO_SECONDS:
        return 'dd/MM/yyyy HH:mm';
      case FormatoData.DAY_MONTH_HOUR:
        return 'EEE, d MMM HH:mm:ss';
      case FormatoData.DAY_MONTH_YEAR:
        return 'EEE, d MMM yyyy';
      case FormatoData.WEEK_DAY:
        return 'EEEE';
      case FormatoData.MONTH:
        return 'MMMM';
      case FormatoData.MONTH_DAY:
        return 'MMM d';
      case FormatoData.MONTH_YEAR:
        return 'MMM, yyyy';
      case FormatoData.MONTH_DAY_YEAR:
        return 'MMM d, yyyy';
      case FormatoData.YEAR_MONTH_DAY:
        return 'yyyy-MM-dd';
      default:
        return '';
    }
  }

  String? format(DateTime? value, {String? defValue}) {
    try {
      return DateFormat(mask, 'pt_Br').format(value!);
    } catch (e) {
      return defValue;
    }
  }

  DateTime? parse(String? value, {DateTime? defValue}) {
    try {
      return DateFormat(mask).parse(value!);
    } catch (e) {
      return defValue;
    }
  }
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return now.day == date.day && now.month == date.month && now.year == date.year;
}
