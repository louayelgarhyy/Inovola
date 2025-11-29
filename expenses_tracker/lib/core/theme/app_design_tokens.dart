import 'package:sizer/sizer.dart';

/// Design tokens for consistent spacing throughout the app
class AppSpacing {
  // Base spacing scale
  static double get xs => 0.5.h;    // 4px on standard screen
  static double get sm => 1.h;      // 8px
  static double get md => 2.h;      // 16px
  static double get lg => 3.h;      // 24px
  static double get xl => 4.h;      // 32px
  static double get xxl => 6.h;     // 48px
  
  // Specific use cases
  static double get cardPadding => 2.5.h;
  static double get screenPadding => 2.h;
  static double get itemSpacing => 1.5.w;
  static double get sectionSpacing => 3.h;
}

/// Design tokens for consistent typography
class AppFontSize {
  static double get caption => 9.sp;      // Small labels
  static double get body2 => 10.sp;       // Secondary text
  static double get body1 => 11.sp;       // Primary body text
  static double get subtitle => 12.sp;    // Subtitles
  static double get title => 13.sp;       // Card titles
  static double get headline => 16.sp;    // Section headers
  static double get display => 20.sp;     // Large display text
}

/// Design tokens for icon sizes
class AppIconSize {
  static double get small => 2.h;
  static double get medium => 2.5.h;
  static double get large => 3.h;
  static double get xlarge => 3.5.h;
}

/// Design tokens for border radius
class AppRadius {
  static double get small => 1.h;
  static double get medium => 1.5.h;
  static double get large => 2.h;
  static double get button => 1.5.h;
  static double get card => 2.h;
}
