// lib/features/home/widgets/floating_nav_item.dart
import 'package:flutter/material.dart';

class FloatingNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? iconColor;

  const FloatingNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? (isActive ? Colors.green : Colors.grey);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
