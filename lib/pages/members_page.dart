import 'package:flutter/material.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  final List<Map<String, String>> members = const [
    {
      'name': 'Melani Bunga Cindya Pawesty',
      'role': 'Project Manager',
      'nim': '124240164',
    },
    {
      'name': 'Anggota 2',
      'role': 'UI/UX Designer',
      'nim': '124240XXX',
    },
    {
      'name': 'Anggota 3',
      'role': 'Programmer',
      'nim': '124240XXX',
    },
    {
      'name': 'Anggota 4',
      'role': 'Database',
      'nim': '124240XXX',
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
                  '${member['role']}\n'
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