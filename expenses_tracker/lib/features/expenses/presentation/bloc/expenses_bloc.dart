import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../currency/domain/usecases/get_exchange_rate.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/add_sample_expenses.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/update_expense.dart';
import 'expenses_event.dart';
import 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpenses getExpenses;
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final DeleteExpense deleteExpense;
  final GetExchangeRate getExchangeRate;
  final AddSampleExpenses addSampleExpenses;

  static const int itemsPerPage = 10;
  final uuid = const Uuid();

  ExpensesBloc({
    required this.getExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getExchangeRate,
    required this.addSampleExpenses,
  }) : super(ExpensesInitial()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<FilterExpensesEvent>(_onFilterExpenses);
    on<AddSampleDataEvent>(_onAddSampleData);
  }

  Future<void> _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    if (!event.loadMore) {
      emit(ExpensesLoading());
    }

    final currentState = state;
    final page = event.loadMore && currentState is ExpensesLoaded ? currentState.currentPage + 1 : 0;

    final result = await getExpenses(
      startDate: event.startDate,
      endDate: event.endDate,
      limit: itemsPerPage,
      offset: page * itemsPerPage,
    );

    result.fold(
      (failure) => emit(ExpensesError(failure.message)),
      (newExpenses) {
        List<Expense> allExpenses;
        if (event.loadMore && currentState is ExpensesLoaded) {
          allExpenses = [...currentState.expenses, ...newExpenses];
        } else {
          allExpenses = newExpenses;
        }

        emit(ExpensesLoaded(
          expenses: allExpenses,
          hasMore: newExpenses.length == itemsPerPage,
          currentPage: page,
          filterStartDate: event.startDate,
          filterEndDate: event.endDate,
        ));
      },
    );
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(ExpenseAdding());

    // Get exchange rate if currency is not USD
    double amountInUsd = event.amount;
    if (event.currency != 'USD') {
      final rateResult = await getExchangeRate(
        from: event.currency,
        to: 'USD',
      );

      rateResult.fold(
        (failure) {
          emit(ExpenseAddError(failure.message));
          return;
        },
        (rate) {
          amountInUsd = event.amount * rate;
        },
      );
    }

    final expense = Expense(
      id: uuid.v4(),
      category: event.category,
      amount: event.amount,
      currency: event.currency,
      amountInUsd: amountInUsd,
      date: event.date,
      receiptPath: event.receiptPath,
      createdAt: DateTime.now(),
    );

    final result = await addExpense(expense);

    result.fold(
      (failure) => emit(ExpenseAddError(failure.message)),
      (addedExpense) {
        emit(ExpenseAdded(addedExpense));
        // Reload expenses
        add(const LoadExpensesEvent());
      },
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    final result = await updateExpense(event.expense);

    result.fold(
      (failure) => emit(ExpensesError(failure.message)),
      (_) => add(const LoadExpensesEvent()),
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    final result = await deleteExpense(event.id);

    result.fold(
      (failure) => emit(ExpensesError(failure.message)),
      (_) => add(const LoadExpensesEvent()),
    );
  }

  Future<void> _onFilterExpenses(
    FilterExpensesEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    DateTime? startDate;
    DateTime? endDate = DateTime.now();

    switch (event.filter) {
      case 'this_month':
        final now = DateTime.now();
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case 'last_7_days':
        startDate = DateTime.now().subtract(const Duration(days: 7));
        break;
      case 'all':
        startDate = null;
        endDate = null;
        break;
    }

    add(LoadExpensesEvent(
      startDate: startDate,
      endDate: endDate,
    ));
  }

  Future<void> _onAddSampleData(
    AddSampleDataEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(ExpenseAdding());

    final result = await addSampleExpenses();

    result.fold(
      (failure) => emit(ExpenseAddError(failure.message)),
      (expenses) {
        emit(ExpenseAdded(expenses.last));
        // Reload all expenses after adding sample data
        add(const FilterExpensesEvent('this_month'));
      },
    );
  }
}
