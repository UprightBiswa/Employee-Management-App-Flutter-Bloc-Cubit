import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/config/app_colors.dart';
import '../../core/models/employee_model.dart';
import '../../logic/cubit/employee_cubit.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_todate_picker.dart';

class AddEditEmployeePage extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeePage({super.key, this.employee});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _selectedRole;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _selectedRole = widget.employee?.role;
    _fromDate = widget.employee?.joiningDate;
    _toDate = widget.employee?.leavingDate;
  }

  void _pickFromDate() {
    showDialog(
      context: context,
      builder: (context) => CustomDatePicker(
        selectedDate: _fromDate ?? DateTime.now(),
        onDateSelected: (date) {
          setState(() {
            _fromDate = date;
            if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
              _toDate = null;
            }
          });
        },
      ),
    );
  }

  void _pickToDate() {
    showDialog(
      context: context,
      builder: (context) => CustomTODatePicker(
        selectedDate: _toDate ?? _fromDate ?? DateTime.now(),
        firstDate: _fromDate ?? DateTime.now(),
        onDateSelected: (date) {
          if (_fromDate != null && date!.isBefore(_fromDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("To Date can't be before From Date")),
            );
          } else {
            setState(() => _toDate = date);
          }
        },
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      //check joiningDate _fromDate is not nullshow validation
      // if (_fromDate == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Please select Joining Date")),
      //   );
      //   return;
      // }
      final employee = Employee(
        id: widget.employee?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        role: _selectedRole ?? '',
        joiningDate: _fromDate ?? DateTime.now(),
        leavingDate: _toDate,
      );
      if (widget.employee == null) {
        context.read<EmployeeCubit>().addEmployee(employee);
      } else {
        context.read<EmployeeCubit>().updateEmployee(employee);
      }
      Navigator.pop(context);
    }
  }

  void _deleteEmployee() {
    if (widget.employee != null) {
      context.read<EmployeeCubit>().deleteEmployee(context, widget.employee!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.employee == null
            ? "Add Employee Details"
            : "Edit Employee Details"),
        actions: widget.employee != null
            ? [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                  onPressed: _deleteEmployee,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: "Employee Name",
                icon: Icons.person_outline_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomDropdown(
                hintText: "Select Role",
                items: const ["Manager", "Developer", "Designer", "HR"],
                value: _selectedRole,
                onChanged: (value) => setState(() => _selectedRole = value),
                icon: Icons.work_outline_rounded,
                validator: (value) =>
                    value == null ? "Please select a role" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickFromDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(
                              _fromDate == null
                                  ? "Today"
                                  : DateFormat("d MMM yy").format(_fromDate!),
                              style: TextStyle(
                                  color: _fromDate == null
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.blue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickToDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined,
                                color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(
                              _toDate == null
                                  ? "No Date"
                                  : DateFormat("d MMM yy").format(_toDate!),
                              style: TextStyle(
                                  color: _toDate == null
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF2F2F2), width: 2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  surfaceTintColor: Colors.white,
                  foregroundColor: Colors.blue,
                  shadowColor: Colors.blue.withOpacity(0.1),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
