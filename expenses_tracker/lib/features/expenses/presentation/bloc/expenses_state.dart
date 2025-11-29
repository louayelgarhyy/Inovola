import 'package:equatable/equatable.dart';

import '../../domain/entities/expense.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object?> get props => [];
}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses;
  final bool hasMore;
  final int currentPage;
  final String currentFilter;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;

  const ExpensesLoaded({
    required this.expenses,
    this.hasMore = true,
    this.currentPage = 0,
    this.currentFilter = 'this_month',
    this.filterStartDate,
    this.filterEndDate,
  });

  double get totalBalance {
    // For demo purposes, assume income is 2x of expenses
    return totalIncome - totalExpenses;
  }

  double get totalIncome {
    // For demo purposes, calculate as 2.5x of total expenses
    return totalExpenses * 2.5;
  }

  double get totalExpenses {
    return expenses.fold(0, (sum, expense) => sum + expense.amountInUsd);
  }

  ExpensesLoaded copyWith({
    List<Expense>? expenses,
    bool? hasMore,
    int? currentPage,
    String? currentFilter,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
  }) {
    return ExpensesLoaded(
      expenses: expenses ?? this.expenses,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      currentFilter: currentFilter ?? this.currentFilter,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
    );
  }

  @override
  List<Object?> get props => [
        expenses,
        hasMore,
        currentPage,
        currentFilter,
        filterStartDate,
        filterEndDate,
      ];
}

class ExpensesError extends ExpensesState {
  final String message;

  const ExpensesError(this.message);

  @override
  List<Object> get props => [message];
}

class ExpenseAdding extends ExpensesState {}

class ExpenseAdded extends ExpensesState {
  final Expense expense;

  const ExpenseAdded(this.expense);

  @override
  List<Object> get props => [expense];
}

class ExpenseAddError extends ExpensesState {
  final String message;

  const ExpenseAddError(this.message);

  @override
  List<Object> get props => [message];
}
