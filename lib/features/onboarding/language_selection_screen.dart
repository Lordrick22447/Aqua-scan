import 'package:flutter/material.dart';
import 'package:aqua_scan/core/theme/app_theme.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Language / ഭാഷ തിരഞ്ഞെടുക്കുക')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.language, size: 80, color: AppTheme.primaryColor),
            const SizedBox(height: 32),
            _buildLanguageCard(
              context,
              title: 'English',
              subtitle: 'Continue in English',
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
            const SizedBox(height: 16),
            _buildLanguageCard(
              context,
              title: 'മലയാളം',
              subtitle: 'മലയാളത്തിൽ തുടരുക',
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context,
      {required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
