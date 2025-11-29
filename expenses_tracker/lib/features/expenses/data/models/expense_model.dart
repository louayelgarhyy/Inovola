import 'package:hive/hive.dart';

import '../../domain/entities/expense.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel extends Expense {
  @HiveField(0)
  final String modelId;
  
  @HiveField(1)
  final String modelCategory;
  
  @HiveField(2)
  final double modelAmount;
  
  @HiveField(3)
  final String modelCurrency;
  
  @HiveField(4)
  final double modelAmountInUsd;
  
  @HiveField(5)
  final DateTime modelDate;
  
  @HiveField(6)
  final String? modelReceiptPath;
  
  @HiveField(7)
  final DateTime modelCreatedAt;

  const ExpenseModel({
    required this.modelId,
    required this.modelCategory,
    required this.modelAmount,
    required this.modelCurrency,
    required this.modelAmountInUsd,
    required this.modelDate,
    this.modelReceiptPath,
    required this.modelCreatedAt,
  }) : super(
          id: modelId,
          category: modelCategory,
          amount: modelAmount,
          currency: modelCurrency,
          amountInUsd: modelAmountInUsd,
          date: modelDate,
          receiptPath: modelReceiptPath,
          createdAt: modelCreatedAt,
        );

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      modelId: expense.id,
      modelCategory: expense.category,
      modelAmount: expense.amount,
      modelCurrency: expense.currency,
      modelAmountInUsd: expense.amountInUsd,
      modelDate: expense.date,
      modelReceiptPath: expense.receiptPath,
      modelCreatedAt: expense.createdAt,
    );
  }

  Expense toEntity() {
    return Expense(
      id: modelId,
      category: modelCategory,
      amount: modelAmount,
      currency: modelCurrency,
      amountInUsd: modelAmountInUsd,
      date: modelDate,
      receiptPath: modelReceiptPath,
      createdAt: modelCreatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': modelId,
      'category': modelCategory,
      'amount': modelAmount,
      'currency': modelCurrency,
      'amountInUsd': modelAmountInUsd,
      'date': modelDate.toIso8601String(),
      'receiptPath': modelReceiptPath,
      'createdAt': modelCreatedAt.toIso8601String(),
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      modelId: json['id'],
      modelCategory: json['category'],
      modelAmount: json['amount'].toDouble(),
      modelCurrency: json['currency'],
      modelAmountInUsd: json['amountInUsd'].toDouble(),
      modelDate: DateTime.parse(json['date']),
      modelReceiptPath: json['receiptPath'],
      modelCreatedAt: DateTime.parse(json['createdAt']),
    );
  }
}
