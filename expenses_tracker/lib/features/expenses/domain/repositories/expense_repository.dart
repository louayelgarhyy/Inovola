import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });
  
  Future<Either<Failure, Expense>> addExpense(Expense expense);
  
  Future<Either<Failure, Expense>> updateExpense(Expense expense);
  
  Future<Either<Failure, void>> deleteExpense(String id);
  
  Future<Either<Failure, int>> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  });
}
