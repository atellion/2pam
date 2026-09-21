import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';


import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  runApp(const KalenderAsistenApp());
}

class KalenderAsistenApp extends StatelessWidget {
  const KalenderAsistenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalender & Asisten',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF574964)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F6F8),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const AppGate(),
    );
  }
}

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool? loggedIn;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => loggedIn = prefs.getBool(SessionService.key) ?? false);
  }

  @override
  Widget build(BuildContext context) {
    if (loggedIn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return loggedIn!
        ? HomePage(onLogout: _loadSession)
        : LoginPage(onLogin: _loadSession);
  }
}
