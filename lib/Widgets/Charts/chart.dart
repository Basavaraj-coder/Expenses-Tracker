import 'package:flutter/material.dart';
import 'package:expenses_tracker/Widgets/Charts/chart_bar.dart';
import 'package:expenses_tracker/models/Expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Categories.food),
      ExpenseBucket.forCategory(expenses, Categories.leisure),
      ExpenseBucket.forCategory(expenses, Categories.travel),
      ExpenseBucket.forCategory(expenses, Categories.work),
      ExpenseBucket.forCategory(expenses, Categories.investment),
      ExpenseBucket.forCategory(expenses, Categories.policies),
      // ExpenseBucket.forCategory(expenses, Categories.homeEssentials),
      ExpenseBucket.forCategory(expenses, Categories.doctor),
    ];
    // // ExpenseBucket.forCategory(expenses, Categories.doctor),
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Stack(
      children: [
        // 🔹 Grid background with blur effect
        Positioned.fill(
          child: CustomPaint(
            painter: GridPainter(isDarkMode: isDarkMode),
          ),
        ),

        // 🔹 Main Chart Container,
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 8,
          ),
          width: double.infinity, //this means consume as much as width avail of screen
          height: 200,
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
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final bucket in buckets) // alternative to map()
                      ChartBar(
                        fill: bucket.totalExpenses == 0
                            ? 0
                            : bucket.totalExpenses / maxTotalExpense,
                        // explanation
                        /*Assume:maxTotalExpense = 1000
Individual expenses:
Food: $500 → 500 / 1000 = 0.5 (50% height)
Travel: $300 → 300 / 1000 = 0.3 (30% height)
Shopping: $700 → 700 / 1000 = 0.7 (70% height)
Each bar gets a fractional height relative to the highest expense.
                        * */
                        expenseAmount: bucket.totalExpenses,
                      )
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: buckets
                    .map(
                      (bucket) => Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Tooltip(
                              message: bucket.category.name,
                              child: Icon(
                                CategoryIcons[bucket.category],
                                color: isDarkMode
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7),
                              ),
                            )),
                      ),
                    )
                    .toList(),
              ),
              Text(
                "Tips:- Click/Hover on above icons to know more",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline, // 🔹 Underline the text
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final bool isDarkMode;

  GridPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode
          ? Colors.white.withOpacity(0.10) // Light grid for dark mode
          : Colors.black.withOpacity(0.10) // Dark grid for light mode
      ..strokeWidth = 5.0;

    final blurPaint = Paint()
      ..color = paint.color
      ..strokeWidth = 2.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.3); // 🔹 Blur Effect

    int rowCount = 5; // Number of horizontal gridlines
    int colCount = 6; // Number of vertical gridlines

    double rowSpacing = size.height / rowCount;
    double colSpacing = size.width / colCount;

    // 🔹 Draw horizontal gridlines
    for (int i = 0; i <= rowCount; i++) {
      double y = i * rowSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), blurPaint);
    }

    // 🔹 Draw vertical gridlines
    for (int i = 0; i <= colCount; i++) {
      double x = i * colSpacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), blurPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
