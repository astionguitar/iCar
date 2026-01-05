import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/vehicle_brand_service.dart';
import '../../services/vehicle_model_service.dart';
import '../../services/user_vehicle_service.dart';

class VehicleSetupScreen extends StatefulWidget {
  const VehicleSetupScreen({super.key});

  @override
  State<VehicleSetupScreen> createState() => _VehicleSetupScreenState();
}

class _VehicleSetupScreenState extends State<VehicleSetupScreen> {
  final _brandService = VehicleBrandService();
  final _modelService = VehicleModelService();
  final _vehicleService = UserVehicleService();

  List<Map<String, dynamic>> brands = [];
  List<Map<String, dynamic>> models = [];

  String? selectedBrandId;
  String? selectedModelId;
  int? selectedYear;
  final kmController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    brands = await _brandService.fetchBrands();
    setState(() => loading = false);
  }

  Future<void> _loadModels(String brandId) async {
    models = await _modelService.fetchModelsByBrand(brandId);
    selectedModelId = null;
    setState(() {});
  }

  Future<void> _saveVehicle() async {
    if (selectedBrandId == null ||
        selectedModelId == null ||
        selectedYear == null ||
        kmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    await _vehicleService.upsertVehicle(
      brandId: selectedBrandId!,
      modelId: selectedModelId!,
      year: selectedYear!,
      currentKm: int.parse(kmController.text),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Marca'),
              value: selectedBrandId,
              items: brands.map((b) {
                return DropdownMenuItem<String>(
                  value: b['id'],
                  child: Text(b['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrandId = value;
                  models = [];
                });
                if (value != null) _loadModels(value);
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Modelo'),
              value: selectedModelId,
              items: models.map((m) {
                return DropdownMenuItem<String>(
                  value: m['id'],
                  child: Text(m['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedModelId = value);
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Ano'),
              value: selectedYear,
              items: List.generate(40, (i) {
                final year = DateTime.now().year - i;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) => setState(() => selectedYear = value),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'KM atual'),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _saveVehicle,
              child: const Text('Salvar veículo'),
            ),
          ],
        ),
      ),
    );
  }
}
