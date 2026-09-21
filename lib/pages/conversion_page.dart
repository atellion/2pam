import 'dart:async';

import 'package:flutter/material.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() =>
      _ConversionPageState();
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
        title: const Text('Hitung Umur'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Icon(
                      Icons.cake,
                      size: 60,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Hitung Umur',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Pilih tanggal lahir. '
                      'Waktu sekarang akan mengikuti '
                      'waktu perangkat secara realtime.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    OutlinedButton.icon(
                      onPressed: _pickBirthDate,
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                      label: Text(
                        birthDate == null
                            ? 'Pilih Tanggal Lahir'
                            : _formatDate(
                                birthDate!,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (birthDate != null &&
                age != null &&
                duration != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      const Text(
                        'Umur Saat Ini',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
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
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      const Text(
                        'Total Waktu Hidup',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _durationItem(
                        Icons.calendar_today,
                        'Total Hari',
                        duration.inDays
                            .toString(),
                      ),

                      _durationItem(
                        Icons.access_time,
                        'Total Jam',
                        duration.inHours
                            .toString(),
                      ),

                      _durationItem(
                        Icons.timer,
                        'Total Menit',
                        duration.inMinutes
                            .toString(),
                      ),

                      _durationItem(
                        Icons.timer_outlined,
                        'Total Detik',
                        duration.inSeconds
                            .toString(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      const Text(
                        'Waktu Sekarang',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
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
                        ),
                      ),
                    ],
                  ),
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
          ),
        ),
        Text(label),
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
          Icon(icon),

          const SizedBox(width: 12),

          Expanded(
            child: Text(label),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}