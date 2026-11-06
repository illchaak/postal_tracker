
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Обгортка над Firebase Crashlytics: перехоплення та надсилання помилок.
class CrashReportingService {
  CrashReportingService._();

  static final CrashReportingService instance = CrashReportingService._();

  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Підключає обробники необроблених помилок Flutter і Dart.
  void setupErrorHandlers() {
    // Помилки, перехоплені фреймворком Flutter (наприклад, у build()).
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // Необроблені асинхронні помилки поза Flutter.
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> setUserId(String? uid) => _crashlytics.setUserIdentifier(uid ?? '');

  /// Тестова нефатальна помилка: застосунок продовжує роботу.
  Future<void> sendTestNonFatalError() async {
    try {
      throw StateError('Тестова помилка ЛР4: не вдалося оновити статус посилки');
    } catch (error, stackTrace) {
      await _crashlytics.log('Користувач натиснув «Надіслати тестову помилку»');
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: 'Тестова нефатальна помилка (лабораторна робота №4)',
        fatal: false,
      );
    }
  }

  /// Тестовий збій: застосунок аварійно завершиться,
  /// звіт буде надіслано під час наступного запуску.
  void crashApp() => _crashlytics.crash();
}
