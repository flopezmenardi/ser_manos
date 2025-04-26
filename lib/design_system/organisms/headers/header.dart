import 'package:flutter/material.dart';
import 'package:ser_manos/design_system/atoms/icons.dart';
import 'package:ser_manos/design_system/tokens/colors.dart';

class HeaderSermanos extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const HeaderSermanos({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondary90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 41), // status bar space
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Placeholder for logo/icon
                Image.asset(
                  'assets/logo_rectangular.png', // Replace with actual logo path
                  height: 25,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTab("Postularse", 0),
              _buildTab("Mi perfil", 1),
              _buildTab("Novedades", 2),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary200 : AppColors.secondary100,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
