import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/error_boundary.dart';
import 'features/expenses/data/models/expense_model.dart';
import 'features/expenses/presentation/bloc/expenses_bloc.dart';
import 'features/expenses/presentation/pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup global error handlers
  setupErrorHandlers();
  
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  await Hive.openBox<ExpenseModel>('expenses');
  
  await initializeDependencies();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ErrorBoundary(
          child: BlocProvider(
            create: (context) => sl<ExpensesBloc>(),
            child: MaterialApp(
              title: 'Expense Tracker',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: AppTheme.colorScheme,
                textTheme: GoogleFonts.interTextTheme(),
                scaffoldBackgroundColor: AppTheme.backgroundColor,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                ),
              ),
              home: const DashboardPage(),
            ),
          ),
        );
      },
    );
  }
}
