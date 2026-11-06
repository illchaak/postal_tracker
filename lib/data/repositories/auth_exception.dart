/// Помилка автентифікації з повідомленням, зрозумілим користувачу.
class AuthException implements Exception {
  const AuthException(this.message, {this.code});

  final String message;

  /// Технічний код помилки Firebase (для журналу та Crashlytics).
  final String? code;

  /// Перетворення коду помилки Firebase Auth на зрозумілий текст.
  factory AuthException.fromCode(String code) {
    final message = switch (code) {
      'invalid-email' => 'Неправильний формат електронної пошти.',
      'user-disabled' => 'Цей акаунт заблоковано.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' ||
      'INVALID_LOGIN_CREDENTIALS' =>
        'Не вдалося увійти. Перевірте email і пароль.',
      'email-already-in-use' => 'Акаунт з такою електронною поштою вже існує.',
      'weak-password' => 'Пароль занадто простий. Використайте щонайменше 8 символів.',
      'too-many-requests' => 'Забагато спроб. Зачекайте кілька хвилин і спробуйте знову.',
      'network-request-failed' => 'Немає з’єднання з інтернетом. Перевірте мережу.',
      'requires-recent-login' =>
        'З міркувань безпеки потрібно увійти повторно. Вийдіть з акаунта, увійдіть знову і повторіть дію.',
      'operation-not-allowed' => 'Вхід за email і паролем не увімкнено у Firebase Console.',
      'keychain-error' =>
        'Помилка доступу до Keychain macOS. Перевірте Team і Keychain Sharing у Xcode.',
      'no-current-user' => 'Сеанс завершився. Увійдіть знову.',
      _ => 'Сталася помилка ($code). Спробуйте ще раз.',
    };
    return AuthException(message, code: code);
  }

  @override
  String toString() => 'AuthException($code): $message';
}
