import 'package:logger/logger.dart';

class AppLogger extends Logger {
  var logMessage;
  var error;

  static Logger errorlogger = Logger(
      printer: PrettyPrinter(
          methodCount: 10,
          colors: true,
          printTime: true,
          stackTraceBeginIndex: 0));

  static Logger infoLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 0,
          colors: true,
          printTime: true,
          stackTraceBeginIndex: 0));

  static Logger debugLogger = infoLogger;

  static printErrorLog(logMessage, {error: 'none'}) {
    errorlogger.e(logMessage, error);
  }

  static printInfoLog(logMessage) {
    infoLogger.i(logMessage);
  }

  static printDebugLog(logMessage) {
    debugLogger.d(logMessage);
  }
}
