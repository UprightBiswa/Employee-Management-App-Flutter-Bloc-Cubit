import 'package:employee_app/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late String _selectedButton;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate;
    _selectedDay = widget.selectedDate;
    _selectedButton = "Today"; // Default selected button
  }

  void _selectQuickDate(String label, DateTime date) {
    setState(() {
      _selectedDay = date;
      _selectedButton = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _quickSelectButton("Today", DateTime.now()),
              const SizedBox(width: 10),
              _quickSelectButton("Next Monday", _nextMonday()),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              _quickSelectButton("Next Tuesday", _nextTuesday()),
              const SizedBox(width: 10),
              _quickSelectButton(
                  "After 1 Week", DateTime.now().add(const Duration(days: 7))),
            ],
          ),
          const SizedBox(height: 12),
          TableCalendar(
            focusedDay: _focusedDay,
            availableCalendarFormats: const {
              CalendarFormat.month: "Month",
            },
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedButton = "";
              });
            },
            calendarStyle: const CalendarStyle(
              selectedTextStyle: TextStyle(color: AppColors.primary),
              todayDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(BorderSide(
                  color: AppColors.primary,
                  width: 1,
                )),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: [
        Divider(
          color: Colors.grey.shade200,
          height: 0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: Colors.blue, size: 20),
                const SizedBox(width: 5),
                Text(
                  DateFormat("d MMM yyyy").format(_selectedDay),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    surfaceTintColor: Colors.white,
                    foregroundColor: Colors.blue,
                    shadowColor: Colors.blue.withOpacity(0.1),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    widget.onDateSelected(_selectedDay);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickSelectButton(String label, DateTime date) {
    bool isSelected = _selectedButton == label;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _selectQuickDate(label, date),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor:
              isSelected ? Colors.blue : Colors.blue.withOpacity(0.1),
          foregroundColor: isSelected ? Colors.white : Colors.blue,
          shadowColor: Colors.blue.withOpacity(0.1),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  DateTime _nextMonday() {
    return DateTime.now().add(
        Duration(days: (DateTime.monday - DateTime.now().weekday + 7) % 7));
  }

  DateTime _nextTuesday() {
    return DateTime.now().add(
        Duration(days: (DateTime.tuesday - DateTime.now().weekday + 7) % 7));
  }
}
