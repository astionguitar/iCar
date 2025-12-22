import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/workshop.dart';
import '../../services/workshop_service.dart';
import '../workshops/workshop_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkshopService _service = WorkshopService();

  List<Workshop> _workshops = [];
  bool _loading = true;
  int _selectedCategory = 0;

  bool get isLogged =>
      Supabase.instance.client.auth.currentUser != null;

  final List<String> categories = [
    'Todos',
    'Mecânica',
    'Elétrica',
    'Funilaria',
    'Pneus',
  ];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final data = await _service.getActiveWorkshops();
    setState(() {
      _workshops = data;
      _loading = false;
    });
  }

  Future<void> _search(String value) async {
    if (value.isEmpty) {
      _loadAll();
      return;
    }

    final result = await _service.search(value);
    setState(() {
      _workshops = result;
    });
  }

  Future<void> _filterCategory(String category) async {
    if (category == 'Todos') {
      _loadAll();
      return;
    }

    final result = await _service.getByCategory(category);
    setState(() {
      _workshops = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _header(context),
      body: _body(),
      bottomNavigationBar: isLogged ? _footer(context) : null,
    );
  }

  // ───────────────── HEADER ─────────────────

  AppBar _header(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: InkWell(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        },
        child: Row(
          children: const [
            SizedBox(width: 12),
            Icon(Icons.directions_car),
            SizedBox(width: 8),
            Text(
              'iCar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            if (isLogged) {
              Navigator.pushNamed(context, '/profile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          },
          icon: const Icon(Icons.person_outline),
          label: Text(isLogged ? 'Perfil' : 'Entrar'),
        ),
      ],
    );
  }

  // ───────────────── BODY ─────────────────

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _hero(),
        const SizedBox(height: 16),
        _searchBox(),
        const SizedBox(height: 16),
        _categories(),
        const SizedBox(height: 24),
        const Text(
          'Oficinas Recomendadas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._workshops.map(_card),
      ],
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2F55D4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Encontre a oficina ideal para o seu carro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manutenção simples, transparente e perto de você.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return TextField(
      onChanged: _search,
      decoration: InputDecoration(
        hintText: 'Buscar por nome ou endereço...',
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
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == _selectedCategory;

          return ChoiceChip(
            label: Text(categories[index]),
            selected: selected,
            onSelected: (_) {
              setState(() => _selectedCategory = index);
              _filterCategory(categories[index]);
            },
          );
        },
      ),
    );
  }

  Widget _card(Workshop w) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.build, color: Colors.white),
        ),
        title: Text(w.name),
        subtitle: Text('${w.type} • ${w.neighborhood}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkshopDetailScreen(workshop: w),
            ),
          );
        },
      ),
    );
  }

  // ───────────────── FOOTER ─────────────────

  Widget _footer(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        } else {
          Navigator.pushNamed(context, '/profile');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
