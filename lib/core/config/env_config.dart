import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get env => dotenv.env['ENV'] ?? 'development';
  static String get apiUrl => dotenv.env['API_URL'] ?? 'http://localhost:8080';
  
  // Web
  static String get webDomain => dotenv.env['WEB_DOMAIN'] ?? 'deal.taxlien.online';
  
  // App Identifiers
  static String get iosBundleId => dotenv.env['IOS_BUNDLE_ID'] ?? '';
  static String get androidPackageName => dotenv.env['ANDROID_PACKAGE_NAME'] ?? '';
  
  // Offline Mode
  static int get offlineBatchSize => int.tryParse(dotenv.env['OFFLINE_BATCH_SIZE'] ?? '100') ?? 100;
  static int get ultraResPercent => int.tryParse(dotenv.env['ULTRA_RES_PERCENT'] ?? '20') ?? 20;

  // Store URLs
  static String get storeGooglePlay => dotenv.env['STORE_GOOGLE_PLAY'] ?? '';
  static String get storeApple => dotenv.env['STORE_APPLE'] ?? '';
  static String get storeHuawei => dotenv.env['STORE_HUAWEI'] ?? '';
  static String get storeSamsung => dotenv.env['STORE_SAMSUNG'] ?? '';
  static String get storeXiaomi => dotenv.env['STORE_XIAOMI'] ?? '';
  static String get storeRuStore => dotenv.env['STORE_RUSTORE'] ?? '';

  static List<Map<String, String>> get availableStores {
    final stores = <Map<String, String>>[];
    
    if (storeGooglePlay.isNotEmpty) {
      stores.add({'name': 'Google Play', 'url': storeGooglePlay, 'id': 'google'});
    }
    if (storeApple.isNotEmpty) {
      stores.add({'name': 'App Store', 'url': storeApple, 'id': 'apple'});
    }
    if (storeHuawei.isNotEmpty) {
      stores.add({'name': 'AppGallery', 'url': storeHuawei, 'id': 'huawei'});
    }
    if (storeRuStore.isNotEmpty) {
      stores.add({'name': 'RuStore', 'url': storeRuStore, 'id': 'rustore'});
    }
    if (storeSamsung.isNotEmpty) {
      stores.add({'name': 'Galaxy Store', 'url': storeSamsung, 'id': 'samsung'});
    }
    if (storeXiaomi.isNotEmpty) {
      stores.add({'name': 'GetApps', 'url': storeXiaomi, 'id': 'xiaomi'});
    }
    
    return stores;
  }
}
