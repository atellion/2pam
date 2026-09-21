import 'package:flutter/material.dart';
import '../services/weton_service.dart';

class CompatibilityPage extends StatefulWidget {
  const CompatibilityPage({super.key});

  @override
  State<CompatibilityPage> createState() => _CompatibilityPageState();
}

class _CompatibilityPageState extends State<CompatibilityPage> {
  DateTime? firstDate;
  DateTime? secondDate;

  String? result;

  String? matchStatus;
  String? matchDescription;

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

    final neptu1 = WetonService.getTotalNeptu(firstDate!);

    final neptu2 = WetonService.getTotalNeptu(secondDate!);

    final total = neptu1 + neptu2;

    final remainder = total % 5;

    String interpretation;

    switch (remainder) {
      case 0:
        interpretation = 'Hasil perhitungan menunjukkan kategori '
            'Pegat.';
        break;

      case 1:
        interpretation = 'Hasil perhitungan menunjukkan kategori '
            'Ratu.';
        break;

      case 2:
        interpretation = 'Hasil perhitungan menunjukkan kategori '
            'Jodoh.';
        break;

      case 3:
        interpretation = 'Hasil perhitungan menunjukkan kategori '
            'Topo.';
        break;

      default:
        interpretation = 'Hasil perhitungan menunjukkan kategori '
            'Tinari.';
    }

    String status;
    String description;

    switch (remainder) {
      case 0:
        status = 'Kurang Cocok';
        description = 'Pegat cenderung rawan konflik atau '
            'perpisahan. Butuh usaha ekstra untuk '
            'menjaga hubungan tetap harmonis.';
        break;

      case 1:
        status = 'Cukup Cocok';
        description = 'Ratu artinya pasangan saling menghormati '
            'dan disegani, hubungan cenderung rukun '
            'hingga tua.';
        break;

      case 2:
        status = 'Sangat Cocok';
        description = 'Jodoh artinya pasangan memang serasi dan '
            'sesuai satu sama lain.';
        break;

      case 3:
        status = 'Netral';
        description = 'Topo artinya di awal hubungan mungkin '
            'banyak ujian atau kesulitan, tapi bila '
            'sabar akan berujung baik.';
        break;

      default:
        status = 'Cocok';
        description = 'Tinari artinya kehidupan cenderung mudah '
            'dan lancar rezeki.';
    }

    setState(() {
      result = interpretation;
      matchStatus = status;
      matchDescription = description;
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      if (matchStatus != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: matchStatus == 'Cocok'
                                ? Colors.green.withOpacity(0.15)
                                : matchStatus == 'Netral'
                                    ? Colors.orange.withOpacity(0.15)
                                    : Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            matchStatus!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: matchStatus == 'Cocok'
                                  ? Colors.green[800]
                                  : matchStatus == 'Netral'
                                      ? Colors.orange[800]
                                      : Colors.red[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          matchDescription ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
