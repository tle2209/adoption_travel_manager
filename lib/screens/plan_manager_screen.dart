import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/plan.dart';
import 'package:uuid/uuid.dart'; // For unique IDs

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  void addPlan(String name, String description, DateTime date) {
    setState(() {
      plans.add(Plan(
        id: Uuid().v4(),
        name: name,
        description: description,
        date: date,
      ));
    });
  }

  void updatePlan(String id, String newName, String newDescription) {
    setState(() {
      var plan = plans.firstWhere((plan) => plan.id == id);
      plan.name = newName;
      plan.description = newDescription;
    });
  }

  void toggleComplete(String id) {
    setState(() {
      var plan = plans.firstWhere((plan) => plan.id == id);
      plan.isCompleted = !plan.isCompleted;
    });
  }

  void deletePlan(String id) {
    setState(() {
      plans.removeWhere((plan) => plan.id == id);
    });
  }

  void showCreatePlanDialog() {
    String name = '';
    String description = '';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Plan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Plan Name"),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Description"),
                onChanged: (value) => description = value,
              ),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text("Select Date"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                addPlan(name, description, selectedDate);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adoption & Travel Plan Manager")),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreatePlanDialog,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Slidable(
            key: ValueKey(plan.id),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => toggleComplete(plan.id),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.check,
                  label: 'Complete',
                ),
                SlidableAction(
                  onPressed: (_) => deletePlan(plan.id),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              title: Text(plan.name,
                  style: TextStyle(
                      decoration: plan.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none)),
              subtitle: Text(plan.description),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String newName = plan.name;
                    String newDescription = plan.description;
                    return AlertDialog(
                      title: Text("Edit Plan"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: "Plan Name"),
                            onChanged: (value) => newName = value,
                            controller: TextEditingController(text: plan.name),
                          ),
                          TextField(
                            decoration:
                                InputDecoration(labelText: "Description"),
                            onChanged: (value) => newDescription = value,
                            controller:
                                TextEditingController(text: plan.description),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            updatePlan(plan.id, newName, newDescription);
                            Navigator.pop(context);
                          },
                          child: Text("Update"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
