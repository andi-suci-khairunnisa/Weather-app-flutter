// Fungsi bantu parsing JSON yang defensif. Semua kegagalan dilempar sebagai
// FormatException dengan pesan yang jelas.

Map<String, dynamic> requireMap(Object? value, String name) {
  if (value is Map<String, dynamic>) return value;
  throw FormatException('Bagian "$name" tidak ada atau formatnya salah.');
}

List<dynamic> requireList(Object? value, String name) {
  if (value is List<dynamic>) return value;
  throw FormatException('Bagian "$name" tidak ada atau bukan daftar.');
}

double requireDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) return value.toDouble(); // menangani int maupun double
  throw FormatException('Field "$key" tidak ada atau bukan angka.');
}

double? optionalDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is num ? value.toDouble() : null;
}

int requireInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) return value.toInt();
  throw FormatException('Field "$key" tidak ada atau bukan angka.');
}

DateTime requireDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('Field "$key" tidak ada atau bukan waktu yang valid.');
}