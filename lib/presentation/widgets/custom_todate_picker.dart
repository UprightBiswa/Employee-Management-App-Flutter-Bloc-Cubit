import 'package:employee_app/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CustomTODatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  // firstDate
  final DateTime? firstDate;
  final Function(DateTime?) onDateSelected;

  const CustomTODatePicker({
    super.key,
    required this.selectedDate,
    this.firstDate,
    required this.onDateSelected,
  });

  @override
  State<CustomTODatePicker> createState() => _CustomToDatePickerState();
}

class _CustomToDatePickerState extends State<CustomTODatePicker> {
  late DateTime? _selectedDay;
  late String _selectedButton;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDate;
    _selectedButton = widget.selectedDate == null ? "No Date" : "Today";
  }

  void _selectQuickDate(String label, DateTime? date) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickSelectButton("No Date", null),
              const SizedBox(width: 10),
              _quickSelectButton("Today", DateTime.now()),
            ],
          ),
          const SizedBox(height: 12),
          TableCalendar(
            focusedDay: _selectedDay ?? DateTime.now(),
            availableCalendarFormats: const {
              CalendarFormat.month: "Month",
            },
            firstDay: widget.firstDate ?? DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _selectedButton = "";
              });
            },
            calendarStyle: const CalendarStyle(
              selectedTextStyle: TextStyle(color: AppColors.primary),
              todayTextStyle: TextStyle(color: AppColors.primary),
              todayDecoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(
                    color: AppColors.primary,
                    width: 1,
                  ),
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined,
                    color: Colors.blue, size: 20),
                const SizedBox(width: 5),
                Text(
                  _selectedDay == null
                      ? "No Date"
                      : DateFormat("d MMM yyyy").format(_selectedDay!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
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

  Widget _quickSelectButton(String label, DateTime? date) {
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
}
