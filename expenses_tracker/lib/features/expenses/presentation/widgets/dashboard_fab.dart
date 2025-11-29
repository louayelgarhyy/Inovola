import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_theme.dart';

class DashboardFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const DashboardFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppTheme.primaryBlue,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 3.h,
      ),
    );
  }
}
