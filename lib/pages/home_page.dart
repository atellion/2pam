import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/glass_card.dart';
import 'calendar_page.dart';
import 'compatibility_page.dart';
import 'members_page.dart';
import 'events_page.dart';
import 'conversion_page.dart';
import 'stopwatch_page.dart';
import 'help_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onLogout;

  const HomePage({
    super.key,
    required this.onLogout,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      const StopwatchPage(),
      HelpPage(
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: pages[bottomIndex],

      // Bottom Navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomIndex,
        onDestinationSelected: (index) {
          setState(() {
            bottomIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Utama',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: 'Stopwatch',
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline),
            label: 'Bantuan',
          ),
        ],
      ),
    );
  }

  Widget _buildHome() {
    final menus = [
      {
        'title': 'Daftar Anggota',
        'description': 'Data anggota aplikasi',
        'icon': Icons.groups,
        'page': const MembersPage(),
      },
      {
        'title': 'Konversi Tanggal',
        'description': 'Hijriah, Saka Bali, dan Weton',
        'icon': Icons.calendar_month,
        'page': const CalendarPage(),
      },
      {
        'title': 'Hitung Umur',
        'description': 'Hitung umur secara realtime',
        'icon': Icons.cake,
        'page': const ConversionPage(),
      },
      {
        'title': 'Cek Kecocokan',
        'description': 'Weton dan neptu dua tanggal lahir',
        'icon': Icons.favorite,
        'page': const CompatibilityPage(),
      },
      {
        'title': 'Catatan / Agenda',
        'description': 'Tambah, edit, dan hapus agenda',
        'icon': Icons.event_note,
        'page': const EventsPage(),
      },
    ];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Kalender & Asisten'),
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.primaryDark,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle, size: 28),
                onPressed: () {},
                color: AppColors.textLight,
              ),
            ],
          ),
          
          // Header Greetings
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Selamat Datang',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Temukan segala kebutuhan penanggalanmu disini.',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Menu Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final menu = menus[index];
                  return GlassCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => menu['page'] as Widget,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            menu['icon'] as IconData,
                            size: 28,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          menu['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.primaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          menu['description'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
                childCount: menus.length,
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}
