import 'package:flutter/material.dart';
import 'package:tracker_app/Models/expenses.dart';
import 'package:tracker_app/widget/expenses_list/expense_item.dart';

class ExpensesList extends StatefulWidget {
  final List<Expenses> expenses;
  final Function(Expenses) onRemoveExpense;

  ExpensesList({
    required this.expenses,
    required this.onRemoveExpense,
  });

  @override
  _ExpensesListState createState() => _ExpensesListState();
   
}

class _ExpensesListState extends State<ExpensesList> {
ListView listedItems(){
   return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(1.0),
          // margin: EdgeInsets.symmetric(
          //     horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        key: ValueKey(
          widget.expenses[index],
        ),
        onDismissed: (directin) {
          
          widget.onRemoveExpense(
            widget.expenses[index],
          );
        },
        child: ExpenseItem(
          widget.expenses[index],
        ),
      ),
    );
}
  
  @override
  Widget build(BuildContext context) {
    return listedItems();
  }
}
