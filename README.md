# TMDB

Aplikasi Flutter untuk eksplorasi movie dan TV show dari TMDB. App ini menampilkan trending, new release, top rated, kategori genre, detail movie/TV, cast & crew, watchlist lokal, dan recently viewed.

## Tech Stack

- Flutter
- Riverpod
- Dio
- Hive
- cached_network_image
- intl

## Setup

1. Install dependency:

   ```bash
   flutter pub get
   ```

2. Buat file `.env` di root project:

   ```env
   TMDB_BASE_URL=https://api.themoviedb.org/3
   TMDB_IMAGE_URL=https://image.tmdb.org/t/p/w500
   TMDB_ACCESS_TOKEN=your_tmdb_read_access_token
   ```

3. Jalankan aplikasi:

   ```bash
   flutter run
   ```

## Validasi

Jalankan static analyzer sebelum commit:

```bash
flutter analyze
```

## Catatan

- `.env` wajib tersedia karena app mengambil base URL, image URL, dan access token dari sana.
- Data watchlist dan recently viewed disimpan secara lokal memakai Hive.
