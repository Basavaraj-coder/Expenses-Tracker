import 'package:expenses_tracker/LoggerUtil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Model Class
// Uses DateFormat.yMEd() from the intl package to convert DateTime into a readable
// date string (e.g., "Wed, Mar 27, 2024")
/*
* y → Year (e.g., 2024)
🔹 M → Month (e.g., Mar)
🔹 E → Day of the Week (e.g., Thu)
🔹 d → Day of the Month (e.g., 28)
* */
final dateFormatter = DateFormat.yMEd(); //Formatter to format date
const uuid =
    Uuid(); //this is just utility file, we can use this anywhere in our file to generate unique id's

enum Categories {
  food,
  travel,
  work,
  investment,
  leisure, //movie/gaming/trip/party
  doctor,
  policies,
  homeEssentials,
}

const CategoryIcons = {
  Categories.food: Icons.lunch_dining,
  Categories.travel: Icons.flight_takeoff,
  Categories.leisure: Icons.movie,
  Categories.work: Icons.work,
  Categories.investment: Icons.monetization_on,
  Categories.doctor: Icons.local_hospital_outlined,
  Categories.policies: Icons.policy_outlined,
  // Categories.homeEssentials:
  //     ImageIcon(AssetImage('assets\\images\\household-appliance.png'))
};

class Expense {
  // Initializer List (: id = uuid.v4();)
  // Before the constructor body executes, id is assigned a UUID (Universally Unique Identifier) using uuid.v4().
  // uuid.v4() generates a random unique ID every time a new Expense object is created

  // Why Use an Initializer List?
  // Ensures that id is initialized before the object is created.
  // Avoids needing a separate constructor body for initialization.
  // Helps keep id immutable (final String id), as it’s assigned once at object creation.

  Expense(
      {required this.title,
      required this.amount,
      required this.dateTime,
      required this.category})
      : id = uuid.v4();

  // need to use uuid package for :-
  final String
      id; // to generate unique id, whenever expenses are added id should be generated unique automatically
  final String title;
  final double amount;
  final DateTime dateTime;
  final Categories category;

  String get getFormattedDate {
    LoggeUtils.logInfo(dateTime.toString());
    return dateFormatter.format(dateTime);
  }
}

//need one new class to sum up all the expenses belongs to a category, becoz we
// --need to add it to chart
class ExpenseBucket {
  final Categories category;
  final List<Expense> expenses;

  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (var exp in expenses) {
      sum += exp.amount;
    }
    return sum;
  }
}
