import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static const String _storageKey = 'agenda_list';

  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // =========================
  // READ
  // =========================

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(_storageKey) ?? [];

    setState(() {
      events = data
          .map(
            (item) =>
                Map<String, dynamic>.from(jsonDecode(item)),
          )
          .toList();
    });
  }

  // =========================
  // SAVE DATA
  // =========================

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();

    final data = events
        .map((event) => jsonEncode(event))
        .toList();

    await prefs.setStringList(
      _storageKey,
      data,
    );
  }

  // =========================
  // CREATE
  // =========================

  Future<void> _addEvent() async {
    final titleController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    DateTime selectedDate = DateTime.now();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Agenda'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Agenda',
                        prefixIcon:
                            Icon(Icons.title),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller:
                          descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        prefixIcon:
                            Icon(Icons.notes),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      leading: const Icon(
                        Icons.calendar_month,
                      ),

                      title: const Text(
                        'Tanggal',
                      ),

                      subtitle: Text(
                        _formatDate(selectedDate),
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit_calendar,
                        ),

                        onPressed: () async {
                          final picked =
                              await showDatePicker(
                            context: context,
                            initialDate:
                                selectedDate,
                            firstDate:
                                DateTime(2000),
                            lastDate:
                                DateTime(2100),
                          );

                          if (picked != null) {
                            setDialogState(() {
                              selectedDate =
                                  picked;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      false,
                    );
                  },
                  child: const Text('Batal'),
                ),

                FilledButton(
                  onPressed: () {
                    if (titleController
                        .text
                        .trim()
                        .isEmpty) {
                      return;
                    }

                    events.add({
                      'title':
                          titleController.text
                              .trim(),

                      'description':
                          descriptionController
                              .text
                              .trim(),

                      'date':
                          selectedDate
                              .toIso8601String(),
                    });

                    _saveEvents();

                    Navigator.pop(
                      context,
                      true,
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  // =========================
  // UPDATE
  // =========================

  Future<void> _editEvent(int index) async {
    final event = events[index];

    final titleController =
        TextEditingController(
      text: event['title'],
    );

    final descriptionController =
        TextEditingController(
      text: event['description'],
    );

    DateTime selectedDate =
        DateTime.parse(event['date']);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Agenda'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Agenda',
                        prefixIcon:
                            Icon(Icons.title),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller:
                          descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        prefixIcon:
                            Icon(Icons.notes),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      leading: const Icon(
                        Icons.calendar_month,
                      ),

                      title: const Text(
                        'Tanggal',
                      ),

                      subtitle: Text(
                        _formatDate(selectedDate),
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.edit_calendar,
                        ),

                        onPressed: () async {
                          final picked =
                              await showDatePicker(
                            context: context,
                            initialDate:
                                selectedDate,
                            firstDate:
                                DateTime(2000),
                            lastDate:
                                DateTime(2100),
                          );

                          if (picked != null) {
                            setDialogState(() {
                              selectedDate =
                                  picked;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      false,
                    );
                  },
                  child: const Text('Batal'),
                ),

                FilledButton(
                  onPressed: () {
                    if (titleController
                        .text
                        .trim()
                        .isEmpty) {
                      return;
                    }

                    events[index] = {
                      'title':
                          titleController.text
                              .trim(),

                      'description':
                          descriptionController
                              .text
                              .trim(),

                      'date':
                          selectedDate
                              .toIso8601String(),
                    };

                    _saveEvents();

                    Navigator.pop(
                      context,
                      true,
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }

  // =========================
  // DELETE
  // =========================

  Future<void> _deleteEvent(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Agenda'),

          content: const Text(
            'Apakah kamu yakin ingin '
            'menghapus agenda ini?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text('Batal'),
            ),

            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        events.removeAt(index);
      });

      await _saveEvents();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan / Agenda'),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _addEvent,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),

      body: events.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 70,
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Belum ada agenda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Tekan tombol Tambah untuk '
                    'membuat agenda.',
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,

              itemBuilder: (context, index) {
                final event = events[index];

                final date =
                    DateTime.parse(event['date']);

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.all(16),

                    leading: CircleAvatar(
                      child: const Icon(
                        Icons.event,
                      ),
                    ),

                    title: Text(
                      event['title'],
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 8,
                      ),

                      child: Text(
                        '${_formatDate(date)}\n'
                        '${event['description']}',
                      ),
                    ),

                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),

                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Hapus'),
                            ],
                          ),
                        ),
                      ],

                      onSelected: (value) {
                        if (value == 'edit') {
                          _editEvent(index);
                        }

                        if (value == 'delete') {
                          _deleteEvent(index);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}