import 'package:flutter/material.dart';
import '../services/weton_service.dart';

class CompatibilityPage extends StatefulWidget {
  const CompatibilityPage({super.key});

  @override
  State<CompatibilityPage> createState() =>
      _CompatibilityPageState();
}

class _CompatibilityPageState
    extends State<CompatibilityPage> {
  DateTime? firstDate;
  DateTime? secondDate;

  String? result;

  Future<void> _pickFirstDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        firstDate = picked;
        result = null;
      });
    }
  }

  Future<void> _pickSecondDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        secondDate = picked;
        result = null;
      });
    }
  }

  void _calculateCompatibility() {
    if (firstDate == null || secondDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih kedua tanggal lahir terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    final neptu1 =
        WetonService.getTotalNeptu(firstDate!);

    final neptu2 =
        WetonService.getTotalNeptu(secondDate!);

    final total = neptu1 + neptu2;

    final remainder = total % 5;

    String interpretation;

    switch (remainder) {
      case 0:
        interpretation =
            'Hasil perhitungan menunjukkan kategori '
            'Pegat.';
        break;

      case 1:
        interpretation =
            'Hasil perhitungan menunjukkan kategori '
            'Ratu.';
        break;

      case 2:
        interpretation =
            'Hasil perhitungan menunjukkan kategori '
            'Jodoh.';
        break;

      case 3:
        interpretation =
            'Hasil perhitungan menunjukkan kategori '
            'Topo.';
        break;

      default:
        interpretation =
            'Hasil perhitungan menunjukkan kategori '
            'Tinari.';
    }

    setState(() {
      result = interpretation;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Belum dipilih';
    }

    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Widget _personCard({
    required String title,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Tanggal lahir: ${_formatDate(date)}',
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.calendar_month),
              label: const Text('Pilih Tanggal'),
            ),

            if (date != null) ...[
              const Divider(height: 24),

              Text(
                'Weton: ${WetonService.getWeton(date)}',
              ),

              const SizedBox(height: 6),

              Text(
                'Neptu: ${WetonService.getTotalNeptu(date)}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Kecocokan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Masukkan dua tanggal lahir untuk '
              'melihat perhitungan weton dan neptu.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            _personCard(
              title: '👤 Orang Pertama',
              date: firstDate,
              onPressed: _pickFirstDate,
            ),

            const SizedBox(height: 12),

            _personCard(
              title: '👤 Orang Kedua',
              date: secondDate,
              onPressed: _pickSecondDate,
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: _calculateCompatibility,
              icon: const Icon(Icons.favorite),
              label: const Text(
                'Hitung Kecocokan',
              ),
            ),

            if (result != null) ...[
              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 50,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Hasil Perhitungan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        result!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Neptu total: '
                        '${WetonService.getTotalNeptu(firstDate!)} + '
                        '${WetonService.getTotalNeptu(secondDate!)} = '
                        '${WetonService.getTotalNeptu(firstDate!) + WetonService.getTotalNeptu(secondDate!)}',
                        textAlign: TextAlign.center,
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
}