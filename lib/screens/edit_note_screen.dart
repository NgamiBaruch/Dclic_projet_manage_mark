import 'package:flutter/material.dart';
import 'package:flutter_notes_sqlite_app/data/note.dart';
import 'package:flutter_notes_sqlite_app/data/note_dao.dart';
import 'package:flutter_notes_sqlite_app/utils/validators.dart';

class EditNoteScreen extends StatefulWidget {
  final int noteId;
  const EditNoteScreen({super.key, required this.noteId});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _dao = NoteDao();
  bool _loading = true;
  String? _error;
  Note? _note;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final n = await _dao.getById(widget.noteId);
      setState(() {
        _note = n;
        _titleCtrl.text = n?.title ?? '';
        _contentCtrl.text = n?.content ?? '';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement : $e';
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final updated = _note!.copyWith(
        title: _titleCtrl.text.trim(),
        content: _contentCtrl.text.trim(),
        updatedAt: now,
      );
      await _dao.update(updated);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Modifications enregistrées.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Édition de la note')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleCtrl,
                          decoration: const InputDecoration(labelText: 'Titre'),
                          validator: (v) => Validators.notEmpty(v),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _contentCtrl,
                            decoration: const InputDecoration(labelText: 'Contenu'),
                            maxLines: null,
                            expands: true,
                            keyboardType: TextInputType.multiline,
                            validator: (v) => Validators.notEmpty(v),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Annuler'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _save,
                                child: const Text('Enregistrer'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
