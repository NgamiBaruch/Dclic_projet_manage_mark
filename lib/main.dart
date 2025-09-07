import 'package:flutter/material.dart';
import 'package:flutter_notes_sqlite_app/screens/login_screen.dart';
import 'package:flutter_notes_sqlite_app/screens/notes_list_screen.dart';
import 'package:flutter_notes_sqlite_app/theme/app_theme.dart';
import 'package:flutter_notes_sqlite_app/data/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NotesApp());
}

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  bool _loading = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final authed = await AuthService.instance.isLoggedIn();
    setState(() {
      _loggedIn = authed;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: AppTheme.light,
      home: _loggedIn ? const NotesListScreen() : const LoginScreen(),
    );
  }
}
