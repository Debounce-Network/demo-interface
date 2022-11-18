import 'package:shared_preferences/shared_preferences.dart';

class LocalManager {
  static String _offsetKey(String account) => 'offset_$account';

  static String _reloadKey(String account) => 'reload_$account';

  static String _serviceKey(String account) => 'service_chain_$account';

  static Future<int> getTxOffset(String account) async {
    return await _getInt(_offsetKey(account));
  }

  static Future<void> setTxOffset(String account, int offset) async {
    await _setInt(_offsetKey(account), offset);
  }

  static Future<void> setServiceChain(String account, int chainId) async {
    await _setInt(_serviceKey(account), chainId);
  }

  static Future<int> getServiceChain(String account) async {
    return await _getInt(_serviceKey(account));
  }

  static Future<void> setChangeNetwork(String account, bool value) async {
    await _setBool(_reloadKey(account), value);
  }

  static Future<bool> getChangeNetwork(String account) async {
    return await _getBool(_reloadKey(account));
  }

  static Future<void> reset(String account) async {
    setServiceChain(account, -1);
    setChangeNetwork(account, false);
    setTxOffset(account, -1);
  }

  // pref function
  static Future<void> _setBool(String key, bool val) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(key, val);
  }

  static Future<bool> _getBool(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  static Future<void> _setInt(String key, int val) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt(key, val);
  }

  static Future<int> _getInt(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? -1;
  }

  static Future<void> _setString(String key, String val) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, val);
  }

  static Future<String> _getString(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? '';
  }

  static Future<void> _setStrings(String key, List<String> val) async {
    final pref = await SharedPreferences.getInstance();
    pref.setStringList(key, val);
  }

  static Future<List<String>> _getStrings(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList(key) ?? [];
  }
}
