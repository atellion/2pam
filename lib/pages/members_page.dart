import 'package:flutter/material.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  final List<Map<String, String>> members = const [
    {
      'name': 'Melani Bunga Chintya Pawesty',
      'nim': '124240164',
    },
    {
      'name': 'Naftali Margareta Gultom',
      'nim': '124240119',
    },
    {
      'name': 'Najmah Cleosa Vania Putri',
      'nim': '124240119',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              contentPadding: const EdgeInsets.all(16),

              leading: CircleAvatar(
                radius: 28,
                child: Text(
                  member['name']!
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              title: Text(
                member['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'NIM: ${member['nim']}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}