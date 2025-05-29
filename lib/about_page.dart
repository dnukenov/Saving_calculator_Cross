import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Saving Calculator is your smart companion for managing personal finances. '
          'It helps you track your savings, plan budgets, and set financial goals with ease. '
          'Whether you’re preparing for a vacation, an emergency fund, or your dream purchase — '
          'we’ve got you covered. Save wisely, live fully.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
