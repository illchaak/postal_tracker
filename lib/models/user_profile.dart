/// Дані профілю користувача, які показуються в інтерфейсі.
/// Створюються з облікового запису Firebase Authentication
/// (див. AuthRepository), тому екрани не залежать від Firebase напряму.
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoUrl,
  });

  /// Унікальний ідентифікатор користувача у Firebase.
  final String uid;
  final String fullName;
  final String email;

  /// HTTPS-посилання на фото профілю (може бути відсутнім).
  final String? photoUrl;

  String get firstName => fullName.split(' ').first;

  String get initials => fullName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
}
