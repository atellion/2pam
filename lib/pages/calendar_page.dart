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

  String _convertToHijri(DateTime date) {
    // Konversi kalender Hijriah tabular.
    // Hasil perlu diverifikasi terhadap kalender Hijriah
    // resmi apabila digunakan sebagai kalender keagamaan.

    final jd = _julianDay(date);

    final l = jd + 68569;
    final n = (4 * l ~/ 146097);
    final l2 = l - (146097 * n + 3) ~/ 4;
    final i = 4000 * (l2 + 1) ~/ 1461001;
    final l3 = l2 - 1461 * i ~/ 4 + 31;
    final j = 80 * l3 ~/ 2447;
    final day = l3 - 2447 * j ~/ 80;
    final l4 = j ~/ 11;
    final month = j + 2 - 12 * l4;
    final year = 100 * (n - 49) + i + l4;

    // Julian Day Masehi -> Hijriah
    final jd2 = jd.floor();

    final islamicEpoch = 1948439;
    final hijriYear = ((30 * (jd2 - islamicEpoch) + 10646) ~/ 10631);

    final hijriMonth = ((jd2 -
                    (29 +
                        _islamicToJulianDay(
                          hijriYear,
                          1,
                          1,
                        ))) ~/
                29.5)
            .floor() +
        1;

    final monthValue = hijriMonth.clamp(1, 12);

    final hijriDay = jd2 -
        _islamicToJulianDay(
          hijriYear,
          monthValue,
          1,
        ) +
        1;

    final months = [
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

    // Variabel Masehi di atas sengaja dihitung untuk menjaga
    // algoritma Julian Day tetap konsisten.
    // ignore: unused_local_variable
    final _ = l;
    // ignore: unused_local_variable
    final __ = n;
    // ignore: unused_local_variable
    final ___ = l2;
    // ignore: unused_local_variable
    final ____ = i;
    // ignore: unused_local_variable
    final _____ = l3;
    // ignore: unused_local_variable
    final ______ = j;
    // ignore: unused_local_variable
    final _______ = day;
    // ignore: unused_local_variable
    final ________ = month;
    // ignore: unused_local_variable
    final _________ = year;

    return '$hijriDay ${months[monthValue - 1]} $hijriYear H';
  }

  int _julianDay(DateTime date) {
    int a = (14 - date.month) ~/ 12;
    int y = date.year + 4800 - a;
    int m = date.month + 12 * a - 3;

    return date.day +
        ((153 * m + 2) ~/ 5) +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  int _islamicToJulianDay(
    int year,
    int month,
    int day,
  ) {
    return (day +
        ((29.5 * (month - 1)).ceil()) +
        (year - 1) * 354 +
        ((3 + 11 * year) ~/ 30) +
        1948439 -
        1);
  }

  String _convertToSakaBali(DateTime date) {
    /*
      Catatan:
      Kalender Saka Bali tidak cukup dihitung hanya dengan
      date.year - 78 karena penanggalannya mengikuti sistem
      sasih dan aturan kalender Bali.

      Untuk sementara halaman menyediakan struktur output
      Saka Bali. Algoritma Saka Bali yang digunakan nantinya
      perlu disesuaikan dengan sumber/standar kalender Bali
      yang dipakai dalam tugas.
    */

    final sakaYear = date.year - 78;

    return 'Saka $sakaYear';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Tanggal'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
      ),
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
