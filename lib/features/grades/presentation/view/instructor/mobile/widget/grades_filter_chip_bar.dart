import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';
import 'package:sams_app/core/utils/styles/app_styles.dart';

class GradesFilterChipBar extends StatelessWidget {
  const GradesFilterChipBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (_) => onFilterChanged(filter),
              backgroundColor: AppColors.whiteLight,
              selectedColor: AppColors.primaryLightActive,
              checkmarkColor: AppColors.primaryDark,
              labelStyle: AppStyles.mobileBodyXsmallMd.copyWith(
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.whiteDarkHover,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.whiteHover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
