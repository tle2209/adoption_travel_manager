import 'package:uuid/uuid.dart';

class Plan {
  String id;
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  // Constructor
  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false, // Default to incomplete
  });

  // Factory method to create a new Plan with a unique ID
  factory Plan.create({required String name, required String description, required DateTime date}) {
    return Plan(
      id: Uuid().v4(), // Generate a unique ID
      name: name,
      description: description,
      date: date,
      isCompleted: false,
    );
  }

  // Convert Plan object to a Map (for saving to local storage or database)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Convert a Map to a Plan object (for loading from storage)
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
    );
  }
}
