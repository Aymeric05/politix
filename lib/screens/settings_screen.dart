import 'package:flutter/material.dart';
import '../widgets/edge_swipe_back.dart';
import 'notifications_screen.dart';

// Écran des paramètres, pour l'instant : accès aux réglages de notifications
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EdgeSwipeBack(
      child: Scaffold(
        appBar: AppBar(title: const Text('Paramètres')),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notifications'),
              subtitle: const Text('Choisir les partis à suivre'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}