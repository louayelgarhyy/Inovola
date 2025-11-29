import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expenses_bloc.dart';
import '../bloc/expenses_event.dart';
import '../bloc/expenses_state.dart';
import '../widgets/dashboard_balance_section.dart';
import '../widgets/dashboard_expenses_list.dart';
import '../widgets/dashboard_fab.dart';
import '../widgets/dashboard_filter_section.dart';
import '../widgets/dashboard_header.dart';
import 'add_expense_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'this_month';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ExpensesBloc>().add(const FilterExpensesEvent('this_month'));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<ExpensesBloc>().state;
      if (state is ExpensesLoaded && state.hasMore) {
        context.read<ExpensesBloc>().add(LoadExpensesEvent(
              startDate: state.filterStartDate,
              endDate: state.filterEndDate,
              loadMore: true,
            ));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ExpensesBloc, ExpensesState>(
          listener: (context, state) {
            if (state is ExpensesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                const DashboardHeader(),
                DashboardBalanceSection(state: state),
                DashboardFilterSection(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: (filter) {
                    setState(() => _selectedFilter = filter);
                    context.read<ExpensesBloc>().add(FilterExpensesEvent(filter));
                  },
                ),
                DashboardExpensesList(
                  state: state,
                  scrollController: _scrollController,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: DashboardFAB(
        onPressed: () => _navigateToAddExpense(),
      ),
    );
  }

  Future<void> _navigateToAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<ExpensesBloc>(),
          child: const AddExpensePage(),
        ),
      ),
    );

    if (result == true && mounted) {
      context.read<ExpensesBloc>().add(FilterExpensesEvent(_selectedFilter));
    }
  }
}
