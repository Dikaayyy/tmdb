import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => _requiredEnv('TMDB_BASE_URL');

  static String get imageUrl => _requiredEnv('TMDB_IMAGE_URL');

  static String get accessToken => _requiredEnv('TMDB_ACCESS_TOKEN');

  static String _requiredEnv(String key) {
    final value = dotenv.env[key];
    if (value == null || value.trim().isEmpty) {
      throw StateError('$key belum dikonfigurasi di file .env.');
    }
    return value;
  }
}
