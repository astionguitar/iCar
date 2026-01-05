import 'package:flutter/material.dart';

import '../../services/vehicle_maintenance_service.dart';

class VehicleMaintenanceFormScreen extends StatefulWidget {
  final String userVehicleId;
  final int currentKm;

  /// Se vier preenchido -> modo EDIÇÃO
  final Map<String, dynamic>? existing;

  const VehicleMaintenanceFormScreen({
    super.key,
    required this.userVehicleId,
    required this.currentKm,
    this.existing,
  });

  @override
  State<VehicleMaintenanceFormScreen> createState() =>
      _VehicleMaintenanceFormScreenState();
}

class _VehicleMaintenanceFormScreenState
    extends State<VehicleMaintenanceFormScreen> {
  final _service = VehicleMaintenanceService();
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _km = TextEditingController();

  bool _saving = false;

  /// ✅ trava autovalidação: só começa depois do usuário clicar em salvar
  bool _submitted = false;

  DateTime _serviceDate = DateTime.now();

  final List<String> _suggestions = const [
    'Troca de óleo',
    'Filtro de óleo',
    'Filtro de ar',
    'Filtro de combustível',
    'Pastilhas de freio',
    'Discos de freio',
    'Alinhamento e balanceamento',
    'Troca de pneus',
    'Bateria',
    'Velas',
    'Correia dentada',
    'Revisão geral',
  ];

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();

    if (_isEdit) {
      final e = widget.existing!;
      _title.text = (e['title'] ?? '').toString();
      _desc.text = (e['description'] ?? '').toString();
      _km.text = (e['km_at_service'] ?? '').toString();

      final d = (e['service_date'] ?? '').toString();
      if (d.length >= 10) {
        final parts = d.substring(0, 10).split('-');
        if (parts.length == 3) {
          _serviceDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _km.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _serviceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (picked != null) {
      setState(() => _serviceDate = picked);
    }
  }

  void _applySuggestion(String text) {
    _title.text = text;
    setState(() {});
  }

  String? _validateTitle(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return 'Informe o título';
    return null;
  }

  String? _validateKm(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Informe o KM';

    final km = int.tryParse(s);
    if (km == null) return 'KM inválido';

    // ✅ validação do seu print: km < km atual do veículo
    if (km < widget.currentKm) {
      return 'O KM informado é menor que o KM atual do veículo (${widget.currentKm})';
    }

    return null;
  }

  Future<void> _save() async {
    setState(() => _submitted = true);

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      // ✅ aqui NÃO tem SnackBar, evita “loop visual”
      return;
    }

    final kmValue = int.parse(_km.text.trim());
    final titleValue = _title.text.trim();
    final descValue = _desc.text.trim();

    setState(() => _saving = true);

    try {
      if (_isEdit) {
        await _service.updateMaintenance(
          id: widget.existing!['id'].toString(),
          title: titleValue,
          description: descValue,
          kmAtService: kmValue,
          serviceDate: _serviceDate,
        );
      } else {
        await _service.createMaintenance(
          userVehicleId: widget.userVehicleId,
          title: titleValue,
          description: descValue,
          kmAtService: kmValue,
          serviceDate: _serviceDate,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEdit
                  ? 'Manutenção atualizada com sucesso'
                  : 'Manutenção registrada com sucesso',
            ),
          ),
        );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Editar manutenção' : 'Nova manutenção')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode:
              _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: ListView(
            children: [
              // ✅ Sugestões rápidas
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((s) {
                  final selected = _title.text.trim().toLowerCase() == s.toLowerCase();
                  return ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (_) => _applySuggestion(s),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: _validateTitle,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _km,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'KM da manutenção'),
                validator: _validateKm,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data: ${_serviceDate.toIso8601String().substring(0, 10)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Alterar data'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Salvando...' : 'Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
