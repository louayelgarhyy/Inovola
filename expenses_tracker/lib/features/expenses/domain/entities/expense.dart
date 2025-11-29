import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String category;
  final double amount;
  final String currency;
  final double amountInUsd;
  final DateTime date;
  final String? receiptPath;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.currency,
    required this.amountInUsd,
    required this.date,
    this.receiptPath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        amount,
        currency,
        amountInUsd,
        date,
        receiptPath,
        createdAt,
      ];
}
