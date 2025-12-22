import 'package:flutter/material.dart';
import 'package:icar/screens/workshops/workshops_list_screen.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iCar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // depois ligamos no Supabase
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'O que você precisa agora?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // GRID DE SERVIÇOS (estilo iFood)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _ServiceCard(
                  icon: Icons.build,
                  label: 'Mecânica',
                  onTap: () {
                    _openWorkshops(context);
                  },
                ),
                _ServiceCard(
                  icon: Icons.tire_repair,
                  label: 'Pneus',
                  onTap: () {
                    _openWorkshops(context);
                  },
                ),
                _ServiceCard(
                  icon: Icons.flash_on,
                  label: 'Elétrica',
                  onTap: () {
                    _openWorkshops(context);
                  },
                ),
                _ServiceCard(
                  icon: Icons.local_shipping,
                  label: 'Guincho',
                  onTap: () {
                    _openWorkshops(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Oficinas próximas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: WorkshopsListScreen(),
            ),
          ],
        ),
      ),
    );
  }

  static void _openWorkshops(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WorkshopsListScreen(),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
