import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/database/local_db.dart';
import '../../core/models/employee_model.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeeLoading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await LocalDB().initDB();
    await loadEmployees();
  }

  Future<void> loadEmployees() async {
    emit(EmployeeLoading());
    final employees = await LocalDB().getEmployees();
    emit(EmployeeLoaded(employees));
  }

  Future<void> addEmployee(Employee employee) async {
     emit(EmployeeLoading());
    await LocalDB().addEmployee(employee);
    await loadEmployees();
  }

  Future<void> updateEmployee(Employee employee) async {
    emit(EmployeeLoading());
    await LocalDB().updateEmployee(employee);
    await loadEmployees();
  }

  Future<void> deleteEmployee(BuildContext context, Employee employee) async {
    final deletedEmployee = employee;
    emit(EmployeeLoading());
    final cubit = BlocProvider.of<EmployeeCubit>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Employee data has been deleted"),
        action: SnackBarAction(
          label: "Undo",
          textColor: Colors.blue,
          onPressed: () {
            cubit.addEmployee(deletedEmployee);
          },
        ),
      ),
    );

    await LocalDB().deleteEmployee(employee.id);
    await loadEmployees();
  }
}
