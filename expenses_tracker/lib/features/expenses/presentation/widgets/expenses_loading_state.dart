import 'package:flutter/material.dart';

class ExpensesLoadingState extends StatelessWidget {
  const ExpensesLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
