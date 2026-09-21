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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 168,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: AppColors.primaryDark.withValues(alpha: 0.15),
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Kalender & Asisten',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, size: 28),
              onPressed: () {},
              color: AppColors.textLight,
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            background: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Halo, Selamat Datang',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Temukan segala kebutuhan\npenanggalanmu disini.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Menu List (vertikal)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final menu = menus[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => menu['page'] as Widget,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            menu['icon'] as IconData,
                            size: 26,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                menu['description'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textLight,
                        ),
                      ],
                    ),
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
    );
  }
}