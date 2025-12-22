import 'package:flutter/material.dart';
import 'package:icar/models/workshop.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkshopDetailScreen extends StatelessWidget {
  final Workshop workshop;

  const WorkshopDetailScreen({
    super.key,
    required this.workshop,
  });


  Future<void> _callWorkshop() async {
    final uri = Uri.parse('tel:${workshop.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp() async {
    if (workshop.whatsapp == null || workshop.whatsapp!.isEmpty) return;

    final uri = Uri.parse('https://wa.me/${workshop.whatsapp}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openMap() async {
    if (workshop.latitude == null || workshop.longitude == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${workshop.latitude},${workshop.longitude}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workshop.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workshop.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              '${workshop.type} • ${workshop.neighborhood}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  workshop.rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _callWorkshop,
                  icon: const Icon(Icons.phone),
                  label: const Text('Ligar'),
                ),

                if (workshop.whatsapp != null &&
                    workshop.whatsapp!.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: _openWhatsApp,
                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    label: const Text('WhatsApp'),
                  ),

                if (workshop.latitude != null &&
                    workshop.longitude != null)
                  ElevatedButton.icon(
                    onPressed: _openMap,
                    icon: const Icon(Icons.map),
                    label: const Text('Mapa'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
