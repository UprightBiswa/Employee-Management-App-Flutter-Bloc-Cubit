class Employee {
  String id;
  String name;
  String role;
  DateTime joiningDate;
  DateTime? leavingDate; // Nullable for current employees

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.joiningDate,
    this.leavingDate,
  });

  bool get isCurrentEmployee => leavingDate == null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'joiningDate': joiningDate.toIso8601String(),
      'leavingDate': leavingDate?.toIso8601String(), // Store null if not left yet
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      joiningDate: DateTime.parse(map['joiningDate']),
      leavingDate: map['leavingDate'] != null ? DateTime.parse(map['leavingDate']) : null,
    );
  }
}
