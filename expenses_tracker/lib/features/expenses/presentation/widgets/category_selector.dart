import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_theme.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const Map<String, IconData> categories = {
    'Groceries': Icons.shopping_cart,
    'Entertainment': Icons.movie,
    'Gas': Icons.local_gas_station,
    'Shopping': Icons.shopping_bag,
    'News Paper': Icons.newspaper,
    'Transport': Icons.directions_car,
    'Rent': Icons.home,
  };

  static IconData getCategoryIcon(String category) {
    return categories[category] ?? Icons.category;
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Groceries':
        return AppTheme.categoryGroceries;
      case 'Entertainment':
        return AppTheme.categoryEntertainment;
      case 'Gas':
        return AppTheme.categoryGas;
      case 'Shopping':
        return AppTheme.categoryShopping;
      case 'Transport':
        return AppTheme.categoryTransport;
      case 'Rent':
        return AppTheme.categoryRent;
      default:
        return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 1.5.w,
        mainAxisSpacing: 1.5.h,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return _CategoryItem(
            label: 'Add Category',
            icon: Icons.add,
            color: AppTheme.textLight,
            isSelected: false,
            onTap: () {},
          );
        }

        final category = categories.keys.elementAt(index);
        final icon = categories[category]!;
        final color = getCategoryColor(category);

        return _CategoryItem(
          label: category,
          icon: icon,
          color: color,
          isSelected: selectedCategory == category,
          onTap: () => onCategorySelected(category),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 7.5.h,
            height: 7.5.h,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(1.5.h),
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 3.5.h,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
