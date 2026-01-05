import 'package:flutter/material.dart';
import '../utils/maintenance_alert_calculator.dart';

class MaintenanceAlertBadge extends StatelessWidget {
  final MaintenanceAlertResult result;

  const MaintenanceAlertBadge({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (result.level) {
      case MaintenanceAlertLevel.overdue:
        color = Colors.red;
        text = 'Vencido há ${result.daysRemaining} dias';
        break;

      case MaintenanceAlertLevel.warning:
        color = Colors.orange;
        text = 'Vence em ${result.daysRemaining} dias';
        break;

      default:
        color = Colors.green;
        text = 'Em dia';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
