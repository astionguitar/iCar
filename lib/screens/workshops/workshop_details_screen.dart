// lib/screens/workshops/workshop_details_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkshopDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> workshop;

  const WorkshopDetailsScreen({super.key, required this.workshop});

  @override
  State<WorkshopDetailsScreen> createState() => _WorkshopDetailsScreenState();
}

class _WorkshopDetailsScreenState extends State<WorkshopDetailsScreen>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  late TabController _tabController;

  bool _isFavorite = false;
  bool _loadingFavorite = true;

  List<dynamic> _services = [];
  bool _loadingServices = true;

  List<dynamic> _reviews = [];
  bool _loadingReviews = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFavorite();
    _loadServices();
    _loadReviews();
  }

  int get workshopId => widget.workshop['id'] as int;

  Future<void> _loadFavorite() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          _isFavorite = false;
          _loadingFavorite = false;
        });
        return;
      }

      final result = await supabase
          .from('favorites')
          .select()
          .eq('user_id', user.id)
          .eq('workshop_id', workshopId);

      setState(() {
        _isFavorite = result.isNotEmpty;
        _loadingFavorite = false;
      });
    } catch (e) {
      setState(() => _loadingFavorite = false);
    }
  }

  Future<void> _toggleFavorite() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faça login para favoritar oficinas.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _loadingFavorite = true;
    });

    try {
      if (_isFavorite) {
        await supabase
            .from('favorites')
            .delete()
            .eq('user_id', user.id)
            .eq('workshop_id', workshopId);
      } else {
        await supabase.from('favorites').insert({
          'user_id': user.id,
          'workshop_id': workshopId,
        });
      }

      setState(() {
        _isFavorite = !_isFavorite;
        _loadingFavorite = false;
      });
    } catch (e) {
      setState(() => _loadingFavorite = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar favorito: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadServices() async {
    try {
      final response = await supabase
          .from('services')
          .select()
          .eq('workshop_id', workshopId)
          .order('name', ascending: true);

      setState(() {
        _services = response;
        _loadingServices = false;
      });
    } catch (e) {
      setState(() => _loadingServices = false);
    }
  }

  Future<void> _loadReviews() async {
    try {
      final response = await supabase
          .from('reviews')
          .select()
          .eq('workshop_id', workshopId)
          .order('created_at', ascending: false);

      setState(() {
        _reviews = response;
        _loadingReviews = false;
      });
    } catch (e) {
      setState(() => _loadingReviews = false);
    }
  }

  Future<void> _callPhone() async {
    final phone = widget.workshop['phone']?.toString();
    if (phone == null || phone.isEmpty) return;

    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp() async {
    final whatsapp = widget.workshop['whatsapp']?.toString();
    if (whatsapp == null || whatsapp.isEmpty) return;

    final uri = Uri.parse('https://wa.me/$whatsapp');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openRoute() async {
    final lat = widget.workshop['latitude'];
    final lng = widget.workshop['longitude'];

    if (lat == null || lng == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildHeader() {
    final w = widget.workshop;
    final isPremium = w['is_premium'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade400,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: const Icon(
              Icons.build,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  w['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  w['type'] ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${w['address']}, ${w['neighborhood']} - ${w['city']}/${w['state']}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                if (isPremium)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Oficina Premium',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: _loadingFavorite
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
            onPressed: _loadingFavorite ? null : _toggleFavorite,
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _callPhone,
              icon: const Icon(Icons.call),
              label: const Text('Ligar'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _openWhatsApp,
              icon: const Icon(Icons.chat_bubble),
              label: const Text('WhatsApp'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _openRoute,
              icon: const Icon(Icons.directions),
              label: const Text('Rota'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    if (_loadingServices) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_services.isEmpty) {
      return const Center(
        child: Text('Nenhum serviço cadastrado ainda.'),
      );
    }

    return ListView.builder(
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final s = _services[index];
        final String name = s['name'] ?? '';
        final num? price = s['price'];
        final int? duration = s['duration_minutes'];

        return ListTile(
          title: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            [
              if (price != null) "R\$ ${price.toStringAsFixed(2)}",
              if (duration != null) "$duration min"
            ].join(" • "),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Futuro: abrir tela de agendamento
          },
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    if (_loadingReviews) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_reviews.isEmpty) {
      return const Center(
        child: Text('Ainda não há avaliações para esta oficina.'),
      );
    }

    return ListView.builder(
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        final r = _reviews[index];
        final double rating =
            (r['rating'] is int) ? (r['rating'] as int).toDouble() : (r['rating'] as num).toDouble();
        final String comment = r['comment'] ?? '';
        final String createdAt =
            (r['created_at'] ?? '').toString().substring(0, 10);

        return ListTile(
          leading: CircleAvatar(
            child: Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          title: Row(
            children: [
              for (int i = 1; i <= 5; i++)
                Icon(
                  i <= rating ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber[700],
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (comment.isNotEmpty) Text(comment),
              const SizedBox(height: 4),
              Text(
                createdAt,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAboutTab() {
    final w = widget.workshop;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Sobre a oficina',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          w['description'] ??
              'Oficina cadastrada no iCar. Em breve mais informações.',
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          'Endereço',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${w['address']}\n${w['neighborhood']} - ${w['city']}/${w['state']}",
        ),
        const SizedBox(height: 16),
        if (w['phone'] != null) ...[
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Contato',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text("Telefone: ${w['phone']}"),
          if (w['whatsapp'] != null)
            Text("WhatsApp: ${w['whatsapp']}"),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildActionsRow(),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue[700],
            unselectedLabelColor: Colors.grey[600],
            tabs: const [
              Tab(text: 'Serviços'),
              Tab(text: 'Avaliações'),
              Tab(text: 'Sobre'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildServicesTab(),
                _buildReviewsTab(),
                _buildAboutTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
