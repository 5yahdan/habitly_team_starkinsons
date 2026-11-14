import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';
import 'home_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(username: _usernameController.text.trim()),
        ),
        (route) => false,
      );
    }
  }

  InputDecoration _fieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: HabitlyColors.muted, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFE9DCC6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: HabitlyColors.terracotta,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: HabitlyColors.ink,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back arrow
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.chevron_left,
                    color: HabitlyColors.terracotta,
                    size: 30,
                  ),
                  tooltip: 'Back',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Heading
                      Text(
                        'Create your account',
                        style: GoogleFonts.fraunces(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: HabitlyColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'A username and password is all it takes.',
                        style: TextStyle(
                          fontSize: 14,
                          color: HabitlyColors.muted,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Username
                      _label('Username'),
                      TextFormField(
                        controller: _usernameController,
                        decoration: _fieldStyle('e.g. alexmakes'),
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Please enter a username'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Password
                      _label('Password'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        decoration: _fieldStyle('At least 8 characters')
                            .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: HabitlyColors.muted,
                                ),
                                tooltip: _hidePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () => setState(
                                  () => _hidePassword = !_hidePassword,
                                ),
                              ),
                            ),
                        validator: (value) =>
                            (value == null || value.length < 8)
                            ? 'Password must be at least 8 characters'
                            : null,
                      ),
                      const SizedBox(height: 32),

                      // Create button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _createAccount,
                          style: FilledButton.styleFrom(
                            backgroundColor: HabitlyColors.terracotta,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Create username & password',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
