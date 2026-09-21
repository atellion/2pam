import 'package:flutter/material.dart';

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
        'title': 'Konversi Tanggal',
        'description': 'Hijriah, Saka Bali, dan Weton',
        'icon': Icons.calendar_month,
        'page': const CalendarPage(),
      },
      {
        'title': 'Cek Kecocokan',
        'description': 'Weton dan neptu dua tanggal lahir',
        'icon': Icons.favorite,
        'page': const CompatibilityPage(),
      },
      {
        'title': 'Daftar Anggota',
        'description': 'Data anggota aplikasi',
        'icon': Icons.groups,
        'page': const MembersPage(),
      },
      {
        'title': 'Catatan / Agenda',
        'description': 'Tambah, edit, dan hapus agenda',
        'icon': Icons.event_note,
        'page': const EventsPage(),
      },
      {
        'title': 'Hitung Umur',
        'description': 'Hitung umur secara realtime',
        'icon': Icons.cake,
        'page': const ConversionPage(),
      },
    ];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Kalender & Asisten'),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),

            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final menu = menus[index];

                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                menu['page'] as Widget,
                          ),
                        );
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [
                            Icon(
                              menu['icon'] as IconData,
                              size: 42,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              menu['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              menu['description'] as String,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },

                // Tetap 5 menu
                childCount: menus.length,
              ),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}