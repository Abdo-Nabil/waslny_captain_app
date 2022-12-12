import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../../resources/app_strings.dart';

//token can't start with:
// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy'
// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu'

class AuthLocalData {
  final SharedPreferences sharedPreferences;
  AuthLocalData({
    required this.sharedPreferences,
  });

  String? getString(String key) {
    final String? result = sharedPreferences.getString(key);
    return result;
  }

  Future setString(String key, String value) async {
    final bool result = await sharedPreferences.setString(key, value);
    if (!result) {
      throw CacheSavingException();
    }
  }
}
