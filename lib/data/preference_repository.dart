import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepository {
  final SharedPreferences preferences;

  static const _keyIp = 'KEY_IP';
  static const _keyPort = 'KEY_PORT';
  static const _keySkipTutorial = 'KEY_SKIP_TUTORIAL';

  PreferenceRepository(this.preferences);

  String? get prevSessionIp => preferences.getString(_keyIp);

  Future<String?> setLastSessionIp(String ip) async {
    await preferences.setString(_keyIp, ip);
    return prevSessionIp;
  }

  int? get prevSessionPort => preferences.getInt(_keyPort);

  Future<int?> setLastSessionPort(int port) async {
    await preferences.setInt(_keyPort, port);
    return prevSessionPort;
  }

  bool get skipTutorial => preferences.getBool(_keySkipTutorial) ?? false;

  Future<bool> setSkipTutorial(bool skip) async {
    await preferences.setBool(_keySkipTutorial, skip);
    return skipTutorial;
  }
}
