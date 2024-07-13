import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onTapCallback;

  const CustomCalendar({super.key, required this.onTapCallback});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
        borderRadius: BorderRadius.circular(15), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            blurRadius: 5, // Shadow blur
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onTapCallback(selectedDay);
        },
        // headerVisible: false,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false, // Hide the format button
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: const Color.fromARGB(255, 170, 59, 62),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          defaultDecoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
          ),
          todayDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10), // Rounded rectangle
            border: Border.all(
              color:
                  const Color.fromARGB(255, 170, 59, 62), // White border color
              width: 2.0, // Adjust the width of the border as needed
            ),
          ),
          todayTextStyle: const TextStyle(
            color: Colors.black, // Text color for today's date
            fontWeight: FontWeight.normal, // Optional: make the text bold
          ),
          outsideDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10)),
          weekendTextStyle: const TextStyle(color: Colors.black),
          defaultTextStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
