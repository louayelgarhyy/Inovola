import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expenses_bloc.dart';
import '../bloc/expenses_event.dart';
import '../bloc/expenses_state.dart';

class DemoDataSeeder extends StatelessWidget {
  const DemoDataSeeder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpensesBloc, ExpensesState>(
      listener: (context, state) {
        if (state is ExpenseAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Demo data added!')),
          );
        }
      },
      child: Center(
        child: ElevatedButton(
          onPressed: () => _addDemoData(context),
          child: const Text('Add Demo Data'),
        ),
      ),
    );
  }

  void _addDemoData(BuildContext context) {
    final bloc = context.read<ExpensesBloc>();
    
    // Add some demo expenses
    final demoExpenses = [
      {
        'category': 'Groceries',
        'amount': 100.0,
        'currency': 'USD',
        'date': DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        'category': 'Entertainment',
        'amount': 50.0,
        'currency': 'USD',
        'date': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'category': 'Transport',
        'amount': 75.0,
        'currency': 'USD',
        'date': DateTime.now(),
      },
      {
        'category': 'Rent',
        'amount': 800.0,
        'currency': 'USD',
        'date': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'category': 'Gas',
        'amount': 60.0,
        'currency': 'USD',
        'date': DateTime.now().subtract(const Duration(days: 3)),
      },
    ];

    for (var expense in demoExpenses) {
      bloc.add(AddExpenseEvent(
        category: expense['category'] as String,
        amount: expense['amount'] as double,
        currency: expense['currency'] as String,
        date: expense['date'] as DateTime,
      ));
    }
  }
}
