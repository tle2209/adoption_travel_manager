import 'package:uuid/uuid.dart';

class Plan {
  String id;
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.isCompleted = false,
  });

  factory Plan.create({required String name, required String description, required DateTime date}) {
    return Plan(
      id: Uuid().v4(),
      name: name,
      description: description,
      date: date,
    );
  }
}
