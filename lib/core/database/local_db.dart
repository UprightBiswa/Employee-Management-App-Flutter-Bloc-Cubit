import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path_provider/path_provider.dart';
import '../config/constants.dart';
import '../models/employee_model.dart';

class LocalDB {
  static final LocalDB _instance = LocalDB._internal();
  factory LocalDB() => _instance;
  LocalDB._internal();

  Database? _database;
  final _store = intMapStoreFactory.store("employees");

  Future<Database> get database async {
    if (_database == null) {
      await initDB();
    }
    return _database!;
  }

  // Future<void> initDB() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final dbPath = "${dir.path}/${AppConstants.dbName}";
  //   _database = await databaseFactoryIo.openDatabase(dbPath);
  // }

   /// Initialize DB based on platform
  Future<void> initDB() async {
    if (kIsWeb) {
      // Web Database Initialization
      _database = await databaseFactoryWeb.openDatabase(AppConstants.dbName);
    } else {
      // Mobile/Desktop Database Initialization
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = "${dir.path}/${AppConstants.dbName}";
      _database = await databaseFactoryIo.openDatabase(dbPath);
    }
  }

  Future<void> addEmployee(Employee employee) async {
    final db = await database;

    final existing = await _store.findFirst(
      db,
      finder: Finder(filter: Filter.equals("id", employee.id)),
    );

    if (existing == null) {
      await _store.add(db, employee.toMap());
      print("Employee added: ${employee.toMap()}");
    } else {
      print("Duplicate Employee found: ${employee.toMap()}");
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    final db = await database;
    final finder = Finder(filter: Filter.equals("id", employee.id));

    final existing = await _store.findFirst(db, finder: finder);
    if (existing != null) {
      await _store.update(db, employee.toMap(), finder: finder);
      print("Employee updated: ${employee.toMap()}");
    } else {
      print("Update Failed: Employee not found with id: ${employee.id}");
    }
  }

  Future<void> deleteEmployee(String id) async {
    final db = await database;
    final finder = Finder(filter: Filter.equals("id", id));

    final existing = await _store.findFirst(db, finder: finder);
    if (existing != null) {
      await _store.delete(db, finder: finder);
      print("Employee deleted: $id");
    } else {
      print("Delete Failed: Employee not found with id: $id");
    }
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final records = await _store.find(db);

    final employees = records.map((snapshot) {
      final data = snapshot.value;
      return Employee.fromMap(data as Map<String, dynamic>);
    }).toList();

    print("Employees List: ${employees.map((e) => e.toMap()).toList()}");

    return employees;
  }
}
