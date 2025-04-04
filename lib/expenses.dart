import 'dart:io';

import 'package:expenses_tracker/LoggerUtil.dart';
import 'package:expenses_tracker/Widgets/Charts/chart.dart';
import 'package:expenses_tracker/Widgets/ExpensesList/expenses_list.dart';
import 'package:expenses_tracker/calender.dart';
import 'package:expenses_tracker/models/Expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// why statefull becoz, each time we need to add task and update UI so stateful
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final String _TAG = "expenses.dart, model sheet";
  Categories? _selectedCategory; // Selected category
  DateTime? _selectedDate; //getting values from callback to calender.dart
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final List<Expense> _expenses = [
    // create a dummy expenses
    Expense(
        title: "Flutter App Dev",
        amount: 10.90,
        category: Categories.work,
        dateTime: DateTime.now()),
    Expense(
        title: "Movie",
        amount: 14.90,
        category: Categories.leisure,
        dateTime: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double width = MediaQuery.of(context).size.width;
    MediaQuery.of(context).size.height;
    // print("${_TAG} ${MediaQuery.of(context).size.width}");

    Widget mainContent = Center(
      child: Text("No Expenses Found"),
    );

    if (_expenses.isNotEmpty) {
      // assign ExpensesList to maincontent
      mainContent = ExpensesList(
        removeExpenseItem: _removeExpense,
        expenses: _expenses,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Expenses",
          style: TextStyle(
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.8)),
        ),
      ),
      body: width <
              600 //if landscape on and screen width < 600 then go for column else Row
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chart(expenses: _expenses),
                  Expanded(child: mainContent)
                ],
              ),
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _expenses)),
                Expanded(child: mainContent)
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Expense Here",
        onPressed: _addExpensesDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  _addExpensesDialog() {
    // double keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    showModalBottomSheet(
        useSafeArea: true,
        //if ur modalsheet is exceeding or overlapping mobile button/cameras etc make it true
        context: context,
        isScrollControlled: true,
        // Allows full-screen behavior
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        backgroundColor: Colors.transparent,
        // Allows custom background
        builder: (ctx) => Container(
              // height:MediaQuery.of(context).size.height * 0.90,
              // in this way i can achieve media.query for modal expansion to 90% of
              // device screen
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 62, 60, 60),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Adjusts for keyboard
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Shrinks to fit content
                  children: [
                    const Text(
                      'Add Expense',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      maxLength: 20,
                      controller: titleController,
                      decoration: InputDecoration(
                        label: const Text("Enter Expense Title"),
                        // hintText: 'Enter Expense Title',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      // onChanged: _saveTitle,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        label: const Text('Enter Amount'),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    DropdownButton(
                      value: _selectedCategory,
                      items: Categories.values
                          .map((i) => DropdownMenuItem(
                              value: i, child: Text(i.name.toUpperCase())))
                          .toList(),
                      onChanged: (newValue) {
                        if (newValue == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = newValue;
                          LoggeUtils.logInfo("$_TAG is $_selectedCategory");
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // Pass the callback function to receive the selected date
                    AddCalendar(onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }), // Calendar Picker
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          // wrapped textbutton with container to achieve shadow like feel
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(2, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _submitModelData();
                            },
                            // Add Expense logic
                            // Expense(title: _enterTitle,)
                            // _saveTitle(value);

                            child: Text(
                              "Add Expense",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  void dispose() {
    titleController.dispose();
    // _dropdownController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _submitModelData() {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (titleController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty &&
        double.parse(amountController.text) > 0 &&
        _selectedDate != null &&
        _selectedCategory != null) {
      LoggeUtils.logInfo(
          "$_TAG  ${titleController.text} and ${amountController.text}");
      _addExpense(Expense(
          title: titleController.text,
          amount: double.parse(amountController.text),
          dateTime: _selectedDate!,
          category: _selectedCategory!));
      Navigator.pop(context);
    } else {
      if (Platform.isIOS) {
        showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
                  title: Text(
                    "Input Error",
                    style: TextStyle(
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8)),
                  ),
                  content: const Text(
                      'Please make sure a valid input is given fields'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('Cancel'))
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    "Input Error",
                    style: TextStyle(
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8)),
                  ),
                  content: const Text(
                      'Please make sure a valid input is given fields'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('Cancel'))
                  ],
                ));
      }
      return;
    }
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _removeExpense(Expense exp) {
    int indexOfExpense = _expenses.indexOf(exp);
    setState(() {
      _expenses.removeAt(indexOfExpense);
    });
    //if we try to remove more than one item, snackbars get stacked one after other,
    // slowly they will up on screen, in that case if we want to fast the snackbar appearing/clearing
    // use clearSnackBars()
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Color.fromARGB(255, 162, 146, 134),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _expenses.insert(indexOfExpense, exp);
              });
            }),
        content: Row(
          // to show title and category in snackbar
          children: [
            Icon(CategoryIcons[exp.category], color: Colors.white),
            // Expense icon
            const SizedBox(width: 10),
            // Spacing
            Expanded(
              // Ensure text doesn't overflow
              child: Text(
                "${exp.title} deleted",
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis, // Handle long text gracefully
              ),
            ),
          ],
        )));
  }
}

//DropdownButton<Categories>(
//                     value: _selectedCategory,
//                     hint: Text("Choose a category"),
//                     isExpanded: true,
//                     items: Categories.values.map((i) {
//                       return DropdownMenuItem(
//                         value: i,
//                         child: Text(i.name.toUpperCase()),
//                       );
//                     }).toList(),
//                     onChanged: (newvalue) {
//                       setState(() {
//                         _selectedCategory = newvalue;
//                       });
//                     }),
