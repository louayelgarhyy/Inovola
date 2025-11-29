import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_theme.dart';

class FormAmountField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;

  static const List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'EGP'];

  const FormAmountField({
    super.key,
    required this.controller,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.5.h),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '\$50.00',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1.h),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 2.h,
                    vertical: 2.h,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 1.5.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(1.h),
                ),
                child: DropdownButton<String>(
                  value: selectedCurrency,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) onCurrencyChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
