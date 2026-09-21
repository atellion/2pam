import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  await Supabase.initialize(
    url: 'https://edcrimhkwdsunvsnmaxb.supabase.co',
    publishableKey: 'sb_publishable_L9UIurI9uYrTmKnZbbTk2g_76TrsaOq',
  );

  runApp(const KalenderAsistenApp());
}

final supabase = Supabase.instance.client;

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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;

        if (session != null) {
          return HomePage(onLogout: () async {
            await supabase.auth.signOut();
          });
        }
        return LoginPage(onLogin: () {});
      },
    );
  }
}