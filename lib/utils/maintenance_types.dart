class MaintenanceType {
  final String title;
  final int defaultIntervalMonths;

  const MaintenanceType({
    required this.title,
    required this.defaultIntervalMonths,
  });
}

const List<MaintenanceType> maintenanceTypes = [
  MaintenanceType(title: 'Troca de óleo', defaultIntervalMonths: 6),
  MaintenanceType(title: 'Filtro de óleo', defaultIntervalMonths: 6),
  MaintenanceType(title: 'Filtro de ar', defaultIntervalMonths: 12),
  MaintenanceType(title: 'Pastilha de freio', defaultIntervalMonths: 18),
  MaintenanceType(title: 'Disco de freio', defaultIntervalMonths: 24),
  MaintenanceType(title: 'Correia dentada', defaultIntervalMonths: 48),
  MaintenanceType(title: 'Revisão geral', defaultIntervalMonths: 12),
  MaintenanceType(title: 'Alinhamento e balanceamento', defaultIntervalMonths: 12),
];
