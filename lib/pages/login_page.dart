import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/session_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({
    super.key,
    required this.onLogin,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simulasi proses login.
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    final username =
        usernameController.text.trim();

    final password =
        passwordController.text;

    // Login sementara untuk development.
    //
    // Username : admin
    // Password : admin123
    if (username == 'admin' &&
        password == 'admin123') {
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setBool(
        SessionService.key,
        true,
      );

      if (!mounted) return;

      widget.onLogin();
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username atau password salah.',
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [
                  const Icon(
                    Icons.calendar_month,
                    size: 90,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Kalender & Asisten',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Silakan login untuk melanjutkan',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller:
                        usernameController,

                    decoration:
                        const InputDecoration(
                      labelText: 'Username',
                      prefixIcon:
                          Icon(Icons.person),
                    ),

                    textInputAction:
                        TextInputAction.next,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Username wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller:
                        passwordController,

                    obscureText:
                        obscurePassword,

                    decoration:
                        InputDecoration(
                      labelText: 'Password',

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      suffixIcon:
                          IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons
                                  .visibility_off,
                        ),

                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),
                    ),

                    onFieldSubmitted: (_) {
                      _login();
                    },

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return 'Password wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  FilledButton.icon(
                    onPressed: isLoading
                        ? null
                        : _login,

                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.login,
                          ),

                    label: Text(
                      isLoading
                          ? 'Memproses...'
                          : 'Login',
                    ),

                    style:
                        FilledButton.styleFrom(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),

                      child: Column(
                        children: [
                          const Text(
                            'Akun Demo',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Username: admin\n'
                            'Password: admin123',
                            textAlign:
                                TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}