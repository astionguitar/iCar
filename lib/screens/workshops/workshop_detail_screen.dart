import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkshopDetailScreen extends StatelessWidget {
  final String name;
  final String category;
  final String region;
  final String phone;
  final double? latitude;
  final double? longitude;

  const WorkshopDetailScreen({
    super.key,
    required this.name,
    required this.category,
    required this.region,
    required this.phone,
    this.latitude,
    this.longitude,
  });

  void _callPhone() async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/55$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openMaps() async {
    if (latitude == null || longitude == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text('$category • $region'),

            const SizedBox(height: 16),

            Row(
              children: const [
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star, color: Colors.orange),
                Icon(Icons.star_half, color: Colors.orange),
                SizedBox(width: 8),
                Text('4.5'),
              ],
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _callPhone,
              icon: const Icon(Icons.call),
              label: const Text('Ligar'),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _openWhatsApp,
              icon: const Icon(Icons.chat),
              label: const Text('WhatsApp'),
            ),
            const SizedBox(height: 12),

            if (latitude != null && longitude != null)
              ElevatedButton.icon(
                onPressed: _openMaps,
                icon: const Icon(Icons.map),
                label: const Text('Ver no mapa'),
              ),
          ],
        ),
      ),
    );
  }
}
