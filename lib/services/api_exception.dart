/// Kegagalan pengambilan data dengan pesan berbahasa Indonesia
/// yang siap ditampilkan ke pengguna.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => 'ApiException: $message';
}