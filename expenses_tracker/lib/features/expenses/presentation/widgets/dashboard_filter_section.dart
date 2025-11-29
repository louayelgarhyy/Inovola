import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'filter_chip.dart';

class DashboardFilterSection extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const DashboardFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChipWidget(
                label: 'This Month',
                isSelected: selectedFilter == 'this_month',
                onTap: () => onFilterChanged('this_month'),
              ),
              SizedBox(width: 1.w),
              FilterChipWidget(
                label: 'Last 7 Days',
                isSelected: selectedFilter == 'last_7_days',
                onTap: () => onFilterChanged('last_7_days'),
              ),
              SizedBox(width: 1.w),
              FilterChipWidget(
                label: 'All Time',
                isSelected: selectedFilter == 'all',
                onTap: () => onFilterChanged('all'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
