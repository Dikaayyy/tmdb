import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/watchlist_repository.dart';

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});
