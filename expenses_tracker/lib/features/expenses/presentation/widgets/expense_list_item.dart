import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/expense.dart';
import 'category_selector.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 0.8.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.h),
        boxShadow: AppTheme.lightShadow,
      ),
      child: Row(
        children: [
          _ExpenseIcon(category: expense.category),
          SizedBox(width: 1.5.w),
          Expanded(
            child: _ExpenseDetails(
              category: expense.category,
              date: dateFormat.format(expense.date),
            ),
          ),
          _ExpenseAmount(
            amountInUsd: expense.amountInUsd,
            amount: expense.amount,
            currency: expense.currency,
            currencyFormat: currencyFormat,
          ),
        ],
      ),
    );
  }
}

class _ExpenseIcon extends StatelessWidget {
  final String category;

  const _ExpenseIcon({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6.h,
      height: 6.h,
      decoration: BoxDecoration(
        color: CategorySelector.getCategoryColor(category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(1.5.h),
      ),
      child: Icon(
        CategorySelector.getCategoryIcon(category),
        color: CategorySelector.getCategoryColor(category),
        size: 3.h,
      ),
    );
  }
}

class _ExpenseDetails extends StatelessWidget {
  final String category;
  final String date;

  const _ExpenseDetails({
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          date,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ExpenseAmount extends StatelessWidget {
  final double amountInUsd;
  final double amount;
  final String currency;
  final NumberFormat currencyFormat;

  const _ExpenseAmount({
    required this.amountInUsd,
    required this.amount,
    required this.currency,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '-${currencyFormat.format(amountInUsd)}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.expenseColor,
          ),
        ),
        if (currency != 'USD') ...[
          SizedBox(height: 0.5.h),
          Text(
            '${amount.toStringAsFixed(2)} $currency',
            style: TextStyle(
              fontSize: 9.sp,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ],
    );
  }
}
