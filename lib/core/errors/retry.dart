import 'dart:async';

Future<T> retry<T>(
  Future<T> Function() action, {
  int retries = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempt = 0;
  while (attempt < retries) {
    try {
      return await action();
    } catch (e) {
      if (attempt == retries - 1) rethrow;
      await Future.delayed(delay);
      attempt++;
      delay *= 2; // Exponential backoff
    }
  }
  throw Exception('Max retries exceeded');
}
