import 'package:flutter/material.dart';
import 'package:tracker_app/Models/expenses.dart';
import 'package:tracker_app/widget/chart/chart.dart';
import 'package:tracker_app/widget/expenses_list/expenses_list.dart';
import 'package:tracker_app/widget/new_expense.dart';

class Expense extends StatefulWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  _ExpenseState createState() => _ExpenseState();
}

final List<Expenses> expenses = 0 as List<Expenses>;

class _ExpenseState extends State<Expense> {
  late List<Expenses> registeredExpenses = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      loadRegisteredExpenses();
    });
  }

  void loadRegisteredExpenses() async {
    List<Expenses> expenses = await Expenses.getLocalExpenses();
    setState(() {
      registeredExpenses = expenses;
      mainContent = registeredExpenses.isNotEmpty
          ? ExpensesList(
              expenses: registeredExpenses,
              onRemoveExpense: _removeExpense,
            )
          : const Center(child: Text('No expense found. Start Adding some!'));

      print(registeredExpenses);
    });
  }

  Widget mainContent = const Center(
    child: Text('No expense found. Start Adding some!'),
  );

  void _openAddExpenseOverlay() {
    setState(() {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
          onaddExpense: _addExpense,
        ),
      );
    });
  }

  void _addExpense(Expenses expense) async {
    setState(() {
      registeredExpenses.add(expense);
    });
    await Expenses.saveToLocal(registeredExpenses);
    loadRegisteredExpenses();
    print('added');
  }

  void _removeExpense(Expenses expense) async {
    // final expenseIndex = registeredExpenses.indexOf(expense);
    setState(() {
      // print('removed');
      registeredExpenses.remove(expense);
    });
    await Expenses.saveToLocal(registeredExpenses);
    loadRegisteredExpenses();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted."),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: (() {
            setState(() {
              // Find the current index to insert the expense at
              final currentIndex = registeredExpenses.indexOf(expense);
              registeredExpenses.insert(
                  currentIndex != -1 ? currentIndex : 0, expense);
            });
            Expenses.saveToLocal(registeredExpenses);
          }),
        ),
      ),
    );
  }

  Widget floatButton() {
    return FloatingActionButton(
      onPressed: _openAddExpenseOverlay,
      hoverElevation: 50,
      tooltip: 'Add Expense',
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Chart chart = Chart(expenses: registeredExpenses);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('T R A C K E R  A P P'),
            const Spacer(),
            Text(
              'Total Rs:${chart.maxTotalExpense}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
      floatingActionButton: floatButton(),
    );
  }
}
