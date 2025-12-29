import 'package:shared_preferences/shared_preferences.dart';

class VehiclePromptService {
  static const _dontAskKey = 'dont_ask_vehicle';

  Future<bool> shouldAskAgain() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_dontAskKey) ?? false);
  }

  Future<void> setDontAskAgain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dontAskKey, true);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dontAskKey);
  }
}
