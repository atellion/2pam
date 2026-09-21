import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/session_service.dart';

class HelpPage extends StatelessWidget {
  final VoidCallback onLogout;

  const HelpPage({
    super.key,
    required this.onLogout,
  });

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari aplikasi?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      SessionService.key,
      false,
    );

    onLogout();
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(description),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 70,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Kalender & Asisten',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Aplikasi untuk membantu perhitungan '
                      'tanggal, weton, kecocokan, agenda, '
                      'dan umur.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Panduan Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildHelpItem(
              icon: Icons.calendar_month,
              title: 'Konversi Tanggal',
              description:
                  'Pilih tanggal untuk melihat '
                  'informasi Masehi, Hijriah, '
                  'Saka Bali, dan Weton.',
            ),

            _buildHelpItem(
              icon: Icons.favorite,
              title: 'Cek Kecocokan',
              description:
                  'Masukkan dua tanggal lahir '
                  'untuk menghitung weton, neptu, '
                  'dan kategori kecocokan.',
            ),

            _buildHelpItem(
              icon: Icons.groups,
              title: 'Daftar Anggota',
              description:
                  'Menampilkan data anggota '
                  'yang menggunakan aplikasi.',
            ),

            _buildHelpItem(
              icon: Icons.event_note,
              title: 'Catatan / Agenda',
              description:
                  'Gunakan fitur ini untuk '
                  'menambah, melihat, mengubah, '
                  'dan menghapus agenda.',
            ),

            _buildHelpItem(
              icon: Icons.cake,
              title: 'Hitung Umur',
              description:
                  'Masukkan tanggal lahir untuk '
                  'menghitung umur berdasarkan '
                  'waktu perangkat secara realtime.',
            ),

            _buildHelpItem(
              icon: Icons.timer,
              title: 'Stopwatch',
              description:
                  'Gunakan stopwatch untuk '
                  'mengukur durasi waktu dengan '
                  'fitur Start, Pause, dan Reset.',
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 16),

            const Text(
              'Akun',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Kalender & Asisten v1.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}