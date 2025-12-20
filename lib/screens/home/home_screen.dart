// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:icar/screens/workshops/workshops_list_screen.dart';
import 'package:icar/services/supabase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await SupabaseService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return const WorkshopsListScreen();
  }
}
