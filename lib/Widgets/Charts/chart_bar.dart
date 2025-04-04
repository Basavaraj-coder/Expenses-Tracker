import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({
    super.key,
    required this.fill,
    required this.expenseAmount, // 🔹 Added expense amount
  });

  final double fill;
  final double expenseAmount; // 🔹 Expense amount for the bar

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Expanded(
      child: Column(
        // ✅ Column ensures both label and bar are displayed
        children: [
          // 🔹 Expense label above the bar
          Text(
            '\u20B9${expenseAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4), // 🔹 Space between text and bar
          Expanded(
            // ✅ This ensures the bar takes the remaining space
            child: Align(
              alignment: Alignment.bottomCenter,
              // 🔹 Ensure bar starts at bottom
              child: FractionallySizedBox(
                heightFactor: fill.clamp(0.0, 1.0), // 🔹 Ensure valid height,
                child: Container(
                  width: 20, // 🔹 Fixed width so bars are visible
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isDarkMode
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.65),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ); /*Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: fill,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(8)),
              color: isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );*/
  }
}
