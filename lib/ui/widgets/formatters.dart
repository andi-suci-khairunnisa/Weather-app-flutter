// Fungsi bantu format teks tampilan (tanpa dependensi intl).

const List<String> _dayNames = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

/// Jam dalam format 24 jam, contoh: 14:54.
String formatClock(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

/// Nama hari dalam bahasa Indonesia (weekday: 1 = Senin ... 7 = Minggu).
String dayName(DateTime date) => _dayNames[date.weekday - 1];