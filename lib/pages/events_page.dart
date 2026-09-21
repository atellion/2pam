import 'package:flutter/material.dart';

import '../main.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Map<String, dynamic>> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // =========================
  // READ
  // =========================

  Future<void> _loadEvents() async {
    setState(() => isLoading = true);

    try {
      final data = await supabase
          .from('events')
          .select()
          .order('event_date');

      setState(() {
        events = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat agenda: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // =========================
  // CREATE
  // =========================

  Future<void> _addEvent() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

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
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month),
                      title: const Text('Tanggal'),
                      subtitle: Text(_formatDate(selectedDate)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {
                            setDialogState(() {
                              selectedDate = picked;
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
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    Navigator.pop(context, true);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) return;

    try {
      await supabase.from('events').insert({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'event_date': selectedDate.toIso8601String(),
      });

      await _loadEvents();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan agenda: $e')),
      );
    }
  }

  // =========================
  // UPDATE
  // =========================

  Future<void> _editEvent(int index) async {
    final event = events[index];

    final titleController = TextEditingController(text: event['title']);
    final descriptionController =
        TextEditingController(text: event['description']);

    DateTime selectedDate = DateTime.parse(event['event_date']);

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
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        prefixIcon: Icon(Icons.notes),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month),
                      title: const Text('Tanggal'),
                      subtitle: Text(_formatDate(selectedDate)),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {
                            setDialogState(() {
                              selectedDate = picked;
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
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    Navigator.pop(context, true);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) return;

    try {
      await supabase.from('events').update({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'event_date': selectedDate.toIso8601String(),
      }).eq('id', event['id']);

      await _loadEvents();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah agenda: $e')),
      );
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
            'Apakah kamu yakin ingin menghapus agenda ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final event = events[index];

    try {
      await supabase.from('events').delete().eq('id', event['id']);
      await _loadEvents();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus agenda: $e')),
      );
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEvent,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note, size: 70),
                      SizedBox(height: 12),
                      Text(
                        'Belum ada agenda',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Tekan tombol Tambah untuk membuat agenda.',
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadEvents,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final date = DateTime.parse(event['event_date']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(
                            child: Icon(Icons.event),
                          ),
                          title: Text(
                            event['title'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${_formatDate(date)}\n'
                              '${event['description'] ?? ''}',
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
                ),
    );
  }
}