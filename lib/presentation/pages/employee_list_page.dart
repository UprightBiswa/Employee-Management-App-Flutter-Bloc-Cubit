import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../core/models/employee_model.dart';
import '../../logic/cubit/employee_cubit.dart';
import '../../logic/cubit/employee_state.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(title: const Text("Employee List")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(
              child: CircularProgressIndicator(), // Show loading spinner
            );
          } else if (state is EmployeeLoaded) {
            final employees = state.employees;
            if (employees.isNotEmpty) {
              final currentEmployees =
                  employees.where((e) => e.isCurrentEmployee).toList();
              final previousEmployees =
                  employees.where((e) => !e.isCurrentEmployee).toList();

              return ListView(
                children: [
                  if (currentEmployees.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Current Employees",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1DA1F2),
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentEmployees.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 1),
                      itemBuilder: (context, index) {
                        final employee = currentEmployees[index];
                        return _buildEmployeeTile(
                          context,
                          employee,
                          isCurrent: true,
                        );
                      },
                    ),
                    // _buildEmployeeTile(context, employee, isCurrent: true)),
                  ],
                  if (previousEmployees.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Previous Employees",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1DA1F2),
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: previousEmployees.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 1),
                      itemBuilder: (context, index) {
                        final employee = previousEmployees[index];
                        return _buildEmployeeTile(
                          context,
                          employee,
                          isCurrent: false,
                        );
                      },
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Swipe left to delete",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              );
            } else {
              return _buildNoDataView();
            }
          } else {
            return _buildNoDataView();
          }
        },
      ),
    );
  }
}

Widget _buildEmployeeTile(
  BuildContext context,
  Employee employee, {
  required bool isCurrent,
}) {
  return Slidable(
    key: ValueKey(employee.id),
    endActionPane: ActionPane(
      extentRatio: 0.3,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) {
            final cubit =
                BlocProvider.of<EmployeeCubit>(context, listen: false);
            cubit.deleteEmployee(context, employee);
          },
          backgroundColor: const Color(0xFFf34642),
          foregroundColor: Colors.white,
          icon: Icons.delete_outline_rounded,
        ),
      ],
    ),
    child: ListTile(
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      onTap: () => context.push('/add', extra: employee),
      title: Text(employee.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.role, style: const TextStyle(fontSize: 14)),
          Text(
            isCurrent
                ? "From ${_formatDate(employee.joiningDate)}"
                : "${_formatDate(employee.joiningDate)} - ${_formatDate(employee.leavingDate!)}",
          ),
        ],
      ),
    ),
  );
}

Widget _buildNoDataView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/nodata.png',
          width: 260,
          height: 240,
        ),
      ],
    ),
  );
}

String _formatDate(DateTime date) {
  return "${date.day} ${_monthName(date.month)}, ${date.year}";
}

String _monthName(int month) {
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return months[month - 1];
}
