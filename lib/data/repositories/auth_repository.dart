import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_profile.dart';
import 'auth_exception.dart';

/// Репозиторій автентифікації: уся взаємодія з Firebase Auth зібрана тут.
/// Екрани не працюють з Firebase напряму, а лише викликають ці методи.
class AuthRepository {
  AuthRepository._(this._auth);

  /// Єдиний екземпляр репозиторію на весь застосунок.
  static final AuthRepository instance = AuthRepository._(FirebaseAuth.instance);

  final FirebaseAuth _auth;

  /// Повідомлення, яке треба показати на наступному екрані
  /// (успішний вхід, реєстрація або вихід).
  String? _pendingMessage;

  // ---------- Стан користувача ----------

  /// Поточний користувач або null, якщо ніхто не увійшов.
  UserProfile? get currentProfile => _toProfile(_auth.currentUser);

  /// Зміни входу/виходу (використовується для відновлення сеансу).
  Stream<UserProfile?> authStateChanges() => _auth.authStateChanges().map(_toProfile);

  /// Зміни профілю (ім'я, фото) — для оновлення інтерфейсу.
  Stream<UserProfile?> profileChanges() => _auth.userChanges().map(_toProfile);

  // ---------- Реєстрація, вхід, вихід ----------

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _run(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();
    });
    _pendingMessage = 'Акаунт створено. Ласкаво просимо, ${name.trim()}!';
  }

  Future<void> signIn({required String email, required String password}) async {
    await _run(() => _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        ));
    _pendingMessage = 'Ви успішно увійшли як ${email.trim()}';
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _run(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  Future<void> signOut() async {
    await _run(_auth.signOut);
    _pendingMessage = 'Ви вийшли з акаунта';
  }

  // ---------- Керування профілем ----------

  Future<void> updateDisplayName(String name) async {
    final user = _requireUser();
    await _run(() async {
      await user.updateDisplayName(name.trim());
      await user.reload();
    });
  }

  /// Зберігає лише HTTPS-посилання на фото (файл не завантажується).
  Future<void> updatePhotoUrl(String url) async {
    final user = _requireUser();
    await _run(() async {
      await user.updatePhotoURL(url);
      await user.reload();
    });
  }

  /// Зміна пароля: спочатку повторне підтвердження особи поточним паролем
  /// (reauthenticate), потім встановлення нового пароля.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _requireUser();
    final email = user.email;
    if (email == null) throw const AuthException('У цього акаунта немає email.');

    try {
      final credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw AuthException('Поточний пароль введено неправильно.', code: e.code);
      }
      throw AuthException.fromCode(e.code);
    }

    await _run(() => user.updatePassword(newPassword));
  }

  /// Повертає і очищає повідомлення для показу після входу/виходу.
  String? takePendingMessage() {
    final message = _pendingMessage;
    _pendingMessage = null;
    return message;
  }

  // ---------- Допоміжні методи ----------

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) throw AuthException.fromCode('no-current-user');
    return user;
  }

  /// Виконує запит до Firebase і перетворює його помилки на AuthException.
  Future<T> _run<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromCode(e.code);
    }
  }

  UserProfile? _toProfile(User? user) {
    if (user == null) return null;
    final name = user.displayName?.trim();
    return UserProfile(
      uid: user.uid,
      fullName: (name == null || name.isEmpty) ? (user.email ?? 'Користувач').split('@').first : name,
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }
}
