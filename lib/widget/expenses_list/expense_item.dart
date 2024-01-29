import 'package:flutter/material.dart';
import 'package:tracker_app/Models/expenses.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expenses, {Key? key}) : super(key: key);

  final Expenses expenses;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
            Text(expenses.title,style: Theme.of(context).textTheme.titleLarge ,),
           const Spacer(),
            Text(expenses.category.name,style: Theme.of(context).textTheme.titleSmall,),
              ],),Row(
              children: [
                Text("Rs.${expenses.amount.toStringAsFixed(2)}"),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expenses.category]),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(expenses.formattedDate),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
