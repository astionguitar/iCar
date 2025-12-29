import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/workshop.dart';
import '../../services/workshop_service.dart';
import '../../services/vehicle_prompt_logic.dart';
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

  String _searchText = '';
  String _selectedCategory = 'Todos';

  bool get isLogged =>
      Supabase.instance.client.auth.currentUser != null;

  @override
  void initState() {
    super.initState();
    _loadWorkshops();
    _checkVehiclePrompt(); // 👈 AQUI ESTÁ O GATILHO
  }

  Future<void> _loadWorkshops() async {
    final data = await _service.getActiveWorkshops();
    setState(() {
      _workshops = data;
      _loading = false;
    });
  }

  // ================= POPUP =================

  Future<void> _checkVehiclePrompt() async {
    if (!isLogged) return;

    final shouldAsk = await VehiclePromptLogic().shouldAskForVehicle();
    if (!shouldAsk) return;

    if (!mounted) return;

    bool dontAskAgain = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastrar veículo'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Deseja cadastrar seu veículo agora?'),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: dontAskAgain,
                    onChanged: (value) {
                      setState(() {
                        dontAskAgain = value ?? false;
                      });
                    },
                    title: const Text('Não perguntar novamente'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (dontAskAgain) {
                  await VehiclePromptLogic().disablePrompt();
                }
                Navigator.pop(context);
              },
              child: const Text('Agora não'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (dontAskAgain) {
                  await VehiclePromptLogic().disablePrompt();
                }
                Navigator.pop(context);
                Navigator.pushNamed(context, '/vehicle');
              },
              child: const Text('Cadastrar agora'),
            ),
          ],
        );
      },
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHeader(context),
      bottomNavigationBar: isLogged ? _buildFooter(context) : null,
      body: _buildBody(),
    );
  }

  // ================= HEADER =================

  AppBar _buildHeader(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: InkWell(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (_) => false,
          );
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

  // ================= FOOTER =================

  Widget _buildFooter(BuildContext context) {
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

  // ================= BODY =================

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _workshops.where((w) {
      final text = _searchText.toLowerCase();

      final matchText =
          w.name.toLowerCase().contains(text) ||
          w.neighborhood.toLowerCase().contains(text) ||
          w.city.toLowerCase().contains(text);

      final matchCategory =
          _selectedCategory == 'Todos' ||
          w.type.toLowerCase().contains(_selectedCategory.toLowerCase());

      return matchText && matchCategory;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHero(),
        const SizedBox(height: 16),
        _buildSearch(),
        const SizedBox(height: 12),
        _buildCategories(),
        const SizedBox(height: 24),
        const Text(
          'Oficinas Recomendadas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const Center(child: Text('Nenhuma oficina encontrada')),
        ...filtered.map(_buildCard),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3556D8),
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

  Widget _buildSearch() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchText = value;
        });
      },
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

  Widget _buildCategories() {
    final categories = ['Todos', 'Mecânica', 'Elétrica', 'Funilaria', 'Pneus'];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = _selectedCategory == cat;

          return ChoiceChip(
            label: Text(cat),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = cat;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(Workshop w) {
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
}
