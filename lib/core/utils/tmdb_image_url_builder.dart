import '../constants/api_constants.dart';

class TmdbImageUrlBuilder {
  const TmdbImageUrlBuilder._();

  static String build(String path) {
    if (path.isEmpty) return '';
    return '${ApiConstants.imageUrl}$path';
  }
}
