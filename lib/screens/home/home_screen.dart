import 'package:flutter/material.dart';
import 'package:icar/models/workshop.dart';
import 'package:icar/services/workshop_service.dart';
import 'package:icar/screens/workshops/workshop_detail_screen.dart';
import 'package:icar/screens/auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorkshopService _service = WorkshopService();

  List<Workshop> _workshops = [];
  bool _loading = true;
  String _selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadWorkshops();
  }

  Future<void> _loadWorkshops() async {
    final data = await _service.getActiveWorkshops();
    setState(() {
      _workshops = data;
      _loading = false;
    });
  }

  Future<void> _search(String value) async {
    final result = await _service.search(value);
    setState(() => _workshops = result);
  }

  bool get _isLogged =>
      Supabase.instance.client.auth.currentSession != null;

  void _goLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.directions_car, color: Color(0xFF2F55D4)),
        onPressed: () {
          // ÍCONE iCar → HOME
          _loadWorkshops();
        },
      ),
      title: const Text(
        'iCar',
        style: TextStyle(
          color: Color(0xFF2F55D4),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: _isLogged ? () {} : _goLogin,
          icon: const Icon(Icons.person, color: Color(0xFF2F55D4)),
          label: Text(
            _isLogged ? 'Perfil' : 'Entrar',
            style: const TextStyle(color: Color(0xFF2F55D4)),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _hero(),
        const SizedBox(height: 24),
        _searchBox(),
        const SizedBox(height: 16),
        _categories(),
        const SizedBox(height: 24),
        const Text(
          'Oficinas Recomendadas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _workshopList(),
      ],
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF2F55D4), Color(0xFF3F6AE0)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Encontre a oficina ideal para o seu carro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
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
    final categories = [
      'Todos',
      'Mecânica',
      'Elétrica',
      'Troca de Óleo',
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = categories[i];
          final selected = cat == _selectedCategory;

          return ChoiceChip(
            label: Text(cat),
            selected: selected,
            onSelected: (_) async {
              setState(() => _selectedCategory = cat);

              if (cat == 'Todos') {
                _loadWorkshops();
              } else {
                final result = await _service.getByCategory(cat);
                setState(() => _workshops = result);
              }
            },
          );
        },
      ),
    );
  }

  Widget _workshopList() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_workshops.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: Center(child: Text('Nenhuma oficina encontrada')),
      );
    }

    return Column(
      children: _workshops
          .map((w) => _workshopCard(w))
          .toList(),
    );
  }

  Widget _workshopCard(Workshop workshop) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              workshop.isPremium ? Colors.orange : Colors.blue,
          child: const Icon(Icons.build, color: Colors.white),
        ),
        title: Text(workshop.name),
        subtitle:
            Text('${workshop.type} • ${workshop.neighborhood}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  WorkshopDetailScreen(workshop: workshop),
            ),
          );
        },
      ),
    );
  }
}
