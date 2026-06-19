import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.env['TMDB_BASE_URL'] ?? '';

  static String get imageUrl =>
      dotenv.env['TMDB_IMAGE_URL'] ?? '';

  static String get accessToken =>
      dotenv.env['TMDB_ACCESS_TOKEN'] ?? '';
}