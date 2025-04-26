import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';
import 'package:ser_manos/design_system/atoms/icons.dart'; // Assuming `getMapIcon` lives here

class CurrentVolunteerCardSermanos extends StatelessWidget {
  final String category;
  final String name;

  const CurrentVolunteerCardSermanos({
    super.key,
    required this.category,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary5,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.neutral75,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.neutral100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          AppIcons.getMapIcon(state: IconState.enabled), // Your custom map icon
        ],
      ),
    );
  }
}
