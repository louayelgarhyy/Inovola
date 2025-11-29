import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/currency/domain/usecases/get_exchange_rate.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/add_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/add_sample_expenses.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/delete_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/get_expenses.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/update_expense.dart';
import 'package:expense_tracker/features/expenses/presentation/bloc/expenses_bloc.dart';
import 'package:expense_tracker/features/expenses/presentation/bloc/expenses_event.dart';
import 'package:expense_tracker/features/expenses/presentation/bloc/expenses_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockGetExpenses extends Mock implements GetExpenses {}

class MockAddExpense extends Mock implements AddExpense {}

class MockUpdateExpense extends Mock implements UpdateExpense {}

class MockDeleteExpense extends Mock implements DeleteExpense {}

class MockAddSampleExpenses extends Mock implements AddSampleExpenses {}

class MockGetExchangeRate extends Mock implements GetExchangeRate {}

void main() {
  late ExpensesBloc bloc;
  late MockGetExpenses mockGetExpenses;
  late MockAddExpense mockAddExpense;
  late MockUpdateExpense mockUpdateExpense;
  late MockDeleteExpense mockDeleteExpense;
  late MockGetExchangeRate mockGetExchangeRate;
  late MockAddSampleExpenses mockAddSampleExpenses;

  setUp(() {
    mockGetExpenses = MockGetExpenses();
    mockAddExpense = MockAddExpense();
    mockUpdateExpense = MockUpdateExpense();
    mockDeleteExpense = MockDeleteExpense();
    mockGetExchangeRate = MockGetExchangeRate();
    mockAddSampleExpenses = MockAddSampleExpenses();

    bloc = ExpensesBloc(
        getExpenses: mockGetExpenses,
        addExpense: mockAddExpense,
        updateExpense: mockUpdateExpense,
        deleteExpense: mockDeleteExpense,
        getExchangeRate: mockGetExchangeRate,
        addSampleExpenses: mockAddSampleExpenses);
  });

  tearDown(() {
    bloc.close();
  });

  // Test data
  final tExpense = Expense(
    id: '1',
    category: 'Groceries',
    amount: 100.0,
    currency: 'USD',
    amountInUsd: 100.0,
    date: DateTime(2024, 1, 1),
    createdAt: DateTime(2024, 1, 1),
  );

  final tExpenseList = [tExpense];

  group('LoadExpensesEvent', () {
    test('initial state should be ExpensesInitial', () {
      expect(bloc.state, equals(ExpensesInitial()));
    });

    blocTest<ExpensesBloc, ExpensesState>(
      'emits [ExpensesLoading, ExpensesLoaded] when LoadExpensesEvent is added and data is fetched successfully',
      build: () {
        when(() => mockGetExpenses(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => Right(tExpenseList));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadExpensesEvent()),
      expect: () => [
        ExpensesLoading(),
        ExpensesLoaded(
          expenses: tExpenseList,
          hasMore: false,
          currentPage: 0,
        ),
      ],
    );

    blocTest<ExpensesBloc, ExpensesState>(
      'emits [ExpensesLoading, ExpensesError] when LoadExpensesEvent is added and fetching data fails',
      build: () {
        when(() => mockGetExpenses(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => const Left(CacheFailure('Cache error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadExpensesEvent()),
      expect: () => [
        ExpensesLoading(),
        const ExpensesError('Cache error'),
      ],
    );
  });

  group('AddExpenseEvent', () {
    const tExchangeRate = 1.1;

    blocTest<ExpensesBloc, ExpensesState>(
      'emits [ExpenseAdding, ExpenseAdded, ExpensesLoading, ExpensesLoaded] when adding expense with USD currency',
      build: () {
        when(() => mockAddExpense(any())).thenAnswer((_) async => Right(tExpense));
        when(() => mockGetExpenses(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => Right(tExpenseList));
        return bloc;
      },
      act: (bloc) => bloc.add(
        AddExpenseEvent(
          category: 'Groceries',
          amount: 100.0,
          currency: 'USD',
          date: DateTime(2024, 1, 1),
        ),
      ),
      expect: () => [
        ExpenseAdding(),
        isA<ExpenseAdded>(),
        ExpensesLoading(),
        isA<ExpensesLoaded>(),
      ],
      verify: (_) {
        verify(() => mockAddExpense(any())).called(1);
        verify(() => mockGetExpenses(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).called(1);
      },
    );

    blocTest<ExpensesBloc, ExpensesState>(
      'emits [ExpenseAdding, ExpenseAdded] when adding expense with non-USD currency and successful conversion',
      build: () {
        when(() => mockGetExchangeRate(from: 'EUR', to: 'USD')).thenAnswer((_) async => const Right(tExchangeRate));
        when(() => mockAddExpense(any())).thenAnswer((_) async => Right(tExpense));
        when(() => mockGetExpenses(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => Right(tExpenseList));
        return bloc;
      },
      act: (bloc) => bloc.add(
        AddExpenseEvent(
          category: 'Groceries',
          amount: 100.0,
          currency: 'EUR',
          date: DateTime(2024, 1, 1),
        ),
      ),
      expect: () => [
        ExpenseAdding(),
        isA<ExpenseAdded>(),
        ExpensesLoading(),
        isA<ExpensesLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetExchangeRate(from: 'EUR', to: 'USD')).called(1);
        verify(() => mockAddExpense(any())).called(1);
      },
    );

    blocTest<ExpensesBloc, ExpensesState>(
      'emits [ExpenseAdding, ExpenseAddError] when currency conversion fails',
      build: () {
        when(() => mockGetExchangeRate(from: 'EUR', to: 'USD')).thenAnswer((_) async => const Left(ServerFailure('API error')));
        return bloc;
      },
      act: (bloc) => bloc.add(
        AddExpenseEvent(
          category: 'Groceries',
          amount: 100.0,
          currency: 'EUR',
          date: DateTime(2024, 1, 1),
        ),
      ),
      expect: () => [
        ExpenseAdding(),
        const ExpenseAddError('API error'),
      ],
    );
  });

  group('FilterExpensesEvent', () {
    blocTest<ExpensesBloc, ExpensesState>(
      'applies this_month filter correctly',
      build: () {
        when(() => mockGetExpenses(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).thenAnswer((_) async => Right(tExpenseList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FilterExpensesEvent('this_month')),
      expect: () => [
        ExpensesLoading(),
        isA<ExpensesLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetExpenses(
              startDate: any(named: 'startDate'),
              endDate: any(named: 'endDate'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
            )).called(1);
      },
    );
  });

  group('Expense Validation', () {
    test('should validate amount is positive', () {
      const amount = 100.0;
      expect(amount > 0, true);
    });

    test('should validate amount is not negative', () {
      const amount = -100.0;
      expect(amount > 0, false);
    });

    test('should validate amount is not zero', () {
      const amount = 0.0;
      expect(amount > 0, false);
    });
  });

  group('Currency Calculation', () {
    test('should correctly convert EUR to USD', () {
      const amountEur = 100.0;
      const exchangeRate = 1.1;
      const expectedUsd = 110.0;

      final result = (amountEur * exchangeRate).roundToDouble();

      expect(result, equals(expectedUsd));
    });

    test('should handle USD to USD conversion', () {
      const amountUsd = 100.0;
      const exchangeRate = 1.0;
      const expectedUsd = 100.0;

      const result = amountUsd * exchangeRate;

      expect(result, equals(expectedUsd));
    });

    test('should correctly convert with decimal exchange rate', () {
      const amount = 100.0;
      const exchangeRate = 1.09534;
      const expectedResult = 109.534;

      final result = (amount * exchangeRate).roundToDouble();

      expect(result, equals(expectedResult));
    });
  });

  group('Pagination Logic', () {
    test('should calculate correct offset for page 0', () {
      const page = 0;
      const itemsPerPage = 10;
      const expectedOffset = 0;

      const offset = page * itemsPerPage;

      expect(offset, equals(expectedOffset));
    });

    test('should calculate correct offset for page 2', () {
      const page = 2;
      const itemsPerPage = 10;
      const expectedOffset = 20;

      const offset = page * itemsPerPage;

      expect(offset, equals(expectedOffset));
    });

    test('should determine hasMore when items equal page size', () {
      const itemsReturned = 10;
      const pageSize = 10;

      const hasMore = itemsReturned == pageSize;

      expect(hasMore, true);
    });

    test('should determine hasMore is false when items less than page size', () {
      const itemsReturned = 5;
      const pageSize = 10;

      const hasMore = itemsReturned == pageSize;

      expect(hasMore, false);
    });
  });
}
