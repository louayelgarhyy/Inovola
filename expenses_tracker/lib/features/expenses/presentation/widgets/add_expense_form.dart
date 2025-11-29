import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'form_amount_field.dart';
import 'form_category_dropdown.dart';
import 'form_category_grid.dart';
import 'form_date_picker.dart';
import 'form_receipt_picker.dart';
import 'form_save_button.dart';

class AddExpenseForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final String selectedCategory;
  final String selectedCurrency;
  final DateTime selectedDate;
  final String? receiptPath;
  final Function(String) onCategoryChanged;
  final Function(String) onCurrencyChanged;
  final Function(DateTime) onDateChanged;
  final VoidCallback onReceiptPicked;
  final VoidCallback onSave;

  const AddExpenseForm({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.selectedCategory,
    required this.selectedCurrency,
    required this.selectedDate,
    required this.receiptPath,
    required this.onCategoryChanged,
    required this.onCurrencyChanged,
    required this.onDateChanged,
    required this.onReceiptPicked,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(2.h),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormCategoryDropdown(
              selectedCategory: selectedCategory,
              onChanged: onCategoryChanged,
            ),
            SizedBox(height: 3.h),
            FormAmountField(
              controller: amountController,
              selectedCurrency: selectedCurrency,
              onCurrencyChanged: onCurrencyChanged,
            ),
            SizedBox(height: 3.h),
            FormDatePicker(
              selectedDate: selectedDate,
              onDateChanged: onDateChanged,
            ),
            SizedBox(height: 3.h),
            FormReceiptPicker(
              receiptPath: receiptPath,
              onTap: onReceiptPicked,
            ),
            SizedBox(height: 3.h),
            FormCategoryGrid(
              selectedCategory: selectedCategory,
              onCategorySelected: onCategoryChanged,
            ),
            SizedBox(height: 4.h),
            FormSaveButton(onSave: onSave),
          ],
        ),
      ),
    );
  }
}
