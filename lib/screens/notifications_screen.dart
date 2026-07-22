import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/edge_swipe_back.dart';

// Écran de gestion des notifications : une rubrique par orientation,
// et à l'intérieur, un switch par parti pour activer/désactiver ses notifs
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // État en mémoire : id du parti -> notifications activées ou non
  final Map<String, bool> _partyNotifications = {
    for (final p in MockData.parties) p.id: false,
  };

  // Vérifie si tous les partis d'une orientation ont leurs notifs activées
  bool _isOrientationFullyEnabled(String orientationId) {
    final parties = MockData.getPartiesByOrientation(orientationId);
    return parties.isNotEmpty && parties.every((p) => _partyNotifications[p.id] == true);
  }

  // Active ou désactive toutes les notifs d'une orientation d'un coup
  void _toggleOrientation(String orientationId, bool value) {
    setState(() {
      for (final p in MockData.getPartiesByOrientation(orientationId)) {
        _partyNotifications[p.id] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EdgeSwipeBack(
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: ListView(
          children: MockData.orientations.map((orientation) {
            final parties = MockData.getPartiesByOrientation(orientation.id);
            return ExpansionTile(
              leading: CircleAvatar(backgroundColor: orientation.color, radius: 8),
              title: Text(orientation.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Switch(
                value: _isOrientationFullyEnabled(orientation.id),
                onChanged: (value) => _toggleOrientation(orientation.id, value),
              ),
              children: parties.map((party) {
                return SwitchListTile(
                  title: Text(party.name),
                  contentPadding: const EdgeInsets.only(left: 32, right: 16),
                  value: _partyNotifications[party.id] ?? false,
                  onChanged: (value) {
                    setState(() => _partyNotifications[party.id] = value);
                  },
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}