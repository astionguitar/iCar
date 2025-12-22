import 'package:flutter/material.dart';
import 'package:icar/models/workshop.dart';
import 'package:icar/screens/workshops/workshop_detail_screen.dart';
import 'package:icar/services/workshop_service.dart';

class WorkshopsByCategoryScreen extends StatelessWidget {
  final String category;

  const WorkshopsByCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: FutureBuilder<List<Workshop>>(
        future: WorkshopService().getByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma oficina encontrada'));
          }

          final workshops = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workshops.length,
            itemBuilder: (_, i) {
              final w = workshops[i];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: w.isPremium ? Colors.amber : Colors.blue,
                    child: const Icon(Icons.build, color: Colors.white),
                  ),
                  title: Text(w.name),
                  subtitle: Text(w.neighborhood),
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
            },
          );
        },
      ),
    );
  }
}
