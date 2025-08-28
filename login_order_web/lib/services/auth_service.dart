import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String allowedDomain = 'example.com';

  static const String _prefsKeyIsLoggedIn = 'isLoggedIn';
  static const String _prefsKeyEmail = 'email';

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKeyIsLoggedIn) ?? false;
  }

  Future<String?> currentEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKeyEmail);
  }

  Future<bool> loginWithEmail(String email) async {
    final String normalizedEmail = email.trim().toLowerCase();
    final bool isValid = _isEmailInAllowedDomain(normalizedEmail);
    if (!isValid) {
      return false;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyIsLoggedIn, true);
    await prefs.setString(_prefsKeyEmail, normalizedEmail);
    return true;
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKeyIsLoggedIn);
    await prefs.remove(_prefsKeyEmail);
  }

  bool _isEmailInAllowedDomain(String email) {
    final int atIndex = email.lastIndexOf('@');
    if (atIndex <= 0 || atIndex == email.length - 1) {
      return false;
    }
    final String domain = email.substring(atIndex + 1);
    return domain == allowedDomain;
  }
}

