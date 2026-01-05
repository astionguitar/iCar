enum MaintenanceAlertLevel {
  ok,
  warning,
  overdue,
}

class MaintenanceAlertResult {
  final DateTime nextDueDate;
  final int daysRemaining;
  final bool isOverdue;
  final MaintenanceAlertLevel level;

  MaintenanceAlertResult({
    required this.nextDueDate,
    required this.daysRemaining,
    required this.isOverdue,
    required this.level,
  });
}

MaintenanceAlertResult calculateMaintenanceAlert({
  required DateTime serviceDate,
  required int intervalMonths,
}) {
  final nextDueDate = DateTime(
    serviceDate.year,
    serviceDate.month + intervalMonths,
    serviceDate.day,
  );

  final now = DateTime.now();
  final daysRemaining = nextDueDate.difference(now).inDays;

  if (daysRemaining < 0) {
    return MaintenanceAlertResult(
      nextDueDate: nextDueDate,
      daysRemaining: daysRemaining.abs(),
      isOverdue: true,
      level: MaintenanceAlertLevel.overdue,
    );
  }

  if (daysRemaining <= 15) {
    return MaintenanceAlertResult(
      nextDueDate: nextDueDate,
      daysRemaining: daysRemaining,
      isOverdue: false,
      level: MaintenanceAlertLevel.warning,
    );
  }

  return MaintenanceAlertResult(
    nextDueDate: nextDueDate,
    daysRemaining: daysRemaining,
    isOverdue: false,
    level: MaintenanceAlertLevel.ok,
  );
}
