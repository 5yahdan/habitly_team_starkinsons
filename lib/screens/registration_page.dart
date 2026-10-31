import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 24),
          child: Text(
            'Create your account',
            style: GoogleFonts.fraunces(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: HabitlyColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
