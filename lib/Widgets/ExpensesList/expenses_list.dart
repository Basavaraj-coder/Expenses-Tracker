import 'package:expenses_tracker/Widgets/ExpensesList/expenses_item.dart';
import 'package:expenses_tracker/models/Expense.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses,required this.removeExpenseItem,});

  final List<Expense> expenses;
  final void Function(Expense exp) removeExpenseItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //expanded is used here becos, we r using nested scrollable widgets
      // i.e listview inside column in (expenses.dart file), so we need to use expanded to work properly
      // what is does is expanded allows a listview to occupy full column height,
      // and it will not result in Layout overflow issues (yellow/black screen error).
      // Scroll conflict where only one of them scrolls properly.
      child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(expenses[index]),
              direction: DismissDirection.startToEnd,
              onDismissed:(direction){
                removeExpenseItem(expenses[index]);//after dismiss atually data should delete/removed from list
              },
              child: ExpensesItem(expenses[index]),
            );
          }),
    );
  }
}

// ListTile(
//               title: Column(
//             children: [
//               Text(expenses[index].title),
//               Text(expenses[index].amount.toString()),
//               Text(expenses[index].category),
//               Text(expenses[index].dateTime.toString()),
//             ],
//           ));

//Column(
//             children: [
//               Text(expenses[index].id),
//               Text(expenses[index].title),
//               Text(expenses[index].amount.toString()),
//               Text(expenses[index].category),
//               Text(expenses[index].dateTime.toString()),
//             ],
//           );
