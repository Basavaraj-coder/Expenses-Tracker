import 'package:expenses_tracker/models/Expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCalendar extends StatefulWidget {
  //this callback says that, hey pass a callback function from expenses.dart, this will process and
  // return the value to parent widget(expenses.dart) again
  final Function(DateTime) onDateSelected;
  const AddCalendar({super.key,required this.onDateSelected});

  @override
  State<AddCalendar> createState() => _AddCalendarState();
}

class _AddCalendarState extends State<AddCalendar> {
  DateTime? _selectedDate; // Selected date

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime.now().add(Duration(days: 30)), // Maximum date,
      // add(Duration days:30) is for showing next month calendar aswell from DateTime.now()
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      // we can access createState class members using widget keyword
      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // **Date Picker for Selecting Date**
          const Text("Pick Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(
                _selectedDate == null
                    ? "No date selected"
                    : dateFormatter.format(_selectedDate!),
                //DateFormat.yMEd().format(_selectedDate!)
                // Formats date like "March 28, 2024"
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              Tooltip(
                message: 'Please select date here',
                child: IconButton(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_month_sharp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
