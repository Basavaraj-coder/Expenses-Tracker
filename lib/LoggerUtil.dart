import 'package:logger/logger.dart';

class LoggeUtils{
  static final Logger _log = Logger();

  static void logInfo(String message){
    _log.i(message);
  }
  static void logError(String message, [dynamic error, StackTrace? stackTrace]){
    _log.e(message);
  }
}