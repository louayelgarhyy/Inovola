import 'package:hive/hive.dart';

import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });
  
  Future<ExpenseModel> addExpense(ExpenseModel expense);
  
  Future<ExpenseModel> updateExpense(ExpenseModel expense);
  
  Future<void> deleteExpense(String id);
  
  Future<int> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  });
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<ExpenseModel> expenseBox;

  ExpenseLocalDataSourceImpl(this.expenseBox);

  @override
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var expenses = expenseBox.values.toList();
      
      // Sort by created date (newest first)
      expenses.sort((a, b) => b.modelCreatedAt.compareTo(a.modelCreatedAt));
      
      // Filter by date range
      if (startDate != null || endDate != null) {
        expenses = expenses.where((expense) {
          if (startDate != null && expense.modelDate.isBefore(startDate)) {
            return false;
          }
          if (endDate != null && expense.modelDate.isAfter(endDate)) {
            return false;
          }
          return true;
        }).toList();
      }
      
      // Apply pagination
      if (offset != null) {
        expenses = expenses.skip(offset).toList();
      }
      
      if (limit != null) {
        expenses = expenses.take(limit).toList();
      }
      
      return expenses;
    } catch (e) {
      throw Exception('Failed to get expenses: $e');
    }
  }

  @override
  Future<ExpenseModel> addExpense(ExpenseModel expense) async {
    try {
      await expenseBox.put(expense.modelId, expense);
      return expense;
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  @override
  Future<ExpenseModel> updateExpense(ExpenseModel expense) async {
    try {
      await expenseBox.put(expense.modelId, expense);
      return expense;
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await expenseBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  @override
  Future<int> getTotalExpenses({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var expenses = expenseBox.values.toList();
      
      if (startDate != null || endDate != null) {
        expenses = expenses.where((expense) {
          if (startDate != null && expense.modelDate.isBefore(startDate)) {
            return false;
          }
          if (endDate != null && expense.modelDate.isAfter(endDate)) {
            return false;
          }
          return true;
        }).toList();
      }
      
      return expenses.length;
    } catch (e) {
      throw Exception('Failed to get total expenses: $e');
    }
  }
}
