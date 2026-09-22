import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/glass_card.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  DateTime? birthDate;
  DateTime currentTime = DateTime.now();

  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Update waktu setiap 1 detik.
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {
            currentTime = DateTime.now();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Map<String, int> _calculateAge(
    DateTime birth,
    DateTime now,
  ) {
    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months--;

      final previousMonth = DateTime(
        now.year,
        now.month,
        0,
      );

      days += previousMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  Duration _calculateTotalDuration(
    DateTime birth,
    DateTime now,
  ) {
    return now.difference(birth);
  }

  @override
  Widget build(BuildContext context) {
    final age = birthDate == null
        ? null
        : _calculateAge(
            birthDate!,
            currentTime,
          );

    final duration = birthDate == null
        ? null
        : _calculateTotalDuration(
            birthDate!,
            currentTime,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hitung Umur',
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
              onTap: _pickBirthDate, // Membuatnya interaktif saat ditekan
              child: Column(
                children: [
                  const Icon(
                    Icons.cake,
                    size: 60,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hitung Umur',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih tanggal lahir. '
                    'Waktu sekarang akan mengikuti '
                    'waktu perangkat secara realtime.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMain),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: _pickBirthDate,
                    icon: const Icon(
                      Icons.calendar_month,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      birthDate == null
                          ? 'Pilih Tanggal Lahir'
                          : _formatDate(
                              birthDate!,
                            ),
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (birthDate != null && age != null && duration != null) ...[
              GlassCard(
                child: Column(
                  children: [
                    const Text(
                      'Umur Saat Ini',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ageItem(
                          age['years']!,
                          'Tahun',
                        ),
                        _ageItem(
                          age['months']!,
                          'Bulan',
                        ),
                        _ageItem(
                          age['days']!,
                          'Hari',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  children: [
                    const Text(
                      'Total Waktu Hidup',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _durationItem(
                      Icons.calendar_today,
                      'Total Hari',
                      duration.inDays.toString(),
                    ),
                    _durationItem(
                      Icons.access_time,
                      'Total Jam',
                      duration.inHours.toString(),
                    ),
                    _durationItem(
                      Icons.timer,
                      'Total Menit',
                      duration.inMinutes.toString(),
                    ),
                    _durationItem(
                      Icons.timer_outlined,
                      'Total Detik',
                      duration.inSeconds.toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GlassCard(
                child: Column(
                  children: [
                    const Text(
                      'Waktu Sekarang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatDate(currentTime)} '
                      '${currentTime.hour.toString().padLeft(2, '0')}:'
                      '${currentTime.minute.toString().padLeft(2, '0')}:'
                      '${currentTime.second.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _ageItem(
    int value,
    String label,
  ) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMain),
        ),
      ],
    );
  }

  Widget _durationItem(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMain),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}