import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<double> onMoneyChange;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(Task) onDelete;
  final Function(Task) onEditTitle;
  final Function(Task) onEditMoney;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEditTitle,
    required this.onEditMoney,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onEditMoney(task),
      onDoubleTap: () => onEditTitle(task),
      onLongPress: () => onDelete(task),
      child: Card(
        child: ListTile(
          title: Text(task.title),
          subtitle: Text('Saved: \$${task.savedMoney.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}

