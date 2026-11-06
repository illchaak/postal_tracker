import 'package:firebase_analytics/firebase_analytics.dart';

import '../../models/shipment.dart';

/// Обгортка над Firebase Analytics: усі події застосунку в одному місці.
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Спостерігач для навігатора: автоматично реєструє перехід між
  /// іменованими маршрутами (вхід, реєстрація, відновлення пароля).
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  /// Рекомендовані події Firebase.
  Future<void> logLogin() => _analytics.logLogin(loginMethod: 'email');

  Future<void> logSignUp() => _analytics.logSignUp(signUpMethod: 'email');

  /// Перегляд розділу бічної панелі (вкладений навігатор).
  Future<void> logScreen(String screenName) => _analytics.logScreenView(screenName: screenName);

  /// Власні події застосунку.
  Future<void> logShipmentOpened(Shipment shipment) => _analytics.logEvent(
        name: 'shipment_opened',
        parameters: {
          'carrier': shipment.carrier,
          'status': shipment.status.name,
        },
      );

  Future<void> logProfilePhotoChanged() => _analytics.logEvent(name: 'profile_photo_changed');

  Future<void> logPasswordChanged() => _analytics.logEvent(name: 'password_changed');

  Future<void> setUserId(String? uid) => _analytics.setUserId(id: uid);
}
