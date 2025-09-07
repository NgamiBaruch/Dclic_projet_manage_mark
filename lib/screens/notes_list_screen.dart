import 'package:flutter/material.dart';
import 'package:flutter_notes_sqlite_app/data/auth_service.dart';
import 'package:flutter_notes_sqlite_app/data/note.dart';
import 'package:flutter_notes_sqlite_app/data/note_dao.dart';
import 'package:flutter_notes_sqlite_app/screens/login_screen.dart';
import 'package:flutter_notes_sqlite_app/screens/edit_note_screen.dart';
import 'package:flutter_notes_sqlite_app/widgets/note_card.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final _dao = NoteDao();
  List<Note> _notes = [];
  bool _loading = true;
  String? _error;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final u = await AuthService.instance.currentUsername() ?? '';
      final list = await _dao.getAll();
      setState(() {
        _username = u;
        _notes = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement : $e';
        _loading = false;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _createNote() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final note = Note(title: 'Nouvelle note', content: '', createdAt: now, updatedAt: now);
    try {
      await _dao.insert(note);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note créée.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> _edit(Note note) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EditNoteScreen(noteId: note.id!)),
    );
    await _load();
  }

  Future<void> _delete(Note note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la note ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _dao.delete(note.id!);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note supprimée.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes notes'),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(_username.isNotEmpty ? 'Bonjour, $_username' : ''),
          )),
          IconButton(
            tooltip: 'Se déconnecter',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _notes.isEmpty
                  ? const Center(child: Text('Aucune note. Appuyez sur + pour en créer.'))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder: (ctx, i) {
                          final n = _notes[i];
                          return NoteCard(
                            note: n,
                            onTap: () => _edit(n),
                            onDelete: () => _delete(n),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
