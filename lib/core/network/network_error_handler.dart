import 'dart:io';

import 'package:dio/dio.dart';

import 'network_exception.dart';

class NetworkErrorHandler {
  const NetworkErrorHandler._();

  static NetworkException handle(Object error) {
    if (error is NetworkException) return error;

    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is SocketException) {
      return const NetworkException(
        'Tidak ada koneksi internet. Periksa jaringan lalu coba lagi.',
      );
    }

    if (error is FormatException || error is TypeError) {
      return const NetworkException(
        'Data tidak bisa diproses. Silakan coba lagi nanti.',
      );
    }

    return const NetworkException('Terjadi kesalahan. Silakan coba lagi.');
  }

  static NetworkException emptyData([String? context]) {
    final suffix = context == null ? '' : ' $context';
    return NetworkException('Data$suffix tidak ditemukan atau gagal dimuat.');
  }

  static NetworkException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Request timeout. Periksa koneksi internet lalu coba lagi.',
        );
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
      case DioExceptionType.cancel:
        return const NetworkException('Request dibatalkan.');
      case DioExceptionType.connectionError:
        return const NetworkException(
          'Tidak ada koneksi internet. Periksa jaringan lalu coba lagi.',
        );
      case DioExceptionType.badCertificate:
        return const NetworkException(
          'Koneksi tidak aman. Silakan coba lagi nanti.',
        );
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkException(
            'Tidak ada koneksi internet. Periksa jaringan lalu coba lagi.',
          );
        }
        return const NetworkException('Gagal memuat data. Silakan coba lagi.');
    }
  }

  static NetworkException _handleStatusCode(int? statusCode) {
    if (statusCode == null) {
      return const NetworkException('Gagal memuat data. Silakan coba lagi.');
    }

    if (statusCode == 401 || statusCode == 403) {
      return const NetworkException(
        'Akses API ditolak. Periksa konfigurasi token.',
      );
    }

    if (statusCode == 404) {
      return const NetworkException('Data tidak ditemukan.');
    }

    if (statusCode >= 500) {
      return const NetworkException(
        'Server sedang bermasalah. Silakan coba lagi nanti.',
      );
    }

    return NetworkException('Gagal memuat data. Kode error: $statusCode.');
  }
}
