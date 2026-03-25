import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class ValueProposition extends StatelessWidget {
  final bool isMobile;
  const ValueProposition({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Your Work, Intelligently Journaled.',
        textAlign: TextAlign.center,
        style: AppFonts.plusJakartaSans(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: Colors.white,
          letterSpacing: -0.9,
        ),
      ),
    );
  }
}
