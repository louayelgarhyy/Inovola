import 'package:equatable/equatable.dart';

import '../../domain/entities/expense.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpensesEvent extends ExpensesEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool loadMore;

  const LoadExpensesEvent({
    this.startDate,
    this.endDate,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [startDate, endDate, loadMore];
}

class AddExpenseEvent extends ExpensesEvent {
  final String category;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;

  const AddExpenseEvent({
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
    this.receiptPath,
  });

  @override
  List<Object?> get props => [category, amount, currency, date, receiptPath];
}

class UpdateExpenseEvent extends ExpensesEvent {
  final Expense expense;

  const UpdateExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class DeleteExpenseEvent extends ExpensesEvent {
  final String id;

  const DeleteExpenseEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FilterExpensesEvent extends ExpensesEvent {
  final String filter; // 'this_month', 'last_7_days', 'all'

  const FilterExpensesEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

/// Bulk expense data for efficient batch operations
class BulkExpenseData {
  final String category;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;

  const BulkExpenseData({
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
    this.receiptPath,
  });
}

/// Add multiple expenses in a single transaction
class AddBulkExpensesEvent extends ExpensesEvent {
  final List<BulkExpenseData> expenses;

  const AddBulkExpensesEvent(this.expenses);

  @override
  List<Object> get props => [expenses];
}

/// Add predefined sample data for testing
class AddSampleDataEvent extends ExpensesEvent {
  const AddSampleDataEvent();
}