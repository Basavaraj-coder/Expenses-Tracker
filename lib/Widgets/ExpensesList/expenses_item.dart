import 'package:expenses_tracker/models/Expense.dart';
import 'package:flutter/material.dart';

class ExpensesItem extends StatelessWidget {
  const ExpensesItem(
    this.expenseModel, {
    super.key,
  });

  final Expense expenseModel;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            Text(
              expenseModel.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.8)
              ),
            ), //
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  '${expenseModel.category.toString().substring(11)} ',
                  style: TextStyle(
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8)),
                ),
                Icon(CategoryIcons[expenseModel.category]),
                //category wise icon attach
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "| Amount : ${expenseModel.amount.toStringAsFixed(2)}\u20B9",
                  style: TextStyle(
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8)),
                ),
                //to trim value only 2 digits after decimal
                //\$ is to print dollar sign in front of amount
                const Spacer(),
                //When you need flexible spacing between widgets inside a Row or Column.
                //When you want the space to adjust dynamically based on screen size.
                //       The Spacer takes all the extra space, pushing "row" to the right.
                Row(
                  children: [
                    Icon(Icons.calendar_month),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(expenseModel.getFormattedDate,
                        style: TextStyle(
                            color: isDarkMode
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8))),
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
