import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_design_tokens.dart';
import '../bloc/expenses_bloc.dart';
import '../bloc/expenses_event.dart';

class ExpensesEmptyState extends StatelessWidget {
  const ExpensesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 10.h,
              color: AppTheme.textLight,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.noExpensesYet,
              style: TextStyle(
                fontSize: AppFontSize.subtitle,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () => _addSampleData(context),
              icon: const Icon(Icons.add),
              label: Text(AppStrings.addSampleData),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSampleData(BuildContext context) {
    // Clean - just trigger the event
    // Business logic is in the use case layer
    context.read<ExpensesBloc>().add(const AddSampleDataEvent());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.sampleDataAdded),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
