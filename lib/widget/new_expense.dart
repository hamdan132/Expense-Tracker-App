import 'package:flutter/material.dart';
import 'package:tracker_app/Models/expenses.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({Key? key, required this.onaddExpense}) : super(key: key);

  final void Function(Expenses expense) onaddExpense;

  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Categories _selectedCategories = Categories.leisure;
  // Expenses exp=Expenses();
  // Function to display a date picker dialog
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // Function to submit the entered expense details
  // Function to submit the entered expense details
  void _submitExpenseDate() async {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // Validate the entered details
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Invalid Input',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: const Text(
            'Please make sure a valid title, amount, date, and category were entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }

    // Create a new Expenses object with the entered details
    final newExpense = Expenses(
      date: _selectedDate!,
      title: _titleController.text,
      amount: enteredAmount,
      category: _selectedCategories,
    );

    // Save the new expense locally using shared preferences
    // await Expenses.saveToLocal(newExpense);

    // Trigger the callback function to add the new expense to the list
    widget.onaddExpense(newExpense);

    // Close the new expense form
    Navigator.pop(context);
  }

  // Widget to build text input fields
  Widget buildTextField(String labelText, TextEditingController controller,
      TextInputType keyboardType) {
    return TextField(
      maxLength: 50,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Text(labelText),
      ),
    );
  }

  // Widget to build the amount input field with a prefix
  Widget buildAmountField(String labelText, TextEditingController controller,
      TextInputType keyboardType) {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        prefixText: "Rs.",
        label: Text('Amount'),
      ),
    );
  }

  // Widget to build the dropdown picker for expense categories
  Widget buildDropdownPicker() {
    return DropdownButton(
        style: Theme.of(context).textTheme.bodyLarge,
        value: _selectedCategories,
        items: Categories.values
            .map(
              (categories) => DropdownMenuItem(
                value: categories,
                child: Text(
                  categories.name.toUpperCase(),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            if (value == null) {
              return;
            }
            _selectedCategories = value;
          });
        });
  }

  // Widget to build the date picker row
  Widget buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _selectedDate == null
              ? 'No Date Selected'
              : formatter.format(_selectedDate!),
        ),
        IconButton(
          onPressed: _presentDatePicker,
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    );
  }

  // Widget to build the save button
  Widget buildSave() {
    return ElevatedButton(
        onPressed: _submitExpenseDate, child: const Text('Save Expense'));
  }

  // Widget to build the cancel button
  Widget buildCancel() {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'));
  }

  // Dispose of controllers when the widget is disposed
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Build the new expense form
  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: ((ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildTextField(
                              'Title', _titleController, TextInputType.name),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: buildAmountField(
                              'Amount', _amountController, TextInputType.name),
                        ),
                      ],
                    )
                  else
                    buildTextField(
                        'Title', _titleController, TextInputType.name),
                  if (width >= 600)
                    Row(
                      children: [
                        buildDropdownPicker(),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: buildDatePicker(),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: buildAmountField(
                              'Amount', _amountController, TextInputType.name),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: buildDatePicker(),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        buildCancel(),
                        buildSave(),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildDropdownPicker(),
                        const Spacer(),
                        buildCancel(),
                        buildSave(),
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
