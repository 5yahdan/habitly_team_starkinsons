import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';
import 'registration_page.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 24, 24),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Small logo
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: HabitlyColors.terracotta,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'H',
                          style: GoogleFonts.fraunces(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Heading
                      Text(
                        'Continue with Google',
                        style: GoogleFonts.fraunces(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: HabitlyColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign in with your Google account. No new password to remember.',
                        style: TextStyle(
                          fontSize: 14,
                          color: HabitlyColors.muted,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // What Habitly uses
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9DCC6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Habitly will use',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: HabitlyColors.ink,
                              ),
                            ),
                            SizedBox(height: 14),
                            _InfoRow(
                              icon: Icons.person_outline,
                              text: 'Your name, for your greeting',
                            ),
                            SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.mail_outline,
                              text: 'Your email address, to sign you in',
                            ),
                          ],
                        ),
                      ),

                      // Pushes the buttons to the bottom
                      const Spacer(),

                      // Main button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Google sign-in is coming soon'),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: HabitlyColors.terracotta,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Choose a Google account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Switch to username sign-up
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegistrationPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: HabitlyColors.terracotta,
                          ),
                          child: const Text(
                            'Use a username instead',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One line in the "Habitly will use" card: an icon and a short text.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: HabitlyColors.terracotta),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: HabitlyColors.ink),
          ),
        ),
      ],
    );
  }
}
