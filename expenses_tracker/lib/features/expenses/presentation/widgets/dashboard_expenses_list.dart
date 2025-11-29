import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/expenses_state.dart';
import 'expense_list_item.dart';
import 'expenses_list_header.dart';
import 'expenses_empty_state.dart';
import 'expenses_loading_state.dart';

class DashboardExpensesList extends StatelessWidget {
  final ExpensesState state;
  final ScrollController scrollController;

  const DashboardExpensesList({required this.state, required this.scrollController, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        const ExpensesListHeader(),
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (state is ExpensesLoading) {
      return const ExpensesLoadingState();
    }

    if (state is ExpensesLoaded) {
      final loadedState = state as ExpensesLoaded;

      if (loadedState.expenses.isEmpty) {
        return const ExpensesEmptyState();
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index < loadedState.expenses.length) {
              return ExpenseListItem(expense: loadedState.expenses[index]);
            } else if (loadedState.hasMore) {
              return Padding(
                padding: EdgeInsets.all(2.h),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return null;
          },
          childCount: loadedState.expenses.length + (loadedState.hasMore ? 1 : 0),
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
