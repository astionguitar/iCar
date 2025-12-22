import 'package:flutter/material.dart';
import 'package:icar/models/workshop.dart';
import 'package:icar/screens/workshops/workshop_detail_screen.dart';
import 'package:icar/screens/workshops/workshops_by_category_screen.dart';
import 'package:icar/services/supabase_service.dart';
import 'package:icar/services/workshop_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // 🔹 APP BAR
      appBar: AppBar(
        title: const Text('iCar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await SupabaseService().signOut();
            },
          ),
        ],
      ),

      body: _currentIndex == 0 ? _homeContent() : _perfil(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // ================= HOME =================

  Widget _homeContent() {
    return FutureBuilder<List<Workshop>>(
      future: WorkshopService().getActiveWorkshops(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma oficina encontrada'));
        }

        final workshops = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _searchBox(),
            const SizedBox(height: 16),
            _categories(),
            const SizedBox(height: 24),
            _sectionTitle('Oficinas próximas'),
            const SizedBox(height: 12),

            ...workshops.map((w) => _workshopCard(w)),
          ],
        );
      },
    );
  }

  Widget _searchBox() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar serviços ou oficinas',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _categories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Category(
          icon: Icons.build,
          label: 'Mecânica',
          onTap: () => _openCategory('mecanica'),
        ),
        _Category(
          icon: Icons.bolt,
          label: 'Elétrica',
          onTap: () => _openCategory('eletrica'),
        ),
        _Category(
          icon: Icons.tire_repair,
          label: 'Pneus',
          onTap: () => _openCategory('pneu'),
        ),
        _Category(
          icon: Icons.local_shipping,
          label: 'Guincho',
          onTap: () => _openCategory('guincho'),
        ),
      ],
    );
  }

  void _openCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkshopsByCategoryScreen(category: category),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _workshopCard(Workshop w) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: w.isPremium ? Colors.amber : Colors.blue,
          child: const Icon(Icons.build, color: Colors.white),
        ),
        title: Text(w.name),
        subtitle: Text('${w.type} • ${w.neighborhood}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkshopDetailScreen(
                name: w.name,
                category: w.type,
                region: w.neighborhood,
                phone: w.phone,
                latitude: w.latitude,
                longitude: w.longitude,
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= PERFIL =================

  Widget _perfil() {
    return const Center(
      child: Text(
        'Perfil (em breve)',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

// ================= CATEGORY BUTTON =================

class _Category extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Category({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
