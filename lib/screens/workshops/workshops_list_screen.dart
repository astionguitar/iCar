// lib/screens/workshops/workshops_list_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:icar/screens/workshops/workshop_details_screen.dart';

class WorkshopsListScreen extends StatefulWidget {
  const WorkshopsListScreen({super.key});

  @override
  State<WorkshopsListScreen> createState() => _WorkshopsListScreenState();
}

class _WorkshopsListScreenState extends State<WorkshopsListScreen> {
  final supabase = Supabase.instance.client;

  List<dynamic> workshops = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkshops();
  }

  Future<void> fetchWorkshops() async {
    try {
      final response = await supabase
          .from('workshops')
          .select()
          .order('is_premium', ascending: false)
          .order('name', ascending: true);

      setState(() {
        workshops = response;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar oficinas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oficinas próximas"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchWorkshops,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: workshops.length,
                itemBuilder: (context, index) {
                  final w = workshops[index];

                  final bool isPremium = w['is_premium'] == true;
                  final String title = w['name'] ?? '';
                  final String type = w['type'] ?? '';
                  final String bairro = w['neighborhood'] ?? '';
                  final String city = w['city'] ?? '';
                  final String state = w['state'] ?? '';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    elevation: isPremium ? 6 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: isPremium
                            ? Colors.amber.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.15),
                        child: Icon(
                          Icons.build,
                          color:
                              isPremium ? Colors.amber[800] : Colors.grey[700],
                          size: 24,
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isPremium
                                    ? Colors.amber[900]
                                    : Colors.black,
                              ),
                            ),
                          ),
                          if (isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Premium',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        "$type • $bairro • $city - $state",
                        maxLines: 2,
                      ),
                      trailing:
                          const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkshopDetailsScreen(
                              workshop: w,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
