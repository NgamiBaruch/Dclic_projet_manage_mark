import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _keyLoggedIn = 'logged_in';
  static const _keyUsername = 'username';

  // Simple mock: admin / admin123
  Future<bool> login(String username, String password) async {
    // In production, replace with a secure backend call (HTTPS + JWT)
    if (username.trim() == 'admin' && password == 'admin123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyLoggedIn, true);
      await prefs.setString(_keyUsername, username.trim());
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false);
    await prefs.remove(_keyUsername);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  Future<String?> currentUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
}
