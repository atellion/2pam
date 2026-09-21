class WetonService {
  static const List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _pasaran = [
    'Legi',
    'Pahing',
    'Pon',
    'Wage',
    'Kliwon',
  ];

  static const List<int> _dayNeptu = [
    4, // Senin
    3, // Selasa
    7, // Rabu
    8, // Kamis
    6, // Jumat
    9, // Sabtu
    5, // Minggu
  ];

  static const List<int> _pasaranNeptu = [
    5, // Legi
    9, // Pahing
    7, // Pon
    4, // Wage
    8, // Kliwon
  ];

  // Referensi:
  // 1 Januari 2025 = Rabu Pon
  static final DateTime _referenceDate =
      DateTime(2025, 1, 1);

  static const int _referencePasaranIndex = 2; // Pon

  static String getWeton(DateTime date) {
    final dayIndex = date.weekday - 1;

    final difference =
        date.difference(_referenceDate).inDays;

    final pasaranIndex =
        (_referencePasaranIndex + difference) % 5;

    final fixedPasaranIndex =
        pasaranIndex < 0 ? pasaranIndex + 5 : pasaranIndex;

    return '${_days[dayIndex]} ${_pasaran[fixedPasaranIndex]}';
  }

  static int getDayNeptu(DateTime date) {
    return _dayNeptu[date.weekday - 1];
  }

  static int getPasaranNeptu(DateTime date) {
    final difference =
        date.difference(_referenceDate).inDays;

    final pasaranIndex =
        (_referencePasaranIndex + difference) % 5;

    final fixedPasaranIndex =
        pasaranIndex < 0 ? pasaranIndex + 5 : pasaranIndex;

    return _pasaranNeptu[fixedPasaranIndex];
  }

  static int getTotalNeptu(DateTime date) {
    return getDayNeptu(date) +
        getPasaranNeptu(date);
  }
}