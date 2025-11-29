import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/theme/app_theme.dart';

class FormReceiptPicker extends StatelessWidget {
  final String? receiptPath;
  final VoidCallback onTap;

  const FormReceiptPicker({
    super.key,
    required this.receiptPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attach Receipt',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.5.h),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    receiptPath ?? 'Upload image',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: receiptPath != null
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.camera_alt, size: 2.5.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
