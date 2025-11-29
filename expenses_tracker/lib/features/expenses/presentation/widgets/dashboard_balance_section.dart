import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../bloc/expenses_state.dart';
import 'balance_card.dart';

class DashboardBalanceSection extends StatelessWidget {
  final ExpensesState state;

  const DashboardBalanceSection({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loadedState = state is ExpensesLoaded ? state as ExpensesLoaded : null;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        child: BalanceCard(
          totalBalance: loadedState?.totalBalance ?? 0,
          income: loadedState?.totalIncome ?? 0,
          expenses: loadedState?.totalExpenses ?? 0,
        ),
      ),
    );
  }
}
