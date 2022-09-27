import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../../resources/app_strings.dart';

class AuthLocalData {
  final SharedPreferences sharedPreferences;
  AuthLocalData({
    required this.sharedPreferences,
  });

  String? getToken() {
    final String? result = sharedPreferences.getString(AppStrings.storedToken);
    return result;
  }

  Future setToken(String token) async {
    //token can't start with:
    // - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
    // - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy'
    // - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu'
    final bool result =
        await sharedPreferences.setString(AppStrings.storedToken, token);
    if (!result) {
      throw CacheSavingException();
    }
  }
}
