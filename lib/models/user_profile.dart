/// Дані профілю користувача.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.greetingName,
    required this.email,
    required this.phone,
    required this.language,
    required this.passwordChangedAt,
  });

  final String fullName;

  /// Ім'я у кличному відмінку для привітання («Інно»).
  final String greetingName;
  final String email;
  final String phone;
  final String language;
  final String passwordChangedAt;

  String get initials => fullName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0])
      .join();
}
