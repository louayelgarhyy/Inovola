import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Use case for adding predefined sample expenses
/// Moves business logic out of UI layer
class AddSampleExpenses {
  final ExpenseRepository repository;

  AddSampleExpenses(this.repository);

  Future<Either<Failure, List<Expense>>> call() async {
    try {
      final sampleExpenses = _getSampleExpenses();
      final results = <Expense>[];

      // Add each expense
      for (final expenseData in sampleExpenses) {
        final result = await repository.addExpense(
          Expense(
            id: '',
            category: expenseData.category,
            amount: expenseData.amount,
            currency: expenseData.currency,
            amountInUsd: 0.0, // Will be calculated in repository
            date: expenseData.date,
            createdAt: DateTime.now(),
          ),
        );

        result.fold(
          (failure) => throw Exception(failure.toString()),
          (expense) => results.add(expense),
        );
      }

      return Right(results);
    } catch (e) {
      return Left(CacheFailure('Failed to add sample data: ${e.toString()}'));
    }
  }

  /// Get predefined sample expense data
  List<_SampleExpenseData> _getSampleExpenses() {
    final now = DateTime.now();

    return [
      _SampleExpenseData(
        category: 'Groceries',
        amount: 100.0,
        currency: 'USD',
        date: now.subtract(const Duration(days: 2)),
      ),
      _SampleExpenseData(
        category: 'Entertainment',
        amount: 50.0,
        currency: 'USD',
        date: now.subtract(const Duration(days: 1)),
      ),
      _SampleExpenseData(
        category: 'Transport',
        amount: 75.0,
        currency: 'USD',
        date: now,
      ),
      _SampleExpenseData(
        category: 'Rent',
        amount: 800.0,
        currency: 'USD',
        date: now.subtract(const Duration(days: 5)),
      ),
      _SampleExpenseData(
        category: 'Gas',
        amount: 60.0,
        currency: 'USD',
        date: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}

class _SampleExpenseData {
  final String category;
  final double amount;
  final String currency;
  final DateTime date;

  _SampleExpenseData({
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
  });
}
