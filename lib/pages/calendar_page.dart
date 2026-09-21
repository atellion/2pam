import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/weton_service.dart';
import '../utils/app_colors.dart';
import '../widgets/glass_card.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();

  String hijriDate = '-';
  String sakaBali = '-';
  String weton = '-';

  @override
  void initState() {
    super.initState();
    _convertDate();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });

      _convertDate();
    }
  }

  void _convertDate() {
    setState(() {
      hijriDate = _convertToHijri(selectedDate);
      sakaBali = _convertToSakaBali(selectedDate);
      weton = WetonService.getWeton(selectedDate);
    });
  }

    // KONVERSI HIJRIAH

  static const int _islamicEpochJd = 1948440;

  static const List<String> _hijriMonths = [
    'Muharram',
    'Safar',
    'Rabiul Awal',
    'Rabiul Akhir',
    'Jumadil Awal',
    'Jumadil Akhir',
    'Rajab',
    'Syaaban',
    'Ramadan',
    'Syawal',
    'Zulkaidah',
    'Zulhijah',
  ];

  String _convertToHijri(DateTime date) {
    final jd = _gregorianToJulianDay(date);

    final hijriYear = (30 * (jd - _islamicEpochJd) + 10646) ~/ 10631;

    final startOfYear = _hijriToJulianDay(hijriYear, 1, 1);
    var hijriMonth = ((jd - (29 + startOfYear)) / 29.5).ceil() + 1;
    if (hijriMonth > 12) hijriMonth = 12;
    if (hijriMonth < 1) hijriMonth = 1;

    final hijriDay = jd - _hijriToJulianDay(hijriYear, hijriMonth, 1) + 1;

    return '$hijriDay ${_hijriMonths[hijriMonth - 1]} $hijriYear H';
  }

  int _gregorianToJulianDay(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;

    return date.day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  int _hijriToJulianDay(int year, int month, int day) {
    return day +
        (29.5 * (month - 1)).ceil() +
        (year - 1) * 354 +
        ((3 + 11 * year) ~/ 30) +
        _islamicEpochJd -
        1;
  }

  // KONVERSI KALENDER BALI (SAKA)
  // Sasih (bulan candra) TIDAK dihitung -- butuh astronomi bulan,

  String _convertToSakaBali(DateTime date) {
    final sakaYear = _getSakaYear(date);
    final saptawara = _saptawaraBali[date.weekday - 1];
    final pancawara = _pancawaraBali(date);
    final wuku = _getWuku(date);

    return 'Saka $sakaYear • $saptawara $pancawara • Wuku $wuku';
  }

  static final Map<int, DateTime> _nyepiDates = {
    2020: DateTime(2020, 3, 25),
    2021: DateTime(2021, 3, 14),
    2022: DateTime(2022, 3, 3),
    2023: DateTime(2023, 3, 22),
    2024: DateTime(2024, 3, 11),
    2025: DateTime(2025, 3, 29),
    2026: DateTime(2026, 3, 19),
  };

  int _getSakaYear(DateTime date) {
    final knownNyepi = _nyepiDates[date.year];
    final nyepi = knownNyepi ?? DateTime(date.year, 3, 21);
    return date.isBefore(nyepi) ? date.year - 79 : date.year - 78;
  }

  static const List<String> _wukuNames = [
    'Sinta', 'Landep', 'Ukir', 'Kulantir', 'Tolu', 'Gumbreg',
    'Wariga', 'Warigadean', 'Julungwangi', 'Sungsang', 'Dungulan',
    'Kuningan', 'Langkir', 'Medangsia', 'Pujut', 'Pahang', 'Krulut',
    'Merakih', 'Tambir', 'Medangkungan', 'Matal', 'Uye', 'Menail',
    'Prangbakat', 'Bala', 'Ugu', 'Wayang', 'Kelawu', 'Dukut',
    'Watugunung',
  ];

  static final DateTime _wukuReferenceDate = DateTime(2024, 12, 29);
  static const int _wukuReferenceIndex = 24; // Bala

  String _getWuku(DateTime date) {
    final daysDiff = date.difference(_wukuReferenceDate).inDays;
    final weekDiff = _floorDiv(daysDiff, 7);
    final index = (_wukuReferenceIndex + weekDiff) % _wukuNames.length;
    final fixedIndex = index < 0 ? index + _wukuNames.length : index;

    return _wukuNames[fixedIndex];
  }

  int _floorDiv(int a, int b) {
    final q = a ~/ b;
    final r = a - q * b;
    if (r != 0 && (r < 0) != (b < 0)) {
      return q - 1;
    }
    return q;
  }

  static const Map<String, String> _pasaranJawaToBali = {
    'Legi': 'Umanis',
    'Pahing': 'Paing',
    'Pon': 'Pon',
    'Wage': 'Wage',
    'Kliwon': 'Kliwon',
  };

  String _pancawaraBali(DateTime date) {
    final pasaranJawa = WetonService.getWeton(date).split(' ').last;
    return _pasaranJawaToBali[pasaranJawa] ?? '-';
  }

  static const List<String> _saptawaraBali = [
    'Soma', // Senin
    'Anggara', // Selasa
    'Buda', // Rabu
    'Wraspati', // Kamis
    'Sukra', // Jumat
    'Saniscara', // Sabtu
    'Redite', // Minggu
  ];
  
  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Konversi Tanggal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: AppColors.primaryDark.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              onTap: _pickDate, // Membuat card bisa ditekan (interaktif)
              child: Column(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 60,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textMain),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.date_range,
                        color: AppColors.primaryDark),
                    label: const Text(
                      'Pilih Tanggal',
                      style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              icon: Icons.calendar_today,
              title: 'Tanggal Masehi',
              value: formattedDate,
            ),
            _buildResultCard(
              icon: Icons.nightlight_round,
              title: 'Kalender Hijriah',
              value: hijriDate,
            ),
            _buildResultCard(
              icon: Icons.temple_hindu,
              title: 'Kalender Saka Bali',
              value: sakaBali,
            ),
            _buildResultCard(
              icon: Icons.auto_awesome,
              title: 'Weton Jawa',
              value: weton,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.2),
          foregroundColor: AppColors.primary,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textMain,
            ),
          ),
        ),
      ),
    );
  }
}