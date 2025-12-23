import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/workshop.dart';

class WorkshopDetailScreen extends StatelessWidget {
  final Workshop workshop;

  const WorkshopDetailScreen({super.key, required this.workshop});

  bool get isLogged =>
      Supabase.instance.client.auth.currentUser != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workshop.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              workshop.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${workshop.type} • ${workshop.neighborhood}'),

            const SizedBox(height: 24),

            _actionButton(
              context,
              icon: Icons.calendar_month,
              label: 'Agendar serviço',
              onTap: () => _requireLogin(context),
            ),

            _actionButton(
              context,
              icon: Icons.favorite_border,
              label: 'Favoritar',
              onTap: () => _requireLogin(context),
            ),

            _actionButton(
              context,
              icon: Icons.star_border,
              label: 'Avaliar',
              onTap: () => _requireLogin(context),
            ),

            const Divider(height: 32),

            /// CONTATO — VISÍVEL PRA TODOS
            const Text(
              'Contato',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Ligar'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _launch('tel:${workshop.phone}'),
            ),

            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('WhatsApp'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _launch('https://wa.me/55${workshop.phone}'),
            ),

            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Ver no mapa'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _launch(
                'https://www.google.com/maps/search/${Uri.encodeComponent('${workshop.name} ${workshop.neighborhood}')}',
              ),
            ),

            const Divider(height: 32),

            /// AVALIAÇÕES — VISÍVEL PRA TODOS
            const Text(
              'Avaliações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _review(
              name: 'Carlos M.',
              comment: 'Atendimento rápido e honesto.',
              stars: 5,
            ),
            _review(
              name: 'Ana P.',
              comment: 'Preço justo e serviço bem feito.',
              stars: 4,
            ),
          ],
        ),
      ),
    );
  }

  // ===== COMPONENTES =====

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _review({
    required String name,
    required String comment,
    required int stars,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(name),
        subtitle: Text(comment),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            stars,
            (_) => const Icon(Icons.star, size: 16, color: Colors.amber),
          ),
        ),
      ),
    );
  }

  // ===== LOGIN GATE =====

  void _requireLogin(BuildContext context) {
    if (isLogged) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 40),
              const SizedBox(height: 16),
              const Text(
                'Login necessário',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Para continuar, você precisa estar logado no iCar.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Entrar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Agora não'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
