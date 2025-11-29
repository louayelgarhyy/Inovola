import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/expenses_bloc.dart';
import '../bloc/expenses_event.dart';
import '../bloc/expenses_state.dart';
import '../widgets/add_expense_form.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  
  String _selectedCategory = 'Entertainment';
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  String? _receiptPath;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Expense'),
        centerTitle: true,
      ),
      body: BlocListener<ExpensesBloc, ExpensesState>(
        listener: _handleBlocState,
        child: AddExpenseForm(
          formKey: _formKey,
          amountController: _amountController,
          selectedCategory: _selectedCategory,
          selectedCurrency: _selectedCurrency,
          selectedDate: _selectedDate,
          receiptPath: _receiptPath,
          onCategoryChanged: (category) => setState(() => _selectedCategory = category),
          onCurrencyChanged: (currency) => setState(() => _selectedCurrency = currency),
          onDateChanged: (date) => setState(() => _selectedDate = date),
          onReceiptPicked: () => _pickImage(),
          onSave: _handleSave,
        ),
      ),
    );
  }

  void _handleBlocState(BuildContext context, ExpensesState state) {
    if (state is ExpenseAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully')),
      );
      Navigator.pop(context, true);
    } else if (state is ExpenseAddError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _receiptPath = image.path);
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      context.read<ExpensesBloc>().add(
        AddExpenseEvent(
          category: _selectedCategory,
          amount: double.parse(_amountController.text),
          currency: _selectedCurrency,
          date: _selectedDate,
          receiptPath: _receiptPath,
        ),
      );
    }
  }
}
