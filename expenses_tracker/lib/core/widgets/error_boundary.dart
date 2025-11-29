import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_strings.dart';
import '../theme/app_theme.dart';
import '../theme/app_design_tokens.dart';

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  
  const ErrorBoundary({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Global error widget shown when Flutter catches an error
class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const AppErrorWidget({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 10.h,
                  color: AppTheme.errorColor,
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.somethingWentWrong,
                  style: TextStyle(
                    fontSize: AppFontSize.headline,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  errorDetails.exception.toString(),
                  style: TextStyle(
                    fontSize: AppFontSize.body2,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  onPressed: () {
                    // Force app restart by navigating to root
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(AppStrings.restartApp),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Set up global error handling
void setupErrorHandlers() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // TODO: Send to crash reporting service (e.g., Sentry, Firebase Crashlytics)
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return AppErrorWidget(errorDetails: details);
  };
}
